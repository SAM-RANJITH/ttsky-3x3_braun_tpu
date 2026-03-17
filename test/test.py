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

    # keep reset active for a few cycles
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
    # extra cycles to let gate-level logic settle
    await ClockCycles(dut.clk, 25)

    # -------------------------
    # READ OUTPUT STREAM
    # -------------------------
    dut._log.info("Reading output stream (9 values expected)")

    results = {}

    for i in range(9):
        await ClockCycles(dut.clk, 1)

        val_out = dut.uo_out.value
        val_idx = dut.uio_out.value

        # If there are X/Z, fail with a clear message instead of ValueError
        if (not val_out.is_resolvable) or (not val_idx.is_resolvable):
            dut._log.error(
                f"X/Z on outputs at cycle {i}: "
                f"uo_out={val_out.binstr}, uio_out={val_idx.binstr}"
            )
            raise AssertionError("Output contains X/Z, check reset/logic or timing")

        result = val_out.integer
        index = val_idx.integer & 0xF

        results[index] = result
        dut._log.info(f"Output[{index}] = {result}")

    # Optional: simple sanity check, e.g. we got 9 unique indices
    assert len(results) == 9, f"Expected 9 outputs, got {len(results)}"
    dut._log.info("✅ TPU Test Completed")
