`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory 1
// Module - pc_register.v
// Description - 32-Bit program counter (PC) register.
//
// INPUTS:-
// Address: 32-Bit address input port.
// Reset: 1-Bit input control signal.
// Clk: 1-Bit input clock signal.
//
// OUTPUTS:-
// PCResult: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design a program counter register that holds the current address of the 
// instruction memory.  This module should be updated at the positive edge of 
// the clock. The contents of a register default to unknown values or 'X' upon 
// instantiation in your module.  
// You need to enable global reset of your datapath to point 
// to the first instruction in your instruction memory (i.e., the first address 
// location, 0x00000000H).
////////////////////////////////////////////////////////////////////////////////

/* Personal Interpretation
ProgramCounter is input Address, Reset, and Clk.

ProgramCounter acts as a 32-bit register that only changes input->output if reset is pressed (i.e. PCResult is assigned to 0).

ProgramCounter's output is wired twice... 1)PCResult --> InstructionMemory: PCResult is used as address to access instruction in memory
										  2)PCResult --> PCAdder: PCResult will be incremented by PCAdder for purpose of next address
*/

module ProgramCounter(Address, PCResult, Reset, Clk, PCWrite);

	input [31:0] Address;      //32-Bit address input port
	input Reset, Clk;		// 1-bit input control and clock signal
	
	input PCWrite;

	output reg [31:0] PCResult;      //32-bit registered output port

	always @(posedge Clk or posedge Reset) begin      //At every positive edge clock cycle 
		if (Reset) begin PCResult <= 0; end      //If reset is active, PCResult is is initialized back to zero (Synchronus reset)
        else if (PCWrite) begin 
            PCResult <= Address;
        end
        else begin PCResult <= PCResult; end     //Stall
    end
        

endmodule
