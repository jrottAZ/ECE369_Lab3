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


module Datapath(Clk, Rst, Write_Data);

    input Clk, Rst;
    output [31:0] Write_Data;

    wire ClkOut;
    

//////////////////////////////////////////WIRE DECLARATIONS FOR EACH STAGE////////////////////////////////

    // Fetch wires 
    wire [31:0] PCin;
    wire [31:0] PCinpreJump;
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
    wire [31:0] jumpAddressD;
    wire [31:0] jumpAddress1D;
    wire jumpD;
    wire [1:0] MemSizeD;
    wire branchTypeD;
    wire JorJRD;
    wire JalD;
    
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
    wire [4:0] RegisterDestination1;
    wire [31:0] ShiftedOffset;
    wire [31:0] BranchAddressE;
    wire [31:0] ALU1ResultE;
    wire ALU1ZeroE;
    wire [1:0] MemSizeE;
    wire branchTypeE;
    wire JalE;
    
    // Memory wires
    wire [31:0] PCAoutM;
    wire RegWriteM;
    wire BranchM;
    wire MemReadM;
    wire MemWriteM;
    wire ALU1ZeroM;
    wire ALU1ZeroOut;
    wire NotALU1Zero;
    wire branchTypeM;
    wire [31:0] ReadData2M;
    wire [31:0] ALU1ResultM;
    wire [4:0] RegisterDestinationM;
    wire [31:0] MemToRegM;
    wire [31:0] MemOutM;
    wire PCSrcM;
    wire [31:0] BranchAddressM;
    wire [1:0] MemSizeM;
    wire JalM;
    wire [31:0] tempOut;
    
    // Write Back wires
    wire [31:0] PCAoutW;
    wire RegWriteW;
    wire [31:0] ALU1ResultW;
    wire MemToRegW;
    wire [31:0] MemOutW;
    wire [4:0] RegisterDestinationW;
    wire [31:0] WriteDataW;
    wire JalW;
    wire [31:0] WriteData1;
   

/////////////////////////       Fetch           //////////////////////////////////////////////////////////
    
    //Datapath Components for the stage
    Mux32Bit2To1 muxPCInput(
        .out(PCinpreJump),
        .inA(PCAoutF), 
        .inB(BranchAddressM), 
        .sel(PCSrcM));
        
    Mux32Bit2To1 muxJump(
        .out(PCin), 
        .inA(PCinpreJump), 
        .inB(jumpAddressD), 
        .sel(jumpD));
    
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
        .rtField(instructionD[20:16]), 
        .RegWrite(RegWriteD),
        .RegDst(RegDstD),
        .ALUSrc(ALUSrcD), 
        .ALUOp(ALUOpD), 
        .Branch(BranchD), 
        .MemWrite(MemWriteD), 
        .MemRead(MemReadD), 
        .MemToReg(MemToRegD),
        .MemSize(MemSizeD),
        .jump(jumpD),
        .branchType(branchTypeD),
        .JorJR(JorJRD),
        .Jal(JalD));
               
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
        
    ShiftLeft jumpShift(
        .InA(jumpAddress1D), 
        .shamt(32'd2), 
        .Out(jumpAddressD));
    
    Mux32Bit2To1 jorjr(
        .out(jumpAddress1D),
        .inA({6'b0, instructionD[25:0]}), 
        .inB(ReadData1D), 
        .sel(JorJRD));
        
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
    reg [1:0] IDEX_MemSize;
    reg IDEX_branchType;
    reg IDEX_Jal;
    
    

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
    assign MemSizeE = IDEX_MemSize;
    assign branchTypeE = IDEX_branchType;
    assign JalE = IDEX_Jal;
    
    //Datapath Components for the stage
    
    Mux32Bit2To1 muxALUSrc(
        .out(ALUIn2),
        .inA(ReadData2E),
        .inB(OffsetE),
        .sel(ALUSrcE));
        
    Mux5Bit2To1 muxRegDst(
        .out(RegisterDestination1),
        .inA(instructionE[20:16]),
        .inB(instructionE[15:11]),
        .sel(RegDstE));
        
    Mux5Bit2To1 jalDst(
        .out(RegisterDestinationE),
        .inA(RegisterDestination1),
        .inB(5'd31), //$ra
        .sel(JalE));
        
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
        .shamt(instructionE[10:6]),
        .ALUResult(ALU1ResultE),
        .Zero(ALU1ZeroE));
    
    
    //Declare registers for between stages
    reg [31:0] EXMEM_PCAout;
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
    reg [1:0] EXMEM_MemSize;
    reg EXMEM_branchType;
    reg EXMEM_Jal;
    


/////////////////////////       Memory           /////////////////////////////////////////////////////////

    //Take from Regiesters of Prevous Stages
    assign PCAoutM = EXMEM_PCAout;
    assign BranchAddressM = EXMEM_BranchAddress;
    assign RegWriteM = EXMEM_RegWrite;
    assign BranchM = EXMEM_Branch;
    assign NotALU1Zero = ~EXMEM_ALU1Zero;
    assign MemReadM = EXMEM_MemRead;
    assign MemWriteM = EXMEM_MemWrite;
    assign ALU1ZeroM = EXMEM_ALU1Zero;
    assign ReadData2M = EXMEM_ReadData2;
    assign ALU1ResultM = EXMEM_ALU1Result;
    assign RegisterDestinationM = EXMEM_RegisterDestination;
    assign MemToRegM = EXMEM_MemToReg;
    assign MemSizeM = EXMEM_MemSize;
    assign branchTypeM = EXMEM_branchType;
    assign JalM = EXMEM_Jal;
    assign ALU1ZeroOut = tempOut[0:0];
    
    
    //Datapath Components for the stage
    Mux32Bit2To1 beqOrBne(
        .out(tempOut), 
        .inA(ALU1ZeroM), 
        .inB(NotALU1Zero), 
        .sel(branchTypeM));
        
    And and1(
        .InA(BranchM),
        .InB(ALU1ZeroOut),
        .Out(PCSrcM));
        
    DataMemory DM(
        .Address(ALU1ResultM), 
        .WriteData(ReadData2M), 
        .Clk(Clk), 
        .MemWrite(MemWriteM), 
        .MemRead(MemReadM),
        .MemSize(MemSizeM), 
        .ReadData(MemOutM));
    
    //Declare registers for between stages
    reg [31:0] MEMWB_PCAout;
    reg MEMWB_RegWrite;
    reg [31:0] MEMWB_ALU1Result;
    reg MEMWB_MemToReg;
    reg [31:0] MEMWB_MemOut;
    reg [4:0] MEMWB_RegisterDestination;
    reg MEMWB_Jal;
    
    
/////////////////////////       WriteBack           //////////////////////////////////////////////////////

    //Take from Regiesters of Prevous Stages
    assign PCAoutW = MEMWB_PCAout;
    assign RegWriteW = MEMWB_RegWrite;
    assign ALU1ResultW = MEMWB_ALU1Result;
    assign MemToRegW = MEMWB_MemToReg;
    assign MemOutW = MEMWB_MemOut;
    assign RegisterDestinationW = MEMWB_RegisterDestination;
    assign JalW = MEMWB_Jal;
    
    //Datapath Components for the stage
    Mux32Bit2To1 muxWriteBack(
        .out(WriteData1), 
        .inA(MemOutW), 
        .inB(ALU1ResultW), 
        .sel(MemToRegW));
        
    Mux32Bit2To1 checkForJal(
        .out(WriteDataW), 
        .inA(WriteData1), 
        .inB(PCAoutW), 
        .sel(JalW));
    
    //Declare registers for between stages


//////////////////////////Register Changes///////////////////////////////////////////////////////////////
    always @(posedge Clk or posedge Rst) begin
        
        //check for reset
        if (Rst) begin
            //Fetch Stage to Decode Stage
            IFID_instruction <= 0;
            IFID_PCAout <= 0;
        
            //Decode Stage to Execute Stage
            IDEX_PCAout <= 0;
            IDEX_instruction <= 0;
            IDEX_RegWrite <= 0;
            IDEX_RegDst <= 0;
            IDEX_ALUSrc <= 0;
            IDEX_ALUOp <= 0;
            IDEX_Branch <= 0;
            IDEX_MemWrite <= 0;
            IDEX_MemRead <= 0;
            IDEX_MemToReg <= 0;
            IDEX_Offset <= 0;
            IDEX_ReadData1 <= 0;
            IDEX_ReadData2 <= 0;
            IDEX_MemSize <= 0;
            IDEX_branchType <= 0;
            IDEX_Jal <= 0;
        
            //Execute Stage to Memory Stage
            EXMEM_PCAout <= 0;
            EXMEM_BranchAddress <= 0;
            EXMEM_RegWrite <= 0;
            EXMEM_Branch <= 0;
            EXMEM_MemRead <= 0;
            EXMEM_MemWrite <= 0;
            EXMEM_ALU1Result <= 0;
            EXMEM_RegisterDestination <= 0;
            EXMEM_ReadData2 <= 0;
            EXMEM_ALU1Zero <= 0;
            EXMEM_MemToReg <= 0;
            EXMEM_MemSize <= 0;
            EXMEM_branchType <= 0;
            EXMEM_Jal <= 0;
        
            //Memory Stage to Write Back Stage
            MEMWB_PCAout <= 0;
            MEMWB_RegWrite <= 0;
            MEMWB_ALU1Result <= 0;
            MEMWB_MemToReg <= 0;
            MEMWB_MemOut <= 0;
            MEMWB_RegisterDestination <= 0;
            MEMWB_Jal <= 0;
        end
        
        else begin
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
            IDEX_MemSize <= MemSizeD;
            IDEX_branchType <= branchTypeD;
            IDEX_Jal <= JalD;
        
            //Execute Stage to Memory Stage
            EXMEM_PCAout <= PCAoutE;
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
            EXMEM_MemSize <= MemSizeE;
            EXMEM_branchType <= branchTypeE;
            EXMEM_Jal <= JalE;
        
            //Memory Stage to Write Back Stage
            MEMWB_PCAout <= PCAoutM;
            MEMWB_RegWrite <= RegWriteM;
            MEMWB_ALU1Result <= ALU1ResultM;
            MEMWB_MemToReg <= MemToRegM;
            MEMWB_MemOut <= MemOutM;
            MEMWB_RegisterDestination <= RegisterDestinationM;
            MEMWB_Jal <= JalM;
        
        end
 
        
    end
    
    
    ///////////for testing/////
    assign Write_Data = WriteData1;
    

    

endmodule
