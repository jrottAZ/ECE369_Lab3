`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2025 02:08:51 PM
// Design Name: 
// Module Name: TopDesign_369Lab1
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


module TopDesign_369Lab1(Clk, Reset, out7, en_out);

input Clk, Reset;
output [6:0] out7;
output [7:0] en_out;

wire [31:0] PCResult, Instruction;
wire Clkd;

ClkDiv cdiv(Clk, 1'b0, Clkd);
InstructionFetchUnit ifu(Instruction, PCResult, Reset, Clkd);
Two4DigitDisplay disp(Clk, Instruction[15:0], PCResult[15:0],out7, en_out);










endmodule
