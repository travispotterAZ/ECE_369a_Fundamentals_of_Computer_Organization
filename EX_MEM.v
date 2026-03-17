`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 04:07:46 PM
// Design Name: 
// Module Name: EX_MEM register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module EX_MEM (clk, reset, EX_ALUResult, EX_WriteData, EX_WriteReg, EX_MemWrite, EX_MemRead, 
EX_MemtoReg, EX_RegWrite, MEM_ALUResult, MEM_WriteData, MEM_WriteReg, MEM_MemWrite, 
MEM_MemRead, MEM_MemtoReg, MEM_RegWrite, EX_PCPlus4, MEM_PCPlus4, EX_JumpLink, MEM_JumpLink, EX_isHalf, MEM_isHalf, 
EX_isByte, MEM_isByte, EX_Instruction, MEM_Instruction, EX_ReadData1, MEM_ReadData1, EX_PC, MEM_PC, EXMEM_Flush);

    input clk;
    input reset;
    input [31:0] EX_ALUResult;
    input [31:0] EX_WriteData;
    input [31:0] EX_PCPlus4;
    input [4:0] EX_WriteReg;
    input [31:0] EX_PC;
    // control signals
    input EX_MemWrite;
    input EX_MemRead;
    input EX_MemtoReg;
    input EX_RegWrite;
    input EX_JumpLink;
    input EX_isHalf;
    input EX_isByte;
    input [31:0] EX_Instruction;
    input [31:0] EX_ReadData1;

    input EXMEM_Flush;                    //new introduced flush
    
    // outputs
    output reg [31:0] MEM_ALUResult;
    output reg [31:0] MEM_WriteData;
    output reg [31:0] MEM_PCPlus4;
    output reg [4:0] MEM_WriteReg;
    output reg MEM_MemWrite;
    output reg MEM_MemRead;
    output reg MEM_MemtoReg;
    output reg MEM_RegWrite;
    output reg MEM_JumpLink;
    output reg MEM_isHalf;
    output reg MEM_isByte;
    output reg [31:0] MEM_Instruction;
    output reg [31:0] MEM_ReadData1;
    output reg [31:0] MEM_PC;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEM_ALUResult <= 0;
            MEM_WriteData <= 0;
            MEM_WriteReg <= 0;
            MEM_MemWrite <= 0;
            MEM_MemRead <= 0;
            MEM_MemtoReg <= 0;
            MEM_RegWrite <= 0;
            MEM_PCPlus4 <= 0;
            MEM_JumpLink <= 0;
            MEM_isHalf <= 0;
            MEM_isByte <= 0;
            MEM_Instruction <= 0;
            MEM_ReadData1 <= 0;
            MEM_PC <= 0;
            
        end 
        else if (EXMEM_Flush) begin
            MEM_ALUResult <= 0;
            MEM_WriteData <= 0;
            MEM_WriteReg <= 0;
            MEM_MemWrite <= 0;
            MEM_MemRead <= 0;
            MEM_MemtoReg <= 1;
            MEM_RegWrite <= 0;
            MEM_PCPlus4 <= 0;
            MEM_JumpLink <= 0;
            MEM_isHalf <= 0;
            MEM_isByte <= 0;
            MEM_Instruction <= 0;
            MEM_ReadData1 <= 0;
            MEM_PC <= 0;
        end
        else begin
            MEM_ALUResult <= EX_ALUResult;
            MEM_WriteData <= EX_WriteData;
            MEM_WriteReg <= EX_WriteReg;
            MEM_MemWrite <= EX_MemWrite;
            MEM_MemRead <= EX_MemRead;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_RegWrite <= EX_RegWrite;
            MEM_PCPlus4 <= EX_PCPlus4;
            MEM_JumpLink <= EX_JumpLink;
            MEM_isHalf <= EX_isHalf;
            MEM_isByte <= EX_isByte;
            MEM_Instruction <= EX_Instruction;
            MEM_ReadData1 <= EX_ReadData1;
            MEM_PC <= EX_PC;
        end
    end
endmodule
