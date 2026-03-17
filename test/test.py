import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_tpu_3x3(dut):
    dut._log.info("🚀 Starting 3x3 TPU Test")

    # Clock (50MHz → 20ns period)
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
    # Start TPU
    # -------------------------
    dut.ena.value = 1

    # -------------------------
    # LOAD MATRIX A (3 cycles)
    # Example: A = [2, 3, 4]
    # -------------------------
    dut._log.info("Loading Matrix A")

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 3
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 4
    await ClockCycles(dut.clk, 1)

    # -------------------------
    # LOAD MATRIX B (3 cycles)
    # Example: B = [1, 2, 3]
    # -------------------------
    dut._log.info("Loading Matrix B")

    dut.ui_in.value = 1
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 3
    await ClockCycles(dut.clk, 1)

    # Stop loading
    dut.ena.value = 0

    # -------------------------
    # Wait for COMPUTE + DELAY
    # -------------------------
    dut._log.info("Waiting for computation...")
    await ClockCycles(dut.clk, 15)

    # -------------------------
    # READ OUTPUT STREAM
    # -------------------------
    dut._log.info("Reading output stream (9 values expected)")

    for i in range(9):
        await ClockCycles(dut.clk, 1)

        result = int(dut.uo_out.value)
        index  = int(dut.uio_out.value) & 0xF

        dut._log.info(f"Output[{index}] = {result}")

    dut._log.info("✅ TPU Test Completed")
