`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2025 02:53:26 PM
// Design Name: 
// Module Name: MainControl
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

module MainControl(Instruction, ALUOut, MemtoReg, RegWrite, ALUSrc, RegDst, Branch, MemWrite, MemRead,
Jump, JumpReg, JumpLink, SllCase, Logical, isHalf, isByte, ID_rs_Flag, ID_rt_Flag);

    input [31:0]Instruction;
    output reg [4:0]ALUOut;
    output reg ID_rs_Flag;
    output reg ID_rt_Flag;
    
    output reg MemtoReg;
    output reg RegWrite;
    output reg ALUSrc;
    output reg RegDst;
    output reg Branch;
    output reg MemWrite;
    output reg MemRead;  
    output reg Jump;
    output reg JumpReg;
    output reg JumpLink;
    output reg SllCase;
    output reg Logical;
    output reg isHalf;
    output reg isByte;
    
    always @(*) begin
    // Default values (prevents latches)
        ALUOut = 0;
        RegWrite = 0;
        RegDst = 0;
        ALUSrc = 0;
        MemtoReg = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        Jump = 0;
        JumpReg = 0;
        JumpLink = 0;
        SllCase = 0;
        Logical = 0; 
        isHalf = 0;
        isByte = 0;
        ID_rs_Flag = 0;
        ID_rt_Flag = 0;
        
        if (Instruction == 0) begin
            ALUOut = 0;
            RegWrite = 0;
            RegDst = 0;
            ALUSrc = 0;
            MemtoReg = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            Jump = 0;
            JumpReg = 0;
            JumpLink = 0;
            SllCase = 0;
            Logical = 0; 
        end
        
        else if (Instruction[31:26] == 6'b000000) begin // R-type
            RegWrite = 1;
            RegDst = 1;
            ALUSrc = 0;
            MemtoReg = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            Jump = 0;
            ID_rs_Flag = 1;
            ID_rt_Flag = 1;
            
            case (Instruction[5:0])
                6'b100000: ALUOut = 0; //add
                6'b100010: ALUOut = 1; //sub
                6'b100100: begin
                    ALUOut = 3; //and
                end
                6'b100101: begin 
                    ALUOut = 4; //or
                end
                6'b100111: begin
                    ALUOut = 5; //nor
                end
                6'b100110: begin
                    ALUOut = 6; //xor
                end
                6'b000000: begin 
                    ALUOut = 7; //sll
                    ALUSrc = 1;
                    SllCase = 1;
                    ID_rs_Flag = 0; //rs no used
                    ID_rt_Flag = 1;
                    
                end
                6'b000010: begin
                    ALUOut = 8; //srl
                    ALUSrc = 1;
                    SllCase = 1;
                    ID_rs_Flag = 0; //rs no used
                    ID_rt_Flag = 1;
                end
                6'b101010: ALUOut = 9; //slt
                6'b001000: begin //jr
                    Jump = 1;
                    RegWrite = 0;
                    JumpReg = 1;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rt no used
                end
            endcase
        end 
        
        else if (Instruction[31:26] == 6'b000010) begin // j
            Jump = 1;
            JumpLink = 0;
            RegWrite = 0;
            JumpReg = 0;
            ID_rs_Flag = 0;
            ID_rt_Flag = 0;  // no used
        end 
        
        else if (Instruction[31:26] == 6'b000011) begin // jal
            Jump = 1;
            JumpLink = 1;
            RegWrite = 1;
            RegDst = 0; // writes to $ra via datapath logic
            JumpReg = 0; 
            ID_rs_Flag = 0;
            ID_rt_Flag = 0;  //no used
        end
        
        else begin // I-type
            case (Instruction[31:26])
                6'b011100: begin //mul
                    if(Instruction[5:0] == 6'b000010) begin
                        RegWrite = 1; MemtoReg = 1; RegDst = 1; 
                        ALUOut = 2;
                        ID_rs_Flag = 1;
                        ID_rt_Flag = 1;  //both used
                    end
                end    
                6'b001000: begin // addi
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    ALUOut = 0;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b100011: begin // lw
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    MemtoReg = 0; MemRead = 1; ALUOut = 0;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b101011: begin // sw
                    ALUSrc = 1; MemWrite = 1; ALUOut = 0;
                    MemtoReg = 0;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 1;  //both used
                end
                6'b100000: begin // lb
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    MemtoReg = 0; MemRead = 1; ALUOut = 0;
                    isByte = 1;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b101000: begin // sb
                    ALUSrc = 1; MemWrite = 1; ALUOut = 0;
                    isByte = 1;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 1;  //rs used
                end
                6'b100001: begin // lh
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    MemtoReg = 0; MemRead = 1; ALUOut= 0;
                    isHalf = 1;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b101001: begin // sh
                    ALUSrc = 1; MemWrite = 1; ALUOut = 0;
                    MemtoReg = 0; isHalf = 1;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 1;  //rs used
                end
                6'b001100: begin // andi
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    ALUOut = 3; Logical = 1;
                end
                6'b001101: begin //ori
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    ALUOut = 4; Logical = 1;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b001110: begin // xori
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    ALUOut = 6; Logical = 1;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                    
                end
                6'b001010: begin // slti
                    RegWrite = 1; RegDst = 0; ALUSrc = 1;
                    ALUOut = 9;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b000100: begin // beq
                    Branch = 1; ALUOut = 11; RegWrite = 0;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 1;  //rs used
                end
                6'b000101: begin // bne
                    Branch = 1; ALUOut = 12; RegWrite = 0;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 1;  //rs used
                end
                6'b000111: begin // bgtz
                    Branch = 1; ALUOut = 13; RegWrite = 0;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b000110: begin // blez
                    Branch = 1; ALUOut = 14; RegWrite = 0;
                    ID_rs_Flag = 1;
                    ID_rt_Flag = 0;  //rs used
                end
                6'b000001: begin // bgez / bltz
                    Branch = 1;
                    RegWrite = 0;
                    if (Instruction[20:16] == 6'b000000)begin
                        ALUOut = 15; // bltz
                    end
                    else if (Instruction[20:16] == 6'b000001) begin
                        ALUOut = 10; // bgez
                    end
                    ID_rs_Flag = 1; 
                    ID_rt_Flag = 0;  //rs used
                end
            endcase
        end
    end
endmodule
