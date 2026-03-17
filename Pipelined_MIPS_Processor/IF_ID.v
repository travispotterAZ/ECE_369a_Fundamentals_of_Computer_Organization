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


module IF_ID (clk, reset, IF_PCPlus4, IF_Instruction, ID_PCPlus4, ID_Instruction, IFID_Write, IFID_Flush, IF_PC, ID_PC);
    input clk;
    input reset;
    input [31:0] IF_PCPlus4;
    input [31:0] IF_Instruction;
    input IFID_Write;
    input IFID_Flush;
    input [31:0] IF_PC;
        
    output reg [31:0] ID_PCPlus4;
    output reg [31:0] ID_Instruction;
    output reg [31:0] ID_PC;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_PCPlus4 <= 0;
            ID_Instruction <= 0;
            ID_PC <= 0;
        end 
        
        else if (IFID_Flush) begin
            ID_PCPlus4 <= 0;
            ID_Instruction <= 0;
            ID_PC <= 0;
        end
        
        else if (IFID_Write) begin 
            ID_PCPlus4 <= IF_PCPlus4;
            ID_Instruction <= IF_Instruction;
            ID_PC <= IF_PC;
        end
        
       else begin
            ID_PC          <= ID_PC;
            ID_PCPlus4     <= ID_PCPlus4;     
            ID_Instruction <= ID_Instruction; // hold
        end
    end
endmodule
