module output_mux (
    input clk,
    input rst,
    input enable,

    input [15:0] c00,c01,c02,
    input [15:0] c10,c11,c12,
    input [15:0] c20,c21,c22,

    output reg [15:0] data_out,
    output reg [3:0] index
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            index <= 0;
            data_out <= 0;
        end else if (enable) begin
            index <= index + 1;

            case(index)
                0: data_out<=c00;
                1: data_out<=c01;
                2: data_out<=c02;
                3: data_out<=c10;
                4: data_out<=c11;
                5: data_out<=c12;
                6: data_out<=c20;
                7: data_out<=c21;
                8: data_out<=c22;
                default: data_out<=0;
            endcase
        end
    end
endmodule
