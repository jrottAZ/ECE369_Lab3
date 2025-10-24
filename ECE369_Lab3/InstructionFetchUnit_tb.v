`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2025 02:20:57 PM
// Design Name: 
// Module Name: InstructionFetchUnit_tb
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


module InstructionFetchUnit_tb();
reg Clk;
reg Reset;
wire [31:0] Instruction;
wire [31:0] PCResult;



InstructionFetchUnit dut (
    .Instruction(Instruction),
    .PCResult(PCResult),
    .Reset(Reset),
    .Clk(Clk)
);

   initial Clk = 0;
   always #5 Clk = ~Clk;
   
   
   initial begin
   
   
   Reset = 1;
   #20;
   
   Reset = 0;
   #15;
   
   Reset = 1;
   #10;
   
   Reset = 0;
   #50;


    end
endmodule
