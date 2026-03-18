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

    // Waveform dump
    initial begin
        $dumpfile("tb.fst");
        $dumpvars(0, tb);
    end

    // Stimulus
    initial begin
        // Initialize
        rst_n  = 0;
        ena    = 0;
        ui_in  = 8'd0;
        uio_in = 8'd0;

        // Apply reset
        #50;
        rst_n = 1;
        ena   = 1;

        // ---- Test Case 1 ----
        // Example input (change based on your TPU mapping)
        #20;
        ui_in = 8'h12;
        uio_in = 8'h34;

        // ---- Test Case 2 ----
        #40;
        ui_in = 8'hAA;
        uio_in = 8'h55;

        // ---- Test Case 3 ----
        #40;
        ui_in = 8'h0F;
        uio_in = 8'hF0;

        // Wait and finish
        #100;
        $finish;
    end

endmodule
