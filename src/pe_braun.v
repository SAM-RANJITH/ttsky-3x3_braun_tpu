module pe_braun(
    input clk,
    input rst,
    input [7:0] a_in,
    input [7:0] b_in,
    input [15:0] acc_in,
    output reg [7:0] a_out,
    output reg [7:0] b_out,
    output reg [15:0] acc_out
);

    wire [15:0] mult;
    braun_multiplier mult_u (.a(a_in), .b(b_in), .p(mult));

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_out  <= 0;
            b_out  <= 0;
            acc_out <= 0;
        end else begin
            a_out  <= a_in;
            b_out  <= b_in;
            acc_out <= acc_in + mult;
        end
    end
endmodule
