module tt_um_tpu_braun (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire clk,
    input  wire rst_n,
    input  wire ena
);

    wire rst = ~rst_n;

    wire load_A, load_B, compute, output_phase, done;

    control_unit ctrl (
        .clk(clk), .rst(rst), .start(ena),
        .load_A(load_A), .load_B(load_B),
        .compute(compute), .output_phase(output_phase), .done(done)
    );

    wire [7:0] a0,a1,a2,b0,b1,b2;

    input_loader loader (
        .clk(clk), .rst(rst),
        .data_in(ui_in),
        .load_A(load_A), .load_B(load_B),
        .a0(a0), .a1(a1), .a2(a2),
        .b0(b0), .b1(b1), .b2(b2)
    );

    wire [15:0] c00,c01,c02,c10,c11,c12,c20,c21,c22;

    systolic_array_3x3 core (
        .clk(clk), .rst(rst),
        .a_in0(a0), .a_in1(a1), .a_in2(a2),
        .b_in0(b0), .b_in1(b1), .b_in2(b2),
        .c00(c00), .c01(c01), .c02(c02),
        .c10(c10), .c11(c11), .c12(c12),
        .c20(c20), .c21(c21), .c22(c22)
    );

    wire [15:0] mux_out;
    wire [3:0] index;

    output_mux mux (
        .clk(clk), .rst(rst), .enable(output_phase),
        .c00(c00), .c01(c01), .c02(c02),
        .c10(c10), .c11(c11), .c12(c12),
        .c20(c20), .c21(c21), .c22(c22),
        .data_out(mux_out), .index(index)
    );

    assign uo_out = mux_out[7:0];
    assign uio_out = {4'd0,index};
    assign uio_oe  = 8'hFF;

endmodule
