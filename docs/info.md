## How it works

This project implements a 3×3 Tensor Processing Unit (TPU) using a systolic array architecture with Braun multipliers, designed for the Tiny Tapeout ASIC platform.

The design performs matrix multiplication using a grid of interconnected Processing Elements (PEs). Each PE carries out a multiply-accumulate (MAC) operation, enabling parallel computation across the array.

The architecture consists of:

3×3 Systolic Array
A network of 9 Processing Elements where data flows rhythmically across rows and columns.

Braun Multiplier-Based PEs
Each PE multiplies input data and accumulates partial results efficiently.

Delay Alignment (Delay Cells)
Input data is delayed appropriately to ensure correct timing and synchronization across the systolic array.

Control Unit (FSM)
Manages different phases of operation:

Load Matrix A

Load Matrix B

Compute

Output results

Input Loader
Streams input data into the systolic array in a sequential manner.

Output Multiplexer & Serializer
Collects computed results and outputs them sequentially through limited I/O pins.

## Operation Flow

Input data is provided serially through the ui_in[7:0] pins.

The control unit loads matrix elements into internal registers.

Data flows through the systolic array:

A values move left → right

B values move top → bottom

Each PE performs multiply-accumulate operations.

Results propagate through the array and are stored internally.

The output multiplexer streams results (c00 → c22) sequentially.

This design demonstrates how parallel matrix computation can be implemented efficiently in hardware using a systolic architecture within strict area constraints.

## How to test

Apply a clock signal to the design.

Assert reset (rst_n = 0 → 1).

Enable the design by setting:

ena = 1

Provide input data through:

ui_in[7:0]

Example sequence:

First 3 cycles → Matrix A

Next 3 cycles → Matrix B

Wait for computation to complete (few cycles due to pipeline + delay).

Observe outputs:

## Outputs

uo_out[7:0] → Result data (streamed)

uio_out[3:0] → Output index (0 to 8)

uio_out[4] → Done signal

uio_out[5] → Valid signal

## Output Behavior

Results are streamed in order:

c00 → c01 → c02 → c10 → c11 → c12 → c20 → c21 → c22
## External hardware

No external hardware is required.

The design can be tested using:

Verilog simulation (testbench or cocotb)

Tiny Tapeout test infrastructure
