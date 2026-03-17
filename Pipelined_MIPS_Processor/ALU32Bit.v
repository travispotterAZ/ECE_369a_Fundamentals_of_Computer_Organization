`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: N-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU, so that it supports all arithmetic operations 
// needed by the MIPS instructions given in Labs4-5.docx document. 
//   The 'ALUResult' will output the corresponding result of the operation 
//   based on the 32-Bit inputs, 'A', and 'B'. 
//   The 'Zero' flag is high when 'ALUResult' is '0'. 
//   The 'ALUControl' signal should determine the function of the ALU 
//   You need to determine the bitwidth of the ALUControl signal based on the number of 
//   operations needed to support. 
////////////////////////////////////////////////////////////////////////////////


//Add(0), addi (1), sub(2), mult (3), and (4), andi (5), or (6), sll (7), srl (8), slt (9), 



module ALU32Bit(ALUControl, A, B, ALUResult);

	input [4:0] ALUControl; // control bits for ALU operation
                                // you need to adjust the bitwidth as needed
	input signed [31:0] A, B;	    // inputs

    reg signed [63:0] temp;

	output reg [31:0] ALUResult;	// answer
    
    
    always@(*)begin
        temp = 0;
        ALUResult = 32'hDEADBEEF;
        
        case(ALUControl)
            0: ALUResult = A + B; //add, addi, lw, sw, sb, lh, lb, sh
            1: ALUResult = A - B; //sub
            2: begin temp = A * B; ALUResult = temp[31:0];end //mul
          
            //Logical
            3: ALUResult = A & B; //and, andi
            4: ALUResult = A | B; //or, ori
            5: ALUResult = ~(A | B); //nor
            6: ALUResult = A ^ B;   //xor
            7: begin 
                 ALUResult = A << (B[10:6]); //sll    B shifted L by A bits
            end
            8: begin
                ALUResult = A >> (B[10:6]); //srl    B shifted R by A bits
            end
            
            9: ALUResult = (A < B);//slt, slti
                
            16: ALUResult = A; //jr (Don't want to change value, just pushed through ALU.
            
            // For jump (j) ALU not used. (Don't Care            
            //For jump and link (jal) ALU not used. (Don't care)
           

        endcase
        
    end
    


endmodule
