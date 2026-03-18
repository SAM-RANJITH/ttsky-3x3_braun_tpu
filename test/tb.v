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

    // -------------------------
    // Clock (50 MHz)
    // -------------------------
    initial clk = 0;
    always #10 clk = ~clk;

    // -------------------------
    // Waveform
    // -------------------------
    initial begin
        $dumpfile("tb.fst");
        $dumpvars(0, tb);
    end

    // -------------------------
    // Task: Apply one vector
    // -------------------------
    task apply_vector;
        input [7:0] val_ui;
        input [7:0] val_uio;
        begin
            ui_in  = val_ui;
            uio_in = val_uio;
            @(posedge clk);
        end
    endtask

    // -------------------------
    // Stimulus
    // -------------------------
    initial begin
        // Init
        rst_n  = 0;
        ena    = 0;
        ui_in  = 0;
        uio_in = 0;

        // Reset
        repeat (5) @(posedge clk);
        rst_n = 1;

        // Enable
        repeat (2) @(posedge clk);
        ena = 1;

        // =========================
        // TEST VECTOR SET 1
        // =========================
        $display("---- TEST 1 ----");

        apply_vector(8'd2,  8'd0);
        apply_vector(8'd3,  8'd0);
        apply_vector(8'd4,  8'd0);

        apply_vector(8'd1,  8'd0);
        apply_vector(8'd2,  8'd0);
        apply_vector(8'd3,  8'd0);

        ena = 0;

        // Wait for compute
        repeat (30) @(posedge clk);

        // =========================
        // READ OUTPUTS
        // =========================
        $display("---- OUTPUT STREAM ----");

        repeat (15) begin
            @(posedge clk);
            $display("Time=%0t | OUT=%0d | IDX=%0d",
                     $time, uo_out, uio_out);
        end

        // =========================
        // TEST VECTOR SET 2
        // =========================
        ena = 1;

        $display("---- TEST 2 ----");

        apply_vector(8'd5, 8'd0);
        apply_vector(8'd6, 8'd0);
        apply_vector(8'd7, 8'd0);

        apply_vector(8'd1, 8'd0);
        apply_vector(8'd1, 8'd0);
        apply_vector(8'd1, 8'd0);

        ena = 0;

        repeat (30) @(posedge clk);

        repeat (15) begin
            @(posedge clk);
            $display("Time=%0t | OUT=%0d | IDX=%0d",
                     $time, uo_out, uio_out);
        end

        // Finish
        #50;
        $finish;
    end

endmodule
