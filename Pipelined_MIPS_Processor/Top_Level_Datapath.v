
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 06:53:26 PM
// Design Name: 
// Module Name: Top_Level_Datapath
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


module Top_Level_Datapath(
    input Clk,
    input Reset,
    output [6:0] out7,
    output [7:0] en_out
    
);

//WIRE Definitions
// IF
    (* keep = "true" *) wire [31:0] PC;
    (* keep = "true" *) wire ID_PCSrc; //Value is decided in MEM stage, but used in IF for next address assignment
    (* keep = "true" *) wire [31:0] PCPlus4, Instruction;
    (* keep = "true" *) wire [31:0] JumpAddress, PCBranchMuxOut, JumpMuxOut;     //Jump Wires
    (* keep = "true" *) wire [31:0] JrMuxOut;
//

// ID
    (* keep = "true" *) wire Jump, JumpReg;
    (* keep = "true" *) wire [31:0] ID_ReadData1;
    (* keep = "true" *) wire [31:0] ID_PCPlus4, ID_Instruction;
    (* keep = "true" *) wire [31:0] ID_ReadData2, ID_SignExtImm;
    (* keep = "true" *) wire [4:0] ID_ALUOut;
    (* keep = "true" *) wire ID_ALUSrc, ID_RegDst, ID_MemRead, ID_MemWrite, ID_MemtoReg, ID_RegWrite, ID_Branch;
    (* keep = "true" *) wire JumpLink, ID_sllCase, Logical, isHalf, isByte;
    (* keep = "true" *) wire [31:0] ID_PC;
    (* keep = "true" *) wire [31:0] BranchDst;
//

// EX
    (* keep = "true" *) wire [31:0] EX_PCPlus4, EX_ReadData1, EX_ReadData2, EX_SignExtImm, EX_Instruction;
    (* keep = "true" *) wire [4:0] EX_Rt, EX_Rd;
    (* keep = "true" *) wire [4:0] EX_ALUOut;
    (* keep = "true" *) wire EX_ALUSrc, EX_RegDst, EX_MemRead, EX_MemWrite, EX_MemtoReg, EX_RegWrite,
     EX_JumpLink, EX_sllcase, EX_isHalf, EX_isByte;
    (* keep = "true" *) wire [31:0] EX_ALUInput2, EX_ALUResult;
    (* keep = "true" *) wire [31:0] EX_ALUInput1;
    (* keep = "true" *) wire [4:0] EX_WriteReg;
    (* keep = "true" *) wire [31:0] WriteRegOut;
    (* keep = "true" *) wire [31:0] EX_PC;
//   

// MEM
    (* keep = "true" *) wire [31:0] MEM_PCPlus4;
    (* keep = "true" *) wire [31:0] MEM_Instruction;
    (* keep = "true" *) wire [31:0] MEM_ALUResult, MEM_WriteData;
    (* keep = "true" *) wire [4:0] MEM_WriteReg;
    (* keep = "true" *) wire MEM_MemRead, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_JumpLink;
    (* keep = "true" *) wire MEM_isHalf, MEM_isByte;
    (* keep = "true" *) wire [31:0] MEM_ReadData;   //this is memory read
    (* keep = "true" *) wire [31:0] MEM_ReadData1; //this is register read data from port 1, in the memory stage
    (* keep = "true" *) wire [31:0] MEM_PC;
//

//WB
    (* keep = "true" *) wire [31:0] WriteBackData;
    (* keep = "true" *) wire WB_RegWrite;
    (* keep = "true" *) wire [4:0] WB_WriteReg;
    (* keep = "true" *) wire [31:0] WB_FinalWriteData;
    (* keep = "true" *) wire [4:0] WB_FinalWriteReg;
    (* keep = "true" *) wire [31:0] WB_ReadData, WB_ALUResult;
    (* keep = "true" *) wire WB_MemtoReg; 
    (* keep = "true" *) wire WB_JumpLink;
    (* keep = "true" *) wire [31:0] WB_PC;   
    (* keep = "true" *) wire [31:0] WB_PCPlus4;
    (* keep = "true" *) wire [31:0] DisplayWriteBackData;         //JaL Support
//

//MISC
    (* keep = "true" *) wire datapathClk;
//

//HAZARD/CONTROL
    (* keep = "true" *) wire PCWrite, IFID_Write, IFID_Flush, IDEX_Flush;
//

//HAZARD DETECTION
    (* keep = "true" *) wire ID_rs_Flag;
    (* keep = "true" *) wire ID_rt_Flag;
    (* keep = "true" *) wire EXMEM_Flush;
    (* keep = "true" *) wire stall;
    (* keep = "true" *) wire IDEX_Write;
    (* keep = "true" *) wire [31:0] WB_Instruction;
//
    
    (* dont_touch = "true" *) ClkDiv IntitalClkDiv (.Clk(Clk), .Rst(Reset), .ClkOut(datapathClk)); //Clock Division
    
    (* keep = "true" *)  assign JumpAddress = {ID_PCPlus4[31:28], ID_Instruction[25:0], 2'b00};
    
    (* keep = "true" *) wire EX_IFIDflush; //Used in new mux

    Mux32Bit2To1 BranchMux (
        .out(PCBranchMuxOut),
        .inA(ID_PCPlus4), // <--- use conditional input
        .inB(BranchDst),
        .sel(ID_PCSrc && ~stall)
    );

    
    (* dont_touch = "true" *)Mux32Bit2To1 JumpMux (
        .out(JumpMuxOut),
        .inA(PCBranchMuxOut),
        .inB(JumpAddress),
        .sel(Jump)
    ); //Jump Address is created above depending on MEM values.
        
    
    (* dont_touch = "true" *) Mux32Bit2To1 JRMux (.out(JrMuxOut), .inA(JumpMuxOut), .inB(ID_ReadData1), .sel(JumpReg));
    
    
    //(* dont_touch = "true" *) Mux32Bit2To1 BranchFlushMux (.out(output1), .inA(PC), .inB(JrMuxOut),  .sel(EX_IFIDflush) );
        
    //PC+4 adder
    (* dont_touch = "true" *) PCAdder pcAdder (.PCResult(PC), .PCAddResult(PCPlus4));

    
    //Program Counter
    (* dont_touch = "true" *) ProgramCounter PCReg(.Address(JrMuxOut), .PCResult(PC), .Reset(Reset), .Clk(datapathClk), .PCWrite(PCWrite));
    
    //Instruction Memory
     (* dont_touch = "true" *) InstructionMemory IM(.Address(PC), .Instruction(Instruction), .Reset(Reset)); //Input PCNext, Output: Instruction read from memory
    
    (* dont_touch = "true" *) IF_ID FDReg(.clk(datapathClk), .reset(Reset), .IF_PCPlus4(PCPlus4), .IF_Instruction(Instruction), .ID_PCPlus4(ID_PCPlus4), 
    .ID_Instruction(ID_Instruction), .IFID_Write(IFID_Write), .IFID_Flush(IFID_Flush), .IF_PC(PC), .ID_PC(ID_PC)); //IF are inputs, ID are outputs
    
    (* dont_touch = "true" *) HazardUnit HazardUnit(
        .ID_rs(ID_Instruction[25:21]), .ID_rt(ID_Instruction[20:16]),
        .ID_rs_Flag(ID_rs_Flag), .ID_rt_Flag(ID_rt_Flag),
        .EX_Dest(EX_WriteReg), 
        .EX_RegWrite(EX_RegWrite), 
        .MEM_Dest(MEM_WriteReg), 
        .MEM_RegWrite(MEM_RegWrite), 
        .PC_Write(PCWrite), .IFID_Write(IFID_Write),
        .IDEX_Flush(IDEX_Flush),
        .reset(Reset),
        .EXMEM_Flush(EXMEM_Flush),
        .BranchTaken(ID_PCSrc),
        .EX_MemRead(EX_MemRead),
        .IFID_Flush(IFID_Flush),
        .Jump(Jump), .JumpReg(JumpReg),
        .stall(stall),
        .IDEX_Write(IDEX_Write),
        .EX_Instruction(EX_Instruction),
        .WB_Instruction(WB_Instruction)
        
        );
    
    (* dont_touch = "true" *) MainControl Control(
    .Instruction(ID_Instruction),
    .ALUOut(ID_ALUOut), 
    .MemtoReg(ID_MemtoReg), 
    .RegWrite(ID_RegWrite),
    .ALUSrc(ID_ALUSrc),
    .RegDst(ID_RegDst),
    .Branch(ID_Branch),
    .MemWrite(ID_MemWrite), 
    .MemRead(ID_MemRead),
    .Jump(Jump),
    .JumpReg(JumpReg),
    .JumpLink(JumpLink),
    .SllCase(ID_sllCase),
    .Logical(Logical),
    .isHalf(isHalf),
    .isByte(isByte),
    .ID_rs_Flag(ID_rs_Flag),
    .ID_rt_Flag(ID_rt_Flag));
    //Instruction is input, all others are signal 
 
   
    
    (* dont_touch = "true" *) RegisterFile RegFile(.ReadRegister1(ID_Instruction[25:21]), .ReadRegister2(ID_Instruction[20:16]), 
    .WriteRegister(WB_FinalWriteReg), .WriteData(WB_FinalWriteData), .RegWrite(WB_RegWrite), .Clk(datapathClk), 
    .ReadData1(ID_ReadData1), .ReadData2(ID_ReadData2), .Reset(Reset));
    
    (* dont_touch = "true" *) SignExtension SE(.in(ID_Instruction[15:0]), .out(ID_SignExtImm), .isZero(Logical));
    
    
    (* dont_touch = "true" *) BranchResolution BR(
        .sigALU(ID_ALUOut),
        .Branch(ID_Branch),
        .RD1(ID_ReadData1),
        .RD2(ID_ReadData2),
        .offSet(ID_SignExtImm),
        .PCPlus4(ID_PCPlus4),
        .isZero(ID_isZero),
        .PCSrc(ID_PCSrc),
        .BranchDst(BranchDst)
    );
    
    
    //ID/EX Pipeline Register
    (* dont_touch = "true" *) ID_EX DEReg(.clk(datapathClk), .reset(Reset), .ID_PCPlus4(ID_PCPlus4), .ID_ReadData1(ID_ReadData1), .ID_ReadData2(ID_ReadData2), 
    .ID_SignExtImm(ID_SignExtImm), .ID_Rt(ID_Instruction[20:16]),.ID_Rd(ID_Instruction[15:11]),
    .ID_ALUOp(ID_ALUOut), .ID_ALUSrc(ID_ALUSrc), .ID_RegDst(ID_RegDst), .ID_MemWrite(ID_MemWrite), .ID_MemRead(ID_MemRead), 
    .ID_MemtoReg(ID_MemtoReg), .ID_RegWrite(ID_RegWrite), .EX_PCPlus4(EX_PCPlus4), .EX_ReadData1(EX_ReadData1), 
    .EX_ReadData2(EX_ReadData2), .EX_SignExtImm(EX_SignExtImm), .EX_Rt(EX_Rt), .EX_Rd(EX_Rd), 
    .EX_ALUOp(EX_ALUOut), .EX_ALUSrc(EX_ALUSrc), .EX_RegDst(EX_RegDst), .EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead), 
    .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite), .ID_JumpLink(JumpLink), .EX_JumpLink(EX_JumpLink), .ID_sllcase(ID_sllCase), .EX_sllcase(EX_sllcase),
    .ID_isHalf(isHalf), .EX_isHalf(EX_isHalf), .ID_isByte(isByte), .EX_isByte(EX_isByte), 
    .ID_Instruction(ID_Instruction), .EX_Instruction(EX_Instruction), .IDEX_Flush(IDEX_Flush),
    .ID_PC(ID_PC), .EX_PC(EX_PC), .IFID_Flush(IFID_Flush), .EX_IFIDflush(EX_IFIDflush), .IDEX_Write(IDEX_Write)
    );
    
    (* dont_touch = "true" *) Mux32Bit2To1 ALUSrcMux(.out(EX_ALUInput2), .inA(EX_ReadData2), .inB(EX_SignExtImm), .sel(EX_ALUSrc));   
    
    (* dont_touch = "true" *) Mux32Bit2To1 SLLcaseMux(.out(EX_ALUInput1), .inA(EX_ReadData1), .inB(EX_ReadData2), .sel(EX_sllcase));
    
    (* dont_touch = "true" *) ALU32Bit ALU(.ALUControl(EX_ALUOut), .A(EX_ALUInput1), .B(EX_ALUInput2), .ALUResult(EX_ALUResult));
    
    (* dont_touch = "true" *) Mux32Bit2To1 WriteRegMux (.out(WriteRegOut), .inA(EX_Rt), .inB(EX_Rd), .sel(EX_RegDst));
    
    (* keep = "true" *) assign EX_WriteReg = WriteRegOut[4:0];
    
    
    (* dont_touch = "true" *) EX_MEM EMReg(.clk(datapathClk), .reset(Reset), .EX_ALUResult(EX_ALUResult), .EX_WriteData(EX_ReadData2),.EX_WriteReg(EX_WriteReg),
    .EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead), .EX_MemtoReg(EX_MemtoReg), 
    .EX_RegWrite(EX_RegWrite), .MEM_ALUResult(MEM_ALUResult), .MEM_WriteData(MEM_WriteData), .MEM_WriteReg(MEM_WriteReg), 
    .MEM_MemWrite(MEM_MemWrite), .MEM_MemRead(MEM_MemRead), .MEM_MemtoReg(MEM_MemtoReg), 
    .MEM_RegWrite(MEM_RegWrite), .EX_PCPlus4(EX_PCPlus4), .MEM_PCPlus4(MEM_PCPlus4),
    .EX_JumpLink(EX_JumpLink), .MEM_JumpLink(MEM_JumpLink), .EX_isHalf(EX_isHalf), .MEM_isHalf(MEM_isHalf),
    .EX_isByte(EX_isByte), .MEM_isByte(MEM_isByte),.EX_Instruction(EX_Instruction), .MEM_Instruction(MEM_Instruction),
    .EX_ReadData1(EX_ReadData1), .MEM_ReadData1(MEM_ReadData1),
    .EX_PC(EX_PC), .MEM_PC(MEM_PC), .EXMEM_Flush(EXMEM_Flush)      
     );
      
      
    (* dont_touch = "true" *) DataMemory DM(.Address(MEM_ALUResult), .WriteData(MEM_WriteData), .Clk(datapathClk), .MemWrite(MEM_MemWrite), 
    .MemRead(MEM_MemRead), .ReadData(MEM_ReadData), .isHalf(MEM_isHalf), .isByte(MEM_isByte), .Reset(Reset)); 
    
    
    (* dont_touch = "true" *) MEM_WB MWReg(.clk(datapathClk), .reset(Reset), .MEM_ReadData(MEM_ReadData), .MEM_ALUResult(MEM_ALUResult), 
    .MEM_WriteReg(MEM_WriteReg), .MEM_MemtoReg(MEM_MemtoReg), .MEM_RegWrite(MEM_RegWrite), .WB_ReadData(WB_ReadData),
    .WB_ALUResult(WB_ALUResult), .WB_WriteReg(WB_WriteReg), .WB_MemtoReg(WB_MemtoReg), .WB_RegWrite(WB_RegWrite),
    .MEM_PCPlus4(MEM_PCPlus4), .WB_PCPlus4(WB_PCPlus4), .MEM_JumpLink(MEM_JumpLink), .WB_JumpLink(WB_JumpLink),
    .MEM_PC(MEM_PC), .WB_PC(WB_PC), .MEM_Instruction(MEM_Instruction), .WB_Instruction(WB_Instruction)   
    );
    
    
    //WB Stage
    (* dont_touch = "true" *) Mux32Bit2To1 WB_Mux(
        .out(WriteBackData),
        .inA(WB_ReadData),
        .inB(WB_ALUResult),
        .sel(WB_MemtoReg)
    );
   
    
    (* keep = "true" *) assign WB_FinalWriteReg = (WB_JumpLink) ? 5'd31 : WB_WriteReg; //If JumpLink true then FinalReg = reg31($ra) othrer wise normal WriteReg
    (* keep = "true" *) assign WB_FinalWriteData = (WB_JumpLink) ? (WB_PCPlus4) : WriteBackData; //PC+8 needed for ra reg via Q8 using MIPS set reference
    
    (* keep = "true" *) assign DisplayWriteBackData = (WB_RegWrite) ? WB_FinalWriteData : 0;
    
    
    (* dont_touch = "true" *) Two4DigitDisplay Display (.Clk(Clk), .NumberA(WB_PC[15:0]), .NumberB(DisplayWriteBackData[15:0]), .out7(out7), .en_out(en_out));
   
    
endmodule
