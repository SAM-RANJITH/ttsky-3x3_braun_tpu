`timescale 1ns/1ps

module tb;

    reg clk;
    reg rst_n;
    reg ena;

    reg [7:0] ui_in;
    reg [7:0] uio_in;

    wire [7:0] uo_out;
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz
    end

    // Stimulus
    initial begin
        // Initialize
        rst_n = 0;
        ena   = 0;
        ui_in = 0;
        uio_in = 0;

        #20;
        rst_n = 1;

        // Start operation
        #10;
        ena = 1;

        // -------------------------
        // Load Matrix A (3 values)
        // -------------------------
        // A = [2,3,4]
        #10 ui_in = 8'd2;
        #10 ui_in = 8'd3;
        #10 ui_in = 8'd4;

        // -------------------------
        // Load Matrix B (3 values)
        // -------------------------
        // B = [1,2,3]
        #10 ui_in = 8'd1;
        #10 ui_in = 8'd2;
        #10 ui_in = 8'd3;

        // Stop loading
        #10 ena = 0;

        // Wait for computation + output
        #200;

        $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time\tOutput\tIndex");
        $monitor("%0t\t%d\t%d", $time, uo_out, uio_out[3:0]);
    end

endmodule
