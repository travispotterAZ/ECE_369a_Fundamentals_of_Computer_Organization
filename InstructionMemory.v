`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory  1
// Module - InstructionMemory.v
// Description - 32-Bit wide instruction memory.
//
// INPUT:- address
// Address: 32-Bit address input port.
//
// OUTPUT:-
// Instruction: 32-Bit output port.
//
// FUNCTIONALITY:-
// Similar to the DataMemory, this module should also be byte-addressed
// (i.e., ignore bits 0 and 1 of 'Address'). All of the instructions will be 
// hard-coded into the instruction memory, so there is no need to write to the 
// InstructionMemory.  The contents of the InstructionMemory is the machine 
// language program to be run on your MIPS processor.
//
//
//we will store the machine code for a code written in C later. for now initialize 
//each entry to be its index * 3 (memory[i] = i * 3;)
//all you need to do is give an address as input and read the contents of the 
//address on your output port. 
// 
//Using a 32bit address you will index into the memory, output the contents of that specific 
//address. for data memory we are using 1K word of storage space. for the instruction memory 
//you may assume smaller size for practical purpose. you can use 128 words as the size and 
//hardcode the values.  in this case you need 7 bits to index into the memory. 
//
//be careful with the least two significant bits of the 32bit address. those help us index 
//into one of the 4 bytes in a word. therefore you will need to use bit [8-2] of the input address. 


////////////////////////////////////////////////////////////////////////////////
/* Personal Interpretation
The IntructionMemory component is input a new address (PCResult) from the ProgramCounter.
The address is 32bits: 1) Bits [1:0] --> 1 of 4 bytes in a word.
                       2) Bits [8:2] --> index word in 'memory' register
                       3) Bits [31:9] --> ignored as only 7 bits needed for 128 words

The InstructionMemory component outputs a 32-bit instruction (1 of the 128 words) stored in memory at an address 
defined by bits 8-2 of the input.
This output instruction serves as the output of the InstructionFetchUnit.

Word = 32 bits = 4 bytes
One memory word = One instruction
*/

module InstructionMemory(Address, Instruction, Reset); 

    input [31:0] Address;        // Input Address 
    
    reg [31:0] memory[0:1023];    //Intruction memory register: 1) each element of memory is 32 bits wide [size of word (4-bytes)]
                                 //                            2) There are 128 words at indices [127:0]   
    
    output reg [31:0] Instruction;    // Instruction at memory location Address

    input Reset;

    initial begin
    
        $readmemh("InstructionMemory.mem", memory);
    end

    always @(posedge Reset) begin
      if (Reset) begin
        $readmemh("InstructionMemory.mem", memory);
      end
    end
        
    
    always @(*) begin //executes for all signals within code block
        Instruction <= memory[Address[11:2]]; //output instruction is assigned the word indexed by Address bits 8-2
    end
    
endmodule
