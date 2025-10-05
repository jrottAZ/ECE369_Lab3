`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - ALU32Bit_tb.v
// Description - Test the 'ALU32Bit.v' module.
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit_tb(); 

	reg [3:0] ALUControl;   // control bits for ALU operation
	reg [31:0] A, B;	        // inputs

	wire [31:0] ALUResult;	// answer
	wire Zero;	        // Zero=1 if ALUResult == 0

    ALU32Bit u0(
        .ALUControl(ALUControl), 
        .A(A), 
        .B(B), 
        .ALUResult(ALUResult), 
        .Zero(Zero)
    );

	initial begin
	
    /* Please fill in the implementation here... */
    
    //initialize A and B
	A = 32'd5;
	B = 32'd10;
	
	
	//Test here
	// Test AND
        ALUControl = 4'b0000; #10;

        // Test OR
        ALUControl = 4'b0001; #10;

        // Test ADD
        ALUControl = 4'b0010; #10;

        // Test SUB (non-zero)
        ALUControl = 4'b0110; #10;

        // Test SUB (zero result)
        A = 32'd5; B = 32'd5;
        ALUControl = 4'b0110; #10;

        // Test SLT (A < B)
        A = 32'd3; B = 32'd7;
        ALUControl = 4'b0111; #10;

        // Test SLT (A >= B)
        A = 32'd9; B = 32'd2;
        ALUControl = 4'b0111; #10;

        // Test NOR
        A = 32'hFFFF0000; B = 32'h0F0F0F0F;
        ALUControl = 4'b1100; #10;

        // Done
	$finish;
	end

endmodule

