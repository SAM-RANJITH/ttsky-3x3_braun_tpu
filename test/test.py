import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


def golden_model(A, B):
    """Simple 1D multiply (adjust if 3x3 full matrix)"""
    return [a * b for a, b in zip(A, B)]


@cocotb.test()
async def test_tpu_3x3(dut):
    dut._log.info("🚀 Starting TPU Test")

    # Clock
    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    # -------------------------
    # Reset
    # -------------------------
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 5)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # -------------------------
    # Input Data
    # -------------------------
    A = [2, 3, 4]
    B = [1, 2, 3]

    expected = golden_model(A, B)
    dut._log.info(f"Expected: {expected}")

    # -------------------------
    # LOAD PHASE
    # -------------------------
    dut.ena.value = 1
    dut._log.info("Loading A")

    for val in A:
        dut.ui_in.value = val
        await ClockCycles(dut.clk, 1)

    dut._log.info("Loading B")

    for val in B:
        dut.ui_in.value = val
        await ClockCycles(dut.clk, 1)

    dut.ena.value = 0

    # -------------------------
    # COMPUTE WAIT
    # -------------------------
    await ClockCycles(dut.clk, 25)

    # -------------------------
    # OUTPUT READ
    # -------------------------
    outputs = {}

    for _ in range(12):
        await ClockCycles(dut.clk, 1)

        if not dut.uo_out.value.is_resolvable:
            raise Exception("❌ uo_out has X/Z")

        if not dut.uio_out.value.is_resolvable:
            raise Exception("❌ uio_out has X/Z")

        result = int(dut.uo_out.value)
        index = int(dut.uio_out.value) & 0xF

        outputs[index] = result
        dut._log.info(f"Output[{index}] = {result}")

    # -------------------------
    # CHECK RESULTS
    # -------------------------
    dut._log.info("Checking results...")

    for i, exp in enumerate(expected):
        if i in outputs:
            assert outputs[i] == exp, \
                f"Mismatch at {i}: got {outputs[i]}, expected {exp}"
        else:
            raise Exception(f"Missing output index {i}")

    dut._log.info("✅ TEST PASSED")
