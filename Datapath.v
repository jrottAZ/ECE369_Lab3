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

//////////////////////////////////////////WIRE DECLARATIONS FOR EACH STAGE////////////////////////////////

    // Fetch wires 
    wire [31:0] PCin;
    wire [31:0] PCout;
    wire [31:0] instructionF;
    wire [31:0] PCAoutF;
    
    // Decode wires
    wire [31:0] PCAoutD;   
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
    
    // Execute wires
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
    wire [31:0] OffsetE;
    wire [31:0] ReadData1E;
    wire [31:0] ReadData2E;
    wire [31:0] ALUIn2;
    wire [4:0] RegisterDestinationE;
    wire [31:0] ShiftedOffset;
    wire [31:0] BranchAddressE;
    wire [31:0] ALU1ResultE;
    wire ALU1ZeroE;
    
    // Memory wires
    wire RegWriteM;
    wire BranchM;
    wire MemReadM;
    wire MemWriteM;
    wire ALUZeroM;
    wire [31:0] ReadData2M;
    wire [31:0] ALU1ResultM;
    wire [4:0] RegisterDestinationM;
    wire [31:0] MemToRegM;
    wire [31:0] MemOutM;
    wire PCSrcM;
    wire [31:0] BranchAddressM;
    
    // Write Back wires
    wire RegWriteW;
    wire [31:0] ALU1ResultW;
    wire MemToRegW;
    wire [31:0] MemOutW;
    wire [4:0] RegisterDestinationW;
    wire [31:0] WriteDataW;
    

   

/////////////////////////       Fetch           //////////////////////////////////////////////////////////
    
    //Datapath Components for the stage
    Mux32Bit2To1 muxPCInput(
        .out(PCin),
        .inA(PCAoutF), 
        .inB(BranchAddressM), 
        .sel(PCSrcM));
    
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
        .PCAddResult(PCAoutF));
    
    
    //Declare registers for between stages   
    reg [31:0] IFID_instruction;
    reg [31:0] IFID_PCAout;
    
    
/////////////////////////       Decode           /////////////////////////////////////////////////////////
    
    //Take from Regiesters of Prevous Stages
    assign instructionD = IFID_instruction;
    assign PCAoutD = IFID_PCAout;
    
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
        .WriteRegister(RegisterDestinationW), 
        .WriteData(WriteDataW), 
        .RegWrite(RegWriteW), 
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
    reg [31:0] IDEX_Offset;
    reg [31:0] IDEX_ReadData1;
    reg [31:0] IDEX_ReadData2;
    
    

/////////////////////////       Execute           ////////////////////////////////////////////////////////
    
    //Take from Regiesters of Prevous Stages
    assign PCAoutE = IDEX_PCAout;
    assign instructionE = IDEX_instruction;
    assign RegWriteE = IDEX_RegWrite;
    assign RegDstE = IDEX_RegDst;
    assign ALUSrcE = IDEX_ALUSrc;
    assign ALUOpE = IDEX_ALUOp;
    assign BranchE = IDEX_Branch;
    assign MemWriteE = IDEX_MemWrite;
    assign MemReadE = IDEX_MemRead;
    assign MemToRegE = IDEX_MemToReg;
    assign OffsetE = IDEX_Offset;
    assign ReadData1E = IDEX_ReadData1;
    assign ReadData2E = IDEX_ReadData2;
    
    //Datapath Components for the stage
    
    Mux32Bit2To1 muxALUSrc(
        .out(ALUIn2),
        .inA(ReadData2E),
        .inB(OffsetE),
        .sel(ALUSrcE));
        
    Mux5Bit2To1 muxRegDst(
        .out(RegisterDestinationE),
        .inA(instructionE[20:16]),
        .inB(instructionE[15:11]),
        .sel(RegDstE));
        
    ShiftLeft offsetShift(
        .InA(OffsetE),
        .shamt(32'd2),
        .Out(ShiftedOffset));
    
    Adder adder1(
        .InA(PCAoutE),
        .InB(ShiftedOffset),
        .Out(BranchAddressE));
        
    ALU32Bit ALU1(
        .ALUControl(ALUOpE),
        .A(ReadData1E),
        .B(ALUIn2),
        .ALUResult(ALU1RsultE),
        .Zero(ALU1ZeroE));
    
    
    //Declare registers for between stages
    reg [31:0] EXMEM_BranchAddress;
    reg EXMEM_RegWrite;
    reg EXMEM_Branch;
    reg EXMEM_MemRead;
    reg EXMEM_MemWrite;
    reg EXMEM_ALU1Zero;
    reg [31:0] EXMEM_ReadData2;
    reg [31:0] EXMEM_ALU1Result;
    reg [4:0] EXMEM_RegisterDestination;
    reg EXMEM_MemToReg;
    


/////////////////////////       Memory           /////////////////////////////////////////////////////////

    //Take from Regiesters of Prevous Stages
    assign BrancAddressM = EXMEM_BranchAddress;
    assign RegWriteM = EXMEM_RegWrite;
    assign BranchM = EXMEM_Branch;
    assign MemReadM = EXMEM_MemRead;
    assign MemWriteM = EXMEM_MemWrite;
    assign ALU1ZeroM = EXMEM_ALU1Zero;
    assign ReadData2M = EXMEM_ReadData2;
    assign ALU1ResultM = EXMEM_ALU1Result;
    assign RegisterDestinationM = EXMEM_RegisterDestination;
    assign MemToRegM = EXMEM_MemToReg;
    
    
    //Datapath Components for the stage
    And and1(
        .InA(BranchM),
        .InB(ALUZeroM),
        .Out(PCSrcM));
        
    DataMemory DM(
        .Address(ALU1ResultM), 
        .WriteData(ReadRegister2M), 
        .Clk(Clk), 
        .MemWrite(MemWriteM), 
        .MemRead(MemReadM), 
        .ReadData(MemOutM));
    
    //Declare registers for between stages
    reg MEMWB_RegWrite;
    reg [31:0] MEMWB_ALU1Result;
    reg MEMWB_MemToReg;
    reg [31:0] MEMWB_MemOut;
    reg [4:0] MEMWB_RegisterDestination;
    
    
/////////////////////////       WriteBack           //////////////////////////////////////////////////////

    //Take from Regiesters of Prevous Stages
    assign RegWriteW = MEMWB_RegWrite;
    assign ALU1ResultW = MEMWB_ALU1Result;
    assign MemToRegW = MEMWB_MemToReg;
    assign MemOutW = MEMWB_MemOut;
    assign RegisterDestinationW = MEMWB_RegisterDestination;
    
    //Datapath Components for the stage
    Mux32Bit2To1 muxWriteBack(
        .out(WriteDataW), 
        .inA(MemOutW), 
        .inB(ALU1ResultW), 
        .sel(MemToRegW));
    
    //Declare registers for between stages


//////////////////////////Register Changes///////////////////////////////////////////////////////////////
    always @(posedge Clk) begin
        //Fetch Stage to Decode Stage
        IFID_instruction <= instructionF;
        IFID_PCAout <= PCAoutF;
        
        //Decode Stage to Execute Stage
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
        IDEX_ReadData1 <= ReadData1D;
        IDEX_ReadData2 <= ReadData2D;
        
        //Execute Stage to Memory Stage
        EXMEM_BranchAddress <= BranchAddressE;
        EXMEM_RegWrite <= RegWriteE;
        EXMEM_Branch <= BranchE;
        EXMEM_MemRead <= MemReadE;
        EXMEM_MemWrite <= MemWriteE;
        EXMEM_ALU1Result <= ALU1ResultE;
        EXMEM_RegisterDestination <= RegisterDestinationE;
        EXMEM_ReadData2 <= ReadData2E;
        EXMEM_ALU1Zero <= ALU1ZeroE;
        EXMEM_MemToReg <= MemToRegE;
        
        //Memory Stage to Write Back Stage
        MEMWB_RegWrite <= RegWriteM;
        MEMWB_ALU1Result <= ALU1ResultM;
        MEMWB_MemToReg <= MemToRegM;
        MEMWB_MemOut <= MemOutM;
        MEMWB_RegisterDestination <= RegisterDestinationM;
 
        
    end

endmodule
