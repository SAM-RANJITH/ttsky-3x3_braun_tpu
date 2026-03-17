module tt_um_tpu_braun(
    input [7:0] ui_in,
    output [7:0] uo_out,
    input [7:0] uio_in,
    output [7:0] uio_out,
    output [7:0] uio_oe,
    input clk,
    input rst_n,
    input ena
);

wire rst = ~rst_n;

wire load, compute, output_en;

control_unit CU(
    .clk(clk), .rst(rst), .start(ena),
    .load(load), .compute(compute), .output_en(output_en)
);

wire [15:0] c00,c01,c02,c10,c11,c12,c20,c21,c22;

systolic_array_3x3 SA(
    .clk(clk), .rst(rst),
    .a_in(ui_in), .b_in(ui_in),
    .c00(c00),.c01(c01),.c02(c02),
    .c10(c10),.c11(c11),.c12(c12),
    .c20(c20),.c21(c21),.c22(c22)
);

wire [3:0] index;

output_mux OM(
    .clk(clk), .rst(rst), .enable(output_en),
    .c00(c00),.c01(c01),.c02(c02),
    .c10(c10),.c11(c11),.c12(c12),
    .c20(c20),.c21(c21),.c22(c22),
    .data_out(uo_out), .index(index)
);

assign uio_out = {4'b0,index};
assign uio_oe = 8'hFF;

endmodule
