module control_unit(
    input clk,
    input rst,
    input start,
    output reg load,
    output reg compute,
    output reg output_en
);

reg [3:0] state, count;

localparam IDLE=0, LOAD_A=1, LOAD_B=2, COMPUTE=3, OUTPUT=4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        count <= 0;
    end else begin
        case(state)
            IDLE: if(start) state <= LOAD_A;

            LOAD_A: begin
                if(count==2) begin state <= LOAD_B; count <= 0; end
                else count <= count + 1;
            end

            LOAD_B: begin
                if(count==2) begin state <= COMPUTE; count <= 0; end
                else count <= count + 1;
            end

            COMPUTE: begin
                if(count==8) begin state <= OUTPUT; count <= 0; end
                else count <= count + 1;
            end

            OUTPUT: state <= IDLE;
        endcase
    end
end

always @(*) begin
    load = (state==LOAD_A)||(state==LOAD_B);
    compute = (state==COMPUTE);
    output_en = (state==OUTPUT);
end

endmodule
