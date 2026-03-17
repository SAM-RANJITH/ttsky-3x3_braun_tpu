module systolic_array_3x3(
    input clk,
    input rst,
    input [7:0] a_in,
    input [7:0] b_in,
    output [15:0] c00,c01,c02,c10,c11,c12,c20,c21,c22
);

reg [7:0] a_bus[0:2][0:3];
reg [7:0] b_bus[0:2][0:3];
reg [15:0] acc_bus[0:2][0:2];

integer i,j;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for(i=0;i<3;i=i+1)
            for(j=0;j<4;j=j+1) begin
                a_bus[i][j] <= 0;
                b_bus[i][j] <= 0;
            end
        for(i=0;i<3;i=i+1)
            for(j=0;j<3;j=j+1)
                acc_bus[i][j] <= 0;
    end else begin
        for(i=0;i<3;i=i+1)
            for(j=0;j<3;j=j+1) begin
                if (j==0)
                    acc_bus[i][j] <= a_bus[i][j] * b_bus[j][i];
                else
                    acc_bus[i][j] <= acc_bus[i][j-1] + a_bus[i][j] * b_bus[j][i];
            end

        for(i=0;i<3;i=i+1) begin
            a_bus[i][0] <= a_in;
            b_bus[i][0] <= b_in;
        end

        for(i=0;i<3;i=i+1)
            for(j=1;j<4;j=j+1) begin
                a_bus[i][j] <= a_bus[i][j-1];
                b_bus[i][j] <= b_bus[i][j-1];
            end
    end
end

assign c00 = acc_bus[0][0];
assign c01 = acc_bus[0][1];
assign c02 = acc_bus[0][2];
assign c10 = acc_bus[1][0];
assign c11 = acc_bus[1][1];
assign c12 = acc_bus[1][2];
assign c20 = acc_bus[2][0];
assign c21 = acc_bus[2][1];
assign c22 = acc_bus[2][2];

endmodule
