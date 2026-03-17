module braun_multiplier #(parameter WIDTH=8)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [2*WIDTH-1:0] p
);
    assign p = a * b;
endmodule
