`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2025 01:02:21 PM
// Design Name: 
// Module Name: datapath_tb
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


module datapath_tb();

reg Clk_tb, Rst_tb;
    wire [31:0] WD_tb;

    Datapath uut(
        .Clk(Clk_tb),
        .Rst(Rst_tb),
        .Write_Data(WD_tb)
    );

    // Clock generation
    initial begin
        Clk_tb = 0;
        forever #50 Clk_tb = ~Clk_tb;  // 10ns period = 100MHz
    end

    // Simulation sequence
    initial begin
        Rst_tb = 1;
        #200;
        Rst_tb = 0;
        
        // Run simulation for N cycles
    end
endmodule
