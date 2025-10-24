`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 02:07:10 PM
// Design Name: 
// Module Name: Datapath
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


module Datapath(Clk);

    input Clk;

    wire ClkOut;
    wire Rst;
    

/////////////////////////F////////////////////////////////////////////////////////////////////////////////
    
    // Creating new needed wires 
    wire [31:0] PCin;
    wire [31:0] PCout;
    wire [31:0] instructionF;
    wire [31:0] PCAout;
    
    //Take from Regiesters of Prevous Stages
    
    //Datapath Components for the stage
    ProgramCounter pc(
        .Address(PCin),
        .PCResult(PCout),
        .Reset(Rst),
        .Clk(Clk));
        
    InstructionMemory im(
        .Address(PCout),
        .Instruction(instructionF));
        
    PCAdder pca(
        .PCResult(PCout),
        .PCAddResult(PCAout));
    
    
    //Declare registers for between stages   
    reg [31:0] IFID_instruction;
    reg [31:0] IFID_PCAout;
    
    
/////////////////////////D//////////////////////////////////////////////////////////////////////////////


    // Creating new needed wires
    wire PCAoutD;   
    wire [31:0] instructionD;
    wire RegWriteD;
    wire RegDstD;
    wire ALUSrcD;
    wire [3:0] ALUOpD;
    wire BranchD;
    wire MemWriteD;
    wire MemReadD;
    wire MemToRegD;
    wire [31:0] ReadData1D;
    wire [31:0] ReadData2D;
    wire [31:0] OffsetD;
    
    //Take from Regiesters of Prevous Stages
    assign instructionD = IFID_instruction;
    assign PCoutD = IFID_PCAout;
    
    //Datapath Components for the stage
    controller cont(
        .opcode(instructionD[31:26]), 
        .func(instructionD[5:0]), 
        .RegWrite(RegWriteD),
        .RegDst(RegDstD),
        .ALUSrc(ALUSrcD), 
        .ALUOp(ALUOpD), 
        .Branch(BranchD), 
        .MemWrite(MemWriteD), 
        .MemRead(MemReadD), 
        .MemToReg(MemToRegD));
               
    RegisterFile rf(
        .ReadRegister1(instructionD[25:21]),
        .ReadRegister2(instructionD[20:16]), 
        .WriteRegister(NEEDTOIMPLEMENT), 
        .WriteData(NEEDTOIMPLEMENT), 
        .RegWrite(NEEDTOIMPLEMENT), 
        .Clk(Clk), 
        .ReadData1(ReadData1D),
        .ReadData2(ReadData2D));
      
    SignExtension se(
        .in(instructionD[15:0]),
        .out(OffsetD));
        
    //Declare registers for between stages
    reg [31:0] IDEX_PCAout;
    reg [31:0] IDEX_instruction;
    reg IDEX_RegWrite;
    reg IDEX_RegDst;
    reg IDEX_ALUSrc;
    reg [3:0] IDEX_ALUOp;
    reg IDEX_Branch;
    reg IDEX_MemWrite;
    reg IDEX_MemRead;
    reg IDEX_MemToReg;
    reg IDEX_Offset;
    
    

/////////////////////////E//////////////////////////////////////////////////////////////////////////////

    // Creating new needed wires
    wire [31:0] PCAoutE;
    wire [31:0] instructionE;
    wire RegWriteE;
    wire RegDstE;
    wire ALUSrcE;
    wire [3:0] ALUOpE;
    wire BranchE;
    wire MemWriteE;
    wire MemReadE;
    wire MemToRegE;
    wire OffsetE;
    

/////////////////////////M//////////////////////////////////////////////////////////////////////////////

/////////////////////////W//////////////////////////////////////////////////////////////////////////////

    always @(posedge Clk) begin
        //Fetch Stage 
        IFID_instruction <= instructionF;
        IFID_PCAout <= PCAout;
        
        //Decode Stage
        IDEX_PCAout <= PCAoutD;
        IDEX_instruction <= instructionD;
        IDEX_RegWrite <= RegWriteD;
        IDEX_RegDst <= RegDstD;
        IDEX_ALUSrc <= ALUSrcD;
        IDEX_ALUOp <= ALUOpD;
        IDEX_Branch <= BranchD;
        IDEX_MemWrite <= MemWriteD;
        IDEX_MemRead <= MemReadD;
        IDEX_MemToReg <= MemToRegD;
        IDEX_Offset <= OffsetD;
    end

endmodule
