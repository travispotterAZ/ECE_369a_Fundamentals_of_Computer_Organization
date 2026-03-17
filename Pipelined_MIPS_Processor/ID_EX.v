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
module ID_EX (clk, reset, ID_PCPlus4, ID_ReadData1, ID_ReadData2, ID_SignExtImm, ID_Rt, ID_Rd, 
ID_ALUOp, ID_ALUSrc, ID_RegDst, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, EX_PCPlus4, EX_ReadData1, 
EX_ReadData2, EX_SignExtImm, EX_Rt, EX_Rd, EX_ALUOp, EX_ALUSrc, EX_RegDst, EX_MemWrite, EX_MemRead, 
EX_MemtoReg, EX_RegWrite, ID_JumpLink, EX_JumpLink, ID_sllcase, EX_sllcase, ID_isHalf, EX_isHalf, ID_isByte, 
EX_isByte, ID_Instruction, EX_Instruction, IDEX_Flush, ID_PC, EX_PC, IFID_Flush, EX_IFIDflush, IDEX_Write);
    input clk;
    input reset;
    input [31:0] ID_PCPlus4;
    input [31:0] ID_ReadData1;
    input [31:0] ID_ReadData2;
    input [31:0] ID_SignExtImm;
    input [4:0] ID_Rt;
    input [4:0] ID_Rd;
    input [4:0] ID_ALUOp;
    input ID_ALUSrc;
    input ID_RegDst; 
    input ID_MemWrite;
    input ID_MemRead;
    input ID_MemtoReg;
    input ID_RegWrite;
    input ID_JumpLink;
    input ID_sllcase;
    input ID_isHalf;
    input ID_isByte;
    input [31:0] ID_Instruction;
    input IDEX_Flush;
    input [31:0] ID_PC;
    input IFID_Flush;
    input IDEX_Write;
  
    output reg [31:0] EX_PCPlus4;
    output reg [31:0] EX_ReadData1;
    output reg [31:0] EX_ReadData2;
    output reg [31:0] EX_SignExtImm;
    output reg [4:0] EX_Rt;
    output reg [4:0] EX_Rd;
    output reg [4:0] EX_ALUOp;
    output reg EX_ALUSrc;
    output reg EX_RegDst;
    output reg EX_MemWrite;
    output reg EX_MemRead;
    output reg EX_MemtoReg;
    output reg EX_RegWrite;
    output reg EX_JumpLink;
    output reg EX_sllcase;
    output reg EX_isHalf;
    output reg EX_isByte;
    output reg [31:0] EX_Instruction;
    output reg [31:0] EX_PC;
    output reg EX_IFIDflush;
    
   always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Clear everything on reset
        EX_PCPlus4    <= 0;
        EX_ReadData1  <= 0;
        EX_ReadData2  <= 0;
        EX_SignExtImm <= 0;
        EX_Rt         <= 0;
        EX_Rd         <= 0;
        EX_ALUOp      <= 0;
        EX_ALUSrc     <= 0;
        EX_RegDst     <= 0;
        EX_MemWrite   <= 0;
        EX_MemRead    <= 0;
        EX_MemtoReg   <= 0;
        EX_RegWrite   <= 0;
        EX_JumpLink   <= 0;
        EX_sllcase    <= 0;
        EX_isHalf     <= 0;
        EX_isByte     <= 0;
        EX_Instruction <= 0;
        EX_PC         <= 0;
        EX_IFIDflush   <= 0;
    end
    else if (IDEX_Flush) begin
        // Flush control signals to zero, but keep data passing through
        EX_PC         <= 0; //Below
        EX_PCPlus4    <= 0;
        EX_ReadData1  <= 0; //Changed to latch 0 rather than themselves.
        EX_ReadData2  <= 0;
        EX_SignExtImm <= 0; // above
        EX_Instruction <= 0;
        EX_Rt         <= 0; //cahnegd to hold 0
        EX_Rd         <= 0; //changed to hold 0 rather than themselves
        EX_ALUOp      <= 0;
        EX_ALUSrc     <= 0;
        EX_RegDst     <= 0;
        EX_MemWrite   <= 0;
        EX_MemRead    <= 0;
        EX_MemtoReg   <= 1;
        EX_RegWrite   <= 0;
        EX_JumpLink   <= 0;
        EX_sllcase    <= 0;
        EX_isHalf     <= 0;
        EX_isByte     <= 0;
        EX_IFIDflush  <= 0;
    end else if(IDEX_Write) begin
        // Normal flow: copy all signals from ID stage
        EX_PCPlus4    <= ID_PCPlus4;
        EX_ReadData1  <= ID_ReadData1;
        EX_ReadData2  <= ID_ReadData2;
        EX_SignExtImm <= ID_SignExtImm;
        EX_Rt         <= ID_Rt;
        EX_Rd         <= ID_Rd;
        EX_ALUOp      <= ID_ALUOp;
        EX_ALUSrc     <= ID_ALUSrc;
        EX_RegDst     <= ID_RegDst;
        EX_MemWrite   <= ID_MemWrite;
        EX_MemRead    <= ID_MemRead;
        EX_MemtoReg   <= ID_MemtoReg;
        EX_RegWrite   <= ID_RegWrite;
        EX_JumpLink   <= ID_JumpLink;
        EX_sllcase    <= ID_sllcase;
        EX_isHalf     <= ID_isHalf;
        EX_isByte     <= ID_isByte;
        EX_Instruction <= ID_Instruction;
        EX_PC         <= ID_PC;
        EX_IFIDflush  <= IFID_Flush;
        
    end else begin // Normal flow: copy all signals from ID stage
        EX_PCPlus4    <= EX_PCPlus4;
        EX_ReadData1  <= EX_ReadData1;
        EX_ReadData2  <= EX_ReadData2;
        EX_SignExtImm <= EX_SignExtImm;
        EX_Rt         <= EX_Rt;
        EX_Rd         <= EX_Rd;
        EX_ALUOp      <= EX_ALUOp;
        EX_ALUSrc     <= EX_ALUSrc;
        EX_RegDst     <= EX_RegDst;
        EX_MemWrite   <= EX_MemWrite;
        EX_MemRead    <= EX_MemRead;
        EX_MemtoReg   <= EX_MemtoReg;
        EX_RegWrite   <= EX_RegWrite;
        EX_JumpLink   <= EX_JumpLink;
        EX_sllcase    <= EX_sllcase;
        EX_isHalf     <= EX_isHalf;
        EX_isByte     <= EX_isByte;
        EX_Instruction <= EX_Instruction;
        EX_PC         <= EX_PC;
        EX_IFIDflush  <= EX_IFIDflush;
    end
end

endmodule
