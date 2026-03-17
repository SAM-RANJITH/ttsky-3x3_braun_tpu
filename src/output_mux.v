module output_mux(
    input clk,
    input rst,
    input enable,
    input [15:0] c00,c01,c02,c10,c11,c12,c20,c21,c22,
    output reg [7:0] data_out,
    output reg [3:0] index
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        index <= 0;
        data_out <= 0;
    end else if (enable) begin
        case(index)
            0: data_out <= c00[7:0];
            1: data_out <= c01[7:0];
            2: data_out <= c02[7:0];
            3: data_out <= c10[7:0];
            4: data_out <= c11[7:0];
            5: data_out <= c12[7:0];
            6: data_out <= c20[7:0];
            7: data_out <= c21[7:0];
            8: data_out <= c22[7:0];
            default: data_out <= 0;
        endcase
        index <= index + 1;
    end
end

endmodule
