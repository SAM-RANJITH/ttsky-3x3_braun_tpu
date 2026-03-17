module input_loader (
    input clk,
    input rst,
    input [7:0] data_in,
    input load_A,
    input load_B,

    output reg [7:0] a0,a1,a2,
    output reg [7:0] b0,b1,b2
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a0<=0; a1<=0; a2<=0;
            b0<=0; b1<=0; b2<=0;
        end else begin
            if (load_A) begin
                a2<=a1; a1<=a0; a0<=data_in;
            end
            if (load_B) begin
                b2<=b1; b1<=b0; b0<=data_in;
            end
        end
    end
endmodule
