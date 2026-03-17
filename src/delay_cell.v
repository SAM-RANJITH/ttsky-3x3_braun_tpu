module delay_cell #(parameter DELAY=1)(
    input clk,
    input rst,
    input [7:0] din,
    output [7:0] dout
);

    reg [7:0] shift [0:DELAY];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i=0;i<=DELAY;i=i+1)
                shift[i] <= 0;
        end else begin
            shift[0] <= din;
            for(i=1;i<=DELAY;i=i+1)
                shift[i] <= shift[i-1];
        end
    end

    assign dout = shift[DELAY];
endmodule
