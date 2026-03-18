import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


async def apply_vector(dut, val_ui, val_uio):
    """Apply one vector (same as Verilog task)"""
    dut.ui_in.value = val_ui
    dut.uio_in.value = val_uio
    await RisingEdge(dut.clk)


@cocotb.test()
async def test_tpu_vectors(dut):
    dut._log.info("🚀 Starting Vector-Based TPU Test")

    # -------------------------
    # Clock (50 MHz)
    # -------------------------
    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    # -------------------------
    # Init + Reset
    # -------------------------
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    await ClockCycles(dut.clk, 2)
    dut.ena.value = 1

    # =========================
    # TEST VECTOR SET 1
    # =========================
    dut._log.info("---- TEST 1 ----")

    # A inputs
    await apply_vector(dut, 2, 0)
    await apply_vector(dut, 3, 0)
    await apply_vector(dut, 4, 0)

    # B inputs
    await apply_vector(dut, 1, 0)
    await apply_vector(dut, 2, 0)
    await apply_vector(dut, 3, 0)

    dut.ena.value = 0

    # Wait for compute
    await ClockCycles(dut.clk, 30)

    # -------------------------
    # Read Outputs
    # -------------------------
    dut._log.info("---- OUTPUT STREAM ----")

    for _ in range(15):
        await RisingEdge(dut.clk)

        out_val = dut.uo_out.value
        idx_val = dut.uio_out.value

        dut._log.info(
            f"Time={cocotb.utils.get_sim_time('ns')} ns | "
            f"OUT={out_val} | IDX={idx_val}"
        )

    # =========================
    # TEST VECTOR SET 2
    # =========================
    dut.ena.value = 1
    dut._log.info("---- TEST 2 ----")

    # A inputs
    await apply_vector(dut, 5, 0)
    await apply_vector(dut, 6, 0)
    await apply_vector(dut, 7, 0)

    # B inputs
    await apply_vector(dut, 1, 0)
    await apply_vector(dut, 1, 0)
    await apply_vector(dut, 1, 0)

    dut.ena.value = 0

    await ClockCycles(dut.clk, 30)

    for _ in range(15):
        await RisingEdge(dut.clk)

        out_val = dut.uo_out.value
        idx_val = dut.uio_out.value

        dut._log.info(
            f"Time={cocotb.utils.get_sim_time('ns')} ns | "
            f"OUT={out_val} | IDX={idx_val}"
        )

    dut._log.info("✅ Test Completed")
