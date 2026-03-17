module systolic_array_3x3(
    input clk,
    input rst,

    input [7:0] a_in0, a_in1, a_in2,
    input [7:0] b_in0, b_in1, b_in2,

    output [15:0] c00, c01, c02,
    output [15:0] c10, c11, c12,
    output [15:0] c20, c21, c22
);

    // Delayed inputs
    wire [7:0] a0_d0, a1_d1, a2_d2;
    wire [7:0] b0_d0, b1_d1, b2_d2;

    assign a0_d0 = a_in0;
    delay_cell #(.DELAY(1)) d_a1 (.clk(clk), .rst(rst), .din(a_in1), .dout(a1_d1));
    delay_cell #(.DELAY(2)) d_a2 (.clk(clk), .rst(rst), .din(a_in2), .dout(a2_d2));

    assign b0_d0 = b_in0;
    delay_cell #(.DELAY(1)) d_b1 (.clk(clk), .rst(rst), .din(b_in1), .dout(b1_d1));
    delay_cell #(.DELAY(2)) d_b2 (.clk(clk), .rst(rst), .din(b_in2), .dout(b2_d2));

    wire [7:0] a_bus [0:2][0:3];
    wire [7:0] b_bus [0:3][0:2];
    wire [15:0] acc_bus [0:2][0:2];

    assign a_bus[0][0] = a0_d0;
    assign a_bus[1][0] = a1_d1;
    assign a_bus[2][0] = a2_d2;

    assign b_bus[0][0] = b0_d0;
    assign b_bus[0][1] = b1_d1;
    assign b_bus[0][2] = b2_d2;

    genvar i,j;
    generate
        for(i=0;i<3;i=i+1) begin: row
            for(j=0;j<3;j=j+1) begin: col
                pe_braun pe(
                    .clk(clk),
                    .rst(rst),
                    .a_in(a_bus[i][j]),
                    .b_in(b_bus[j][i]),
                    .acc_in((j==0)?16'd0:acc_bus[i][j-1]),
                    .a_out(a_bus[i][j+1]),
                    .b_out(b_bus[j+1][i]),
                    .acc_out(acc_bus[i][j])
                );
            end
        end
    endgenerate

    assign c00=acc_bus[0][0]; assign c01=acc_bus[0][1]; assign c02=acc_bus[0][2];
    assign c10=acc_bus[1][0]; assign c11=acc_bus[1][1]; assign c12=acc_bus[1][2];
    assign c20=acc_bus[2][0]; assign c21=acc_bus[2][1]; assign c22=acc_bus[2][2];

endmodule
