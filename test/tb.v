`timescale 1ns/1ps

module tb;

    reg clk;
    reg rst_n;
    reg ena;

    reg  [7:0] ui_in;
    wire [7:0] uo_out;

    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // DUT
    tt_um_tpu_braun dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Clock generation (20ns period = 50MHz)
    initial clk = 0;
    always #10 clk = ~clk;

    // Dump waveform
    initial begin
        $dumpfile("tb.fst");
        $dumpvars(0, tb);
    end

endmodule
