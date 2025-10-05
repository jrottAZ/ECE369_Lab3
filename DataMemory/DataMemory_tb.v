`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - DataMemory_tb.v
// Description - Test the 'DataMemory.v' module.
////////////////////////////////////////////////////////////////////////////////

module DataMemory_tb(); 

    reg     [31:0]  Address;
    reg     [31:0]  WriteData;
    reg             Clk;
    reg             MemWrite;
    reg             MemRead;

    wire [31:0] ReadData;

    DataMemory u0(
        .Address(Address), 
        .WriteData(WriteData), 
        .Clk(Clk), 
        .MemWrite(MemWrite), 
        .MemRead(MemRead), 
        .ReadData(ReadData)
    ); 

	initial begin
		Clk <= 1'b0;
		forever #10 Clk <= ~Clk;
		
	end


	initial begin
	
    /* Please fill in the implementation here... */
	// Initialize
	Address = 0;
	WriteData = 0;
	MemWrite = 0;
	MemRead = 0;
	
	#20;
	
	// Write data to adress 100
	
	Address = 32'd100;
	WriteData = 32'd69;
	MemWrite = 1; MemRead = 0;
	@(posedge Clk);
	MemWrite = 0;
	
	//---------------------
	
	//Read data
	@(posedge Clk);
	MemRead = 1;
	Address = 32'd100;
	#1;
	$display("ReadData @ Address 100 = %d", ReadData);
	#10;
	MemRead = 0;
	
	//------------------
	//Another Address'
	MemWrite =1;
	Address = 32'd104;
	WriteData = 32'd70;
	@(posedge Clk);  
	MemWrite = 0;
	
	//------------
	//Read Both
	//-------------
	Address = 32'd100;
	MemRead = 1;
	#10;
	
	Address = 32'd104;
	#10;
	
	MemRead = 0;
	
	#20;
	$stop;
	
	
	end

endmodule

