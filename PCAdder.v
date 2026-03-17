`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory  
// Module - PCAdder.v
// Description - 32-Bit program counter (PC) adder.
// 
// INPUTS:-
// PCResult: 32-Bit input port.
// 
// OUTPUTS:-
// PCAddResult: 32-Bit output port.
//
// FUNCTIONALITY:-
// Design an incrementor (or a hard-wired ADD ALU whose first input is from the 
// PC, and whose second input is a hard-wired 4) that computes the current 
// PC + 4. The result should always be an increment of the signal 'PCResult' by 
// 4 (i.e., PCAddResult = PCResult + 4).
////////////////////////////////////////////////////////////////////////////////


/* Personal Interpretation
The instructions are word-aligned therefore each instruction is 4-bytes (32 bits). So after getting the instruction at address PCResult
the next address, PCAddResult, is calculated and wired to ProgramCounter.
*/
module PCAdder(PCResult, PCAddResult);

    input [31:0] PCResult; //32-bit input
    
    output [31:0] PCAddResult; //32-bit output
        
    assign PCAddResult = PCResult + 4; //PCAddResult will be assigned the value of PCResult plus 4

   
endmodule
