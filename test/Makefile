# Makefile for 3x3 Braun TPU (Tiny Tapeout)

SIM ?= icarus
FST ?= -fst
TOPLEVEL_LANG ?= verilog

SRC_DIR = $(PWD)/../src

PROJECT_SOURCES = \
tt_um_tpu_braun.v \
systolic_array_3x3.v \
pe_braun.v \
braun_multiplier.v \
control_unit.v \
input_loader.v \
output_mux.v \
delay_cell.v

ifneq ($(GATES),yes)

# -----------------------------
# RTL Simulation
# -----------------------------
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# -----------------------------
# Gate Level Simulation
# -----------------------------
SIM_BUILD = sim_build/gl

COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1

VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Include headers if needed
COMPILE_ARGS += -I$(SRC_DIR)

# Testbench
VERILOG_SOURCES += $(PWD)/tb.v

TOPLEVEL = tb

# Cocotb Python test file (test.py)
COCOTB_TEST_MODULES = test

# Enable waveform (VERY IMPORTANT)
WAVES = 1

# Cocotb rules
include $(shell cocotb-config --makefiles)/Makefile.sim
