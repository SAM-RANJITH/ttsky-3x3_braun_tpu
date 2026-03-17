module control_unit (
    input clk,
    input rst,
    input start,

    output reg load_A,
    output reg load_B,
    output reg compute,
    output reg output_phase,
    output reg done
);

    reg [2:0] state, next_state;

    localparam IDLE=0, LOAD_A=1, LOAD_B=2, COMPUTE=3, OUTPUT=4, DONE=5;

    always @(posedge clk or posedge rst)
        if (rst) state <= IDLE;
        else state <= next_state;

    always @(*) begin
        case(state)
            IDLE: next_state = start ? LOAD_A : IDLE;
            LOAD_A: next_state = LOAD_B;
            LOAD_B: next_state = COMPUTE;
            COMPUTE: next_state = OUTPUT;
            OUTPUT: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        load_A=0; load_B=0; compute=0; output_phase=0; done=0;

        case(state)
            LOAD_A: load_A=1;
            LOAD_B: load_B=1;
            COMPUTE: compute=1;
            OUTPUT: output_phase=1;
            DONE: done=1;
        endcase
    end
endmodule
