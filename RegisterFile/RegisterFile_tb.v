`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - RegisterFile.v
// Description - Test the register_file
// Suggested test case - First write arbitrary values into 
// the saved and temporary registers (i.e., register 8 through 25). Then, 2-by-2, 
// read values from these registers.
////////////////////////////////////////////////////////////////////////////////


module RegisterFile_tb();

	reg [4:0] ReadRegister1;
	reg [4:0] ReadRegister2;
	reg	[4:0] WriteRegister;
	reg [31:0] WriteData;
	reg RegWrite;
	reg Clk;

	wire [31:0] ReadData1;
	wire [31:0] ReadData2;


	RegisterFile u0(
		.ReadRegister1(ReadRegister1), 
		.ReadRegister2(ReadRegister2), 
		.WriteRegister(WriteRegister), 
		.WriteData(WriteData), 
		.RegWrite(RegWrite), 
		.Clk(Clk), 
		.ReadData1(ReadData1), 
		.ReadData2(ReadData2)
	);

	initial begin
		Clk <= 1'b0;
		forever #10 Clk <= ~Clk;
	end

	initial begin
	
    /* Please fill in the implementation here... */
    //Initialize
    RegWrite = 0;
    WriteData = 0;
    ReadRegister1 =0;
    ReadRegister2 =0;
    // --------------------
    #20;//wait
    //----------------------
    //test writing 
    RegWrite = 1;
    
    // write in 8 - 11
    #10
    WriteRegister = 8; WriteData = 32'd4; @(posedge Clk);
    WriteRegister = 9; WriteData = 32'd5; @(posedge Clk);
    WriteRegister = 10; WriteData = 32'd6; @(posedge Clk);
    WriteRegister = 11; WriteData = 32'd7; @(posedge Clk);
    
    // Stop writing
    RegWrite = 0;
    @(posedge Clk);
    
    //Test Reading
    
    ReadRegister1 = 8; ReadRegister2 = 9; @(negedge Clk);
	
	ReadRegister1 = 10; ReadRegister2 = 11; @(negedge Clk);

	//check overwrtiing register 8
	RegWrite = 1;
	WriteRegister = 8; WriteData = 32'd69; @(posedge Clk);
	    ReadRegister1 = 8; ReadRegister2 = 9; @(negedge Clk);
	RegWrite = 0;
	
	
	#20;
	end

endmodule
