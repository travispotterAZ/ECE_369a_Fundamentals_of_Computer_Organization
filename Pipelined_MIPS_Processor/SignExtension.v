`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - SignExtension.v
// Description - Sign extension module.
////////////////////////////////////////////////////////////////////////////////
module SignExtension(in, out, isZero);

    /* A 16-Bit input word */
    input [15:0] in;
    input isZero;

    /* A 32-Bit output word */
    output [31:0] out;

    wire[15:0] in;
    reg[31:0] out;

    always @(*) begin
        if(isZero)
            out = {16'b0, in};
        else
            out = {{16{in[15]}}, in};
    end


endmodule
