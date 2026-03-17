`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 04:07:46 PM
// Design Name: 
// Module Name: IF_ID
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
module MEM_WB (clk, reset, MEM_ReadData, MEM_ALUResult, MEM_WriteReg, MEM_MemtoReg, MEM_RegWrite, WB_ReadData,
WB_ALUResult, WB_WriteReg, WB_MemtoReg, WB_RegWrite, MEM_PCPlus4, WB_PCPlus4, MEM_JumpLink, WB_JumpLink, MEM_PC,
 WB_PC, MEM_Instruction, WB_Instruction
 );
    input clk;
    input reset;
    input [31:0] MEM_ReadData;
    input [31:0] MEM_ALUResult;
    input [31:0] MEM_PCPlus4;
    input [4:0] MEM_WriteReg;
    input [31:0] MEM_PC;
    input MEM_MemtoReg;
    input MEM_RegWrite;
    input MEM_JumpLink;
    input [31:0] MEM_Instruction;
    output reg [31:0] WB_ReadData;
    output reg [31:0] WB_ALUResult;
    output reg [31:0] WB_PCPlus4;
    output reg [4:0] WB_WriteReg;
    output reg WB_MemtoReg;
    output reg WB_RegWrite;
    output reg WB_JumpLink;
    output reg [31:0] WB_PC;
    output reg [31:0] WB_Instruction;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            WB_ReadData <= 0;
            WB_ALUResult <= 0;
            WB_WriteReg <= 0;
            WB_MemtoReg <= 0;
            WB_RegWrite <= 0;
            WB_PCPlus4 <= 0;
            WB_JumpLink <= 0;
            WB_PC <= 0;
            WB_Instruction <= 0;
        end else begin
            WB_ReadData <= MEM_ReadData;
            WB_ALUResult <= MEM_ALUResult;
            WB_WriteReg <= MEM_WriteReg;
            WB_MemtoReg <= MEM_MemtoReg;
            WB_RegWrite <= MEM_RegWrite;
            WB_PCPlus4 <= MEM_PCPlus4;
            WB_JumpLink <= MEM_JumpLink;
            WB_PC <= MEM_PC;
            WB_Instruction <= MEM_Instruction;
            
        end
    end
    
endmodule
