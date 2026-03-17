`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2025 06:11:03 PM
// Design Name: 
// Module Name: BranchResolution
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


module BranchResolution(sigALU, Branch, RD1, RD2, offSet, PCPlus4, isZero, PCSrc, BranchDst);

    input [4:0] sigALU;
    input Branch;
    input signed [31:0] RD1;
    input signed [31:0] RD2;
    input signed [31:0] offSet;
    input [31:0] PCPlus4;
    
    output reg isZero;
    output reg PCSrc;
    output reg [31:0] BranchDst;
    
    reg signed [31:0] afterShiftL2;
    
    always@(*) begin
        isZero = 0;
        
        case(sigALU)
            10: begin //begz
                if(RD1 >= 0) begin isZero = 1; end
            end
            
            11: begin //beq
                if( (RD1 - RD2) == 0) begin isZero = 1; end
            end
            
            12: begin //bne
                if( (RD1 != RD2) ) begin isZero = 1; end
            end
            
            13: begin //bgtz
                if(RD1 > 0) begin isZero = 1; end
            end
            
            14: begin //blez
                if(RD1 <= 0) begin isZero = 1; end
            end
            
            15: begin //bltz
                if(RD1 < 0) begin isZero = 1; end
            end
            
            default: begin isZero = 0; end       
        
        endcase
        
        PCSrc = isZero & Branch;
        
        afterShiftL2 = offSet << 2; //Shift Left Two intended for AddResult
    
        BranchDst = PCPlus4 + afterShiftL2;
    
    end

endmodule
