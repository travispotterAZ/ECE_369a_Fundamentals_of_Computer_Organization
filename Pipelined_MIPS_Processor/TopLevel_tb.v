`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 03:03:01 PM
// Design Name: 
// Module Name: TopLevel_tb
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


module TopLevel_tb();
    reg Clk;
    reg Reset;

    wire [6:0] out7;
    wire [7:0] en_out;
  /*  wire dbg_WB_MemtoReg;
    wire dbg_PCSrc;
    wire dbg_MEM_Branch;
    wire dbg_MEM_Zero;

    // Debug signals you display
    wire dbg_ID_Jump;
    wire dbg_EX_Jump;
    wire dbg_MEM_Jump;
    wire [31:0] dbg_PCBeforeBranch;
    wire [31:0] dbg_PCAfterBranch;*/

    // Instantiate DUT
    Top_Level_Datapath DUT (
        .Clk(Clk),
        .Reset(Reset),
        .out7(out7),
        .en_out(en_out)
        /*,
        .dbg_WB_MemtoReg(dbg_WB_MemtoReg),
        .dbg_PCSrc(dbg_PCSrc),
        .dbg_MEM_Branch(dbg_MEM_Branch),
        .dbg_MEM_Zero(dbg_MEM_Zero),
        // add your debug signals here
        .dbg_ID_Jump(dbg_ID_Jump),
        .dbg_EX_Jump(dbg_EX_Jump),
        .dbg_MEM_Jump(dbg_MEM_Jump),
        .dbg_PCBeforeBranch(dbg_PCBeforeBranch),
        .dbg_PCAfterBranch(dbg_PCAfterBranch)*/
    );

    // Clock generator: 10 ns period
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

    // Stimulus
    initial begin
        Reset = 1;
        #20;       // hold Reset for 2 clock cycles
        Reset = 0;
        #50000000;
    
        $finish;
    end
    
    

endmodule
