`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 03:57:27 PM
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(ID_rs, ID_rt, ID_rs_Flag, ID_rt_Flag, EX_Dest, EX_RegWrite, MEM_Dest, MEM_RegWrite,
                  PC_Write, IFID_Write, IDEX_Flush, reset, EXMEM_Flush, BranchTaken, EX_MemRead, 
                  IFID_Flush, Jump, JumpReg, stall, IDEX_Write, EX_Instruction, WB_Instruction
                  );
                  
                  
    input [4:0] ID_rs, ID_rt;        //ID stage source registers
    input ID_rs_Flag, ID_rt_Flag;     //Checks to see if ID actually uses rs or rt
    input reset;
    
    input [4:0] EX_Dest;             //Destination register in EX
    input EX_RegWrite;               //EX instruction will write a register 
    
    input [4:0] MEM_Dest;             //Destination Register in MEM
    input EX_MemRead;
    input MEM_RegWrite;               //MEM instruction will write a register
    input BranchTaken;
    input Jump;
    input JumpReg;
    input [31:0] EX_Instruction;
    input [31:0] WB_Instruction;
    
    output reg PC_Write, IFID_Write;        //Controls whether PC and IF/ID updates (0 = stall)
    output reg IDEX_Flush;                  //Controls whether ID/EX is flushed
    output reg EXMEM_Flush;
    output reg IFID_Flush;
    output stall;
    output reg IDEX_Write;



    (* dont_touch = "true" *) wire EX_hazard  = (EX_RegWrite  && (EX_Dest  != 5'd0) &&
                      ((ID_rs_Flag && (ID_rs  == EX_Dest)) || (ID_rt_Flag && (ID_rt  == EX_Dest))));
    (* dont_touch = "true" *) wire MEM_hazard = (MEM_RegWrite && (MEM_Dest != 5'd0) &&
                      ((ID_rs_Flag && (ID_rs == MEM_Dest)) || (ID_rt_Flag && (ID_rt == MEM_Dest))));
   
    (* dont_touch = "true" *) assign stall = EX_hazard || MEM_hazard;
    
     always @(*) begin
        
        if (reset) begin
            PC_Write    = 1;
            IFID_Write  = 1;
            IDEX_Write = 1;
            IDEX_Flush  = 0;
            EXMEM_Flush = 0;
            IFID_Flush = 0;

        end else if (stall) begin
            // Load-use stall
            PC_Write    = 0;
            IFID_Write  = 0;
            IDEX_Write = 0;
            IFID_Flush = 0;
            IDEX_Flush  = 1;    // insert bubble
            EXMEM_Flush = 0;
    
        end else if (BranchTaken  || Jump || JumpReg) begin
            // Highest priority
            PC_Write    = 1;
            IFID_Write  = 1; 
            IDEX_Write = 1;
            IDEX_Flush  = 0; 
            EXMEM_Flush = 0;    // do NOT flush EX/MEM
            IFID_Flush = 0;
            
        end else begin
            PC_Write    = 1;
            IFID_Write  = 1;
            IDEX_Write = 1;
            IDEX_Flush  = 0;
            EXMEM_Flush = 0;
            IFID_Flush = 0;
        end
    end


endmodule
