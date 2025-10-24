`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2025 10:24:37 AM
// Design Name: 
// Module Name: controller_tb
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




module controller_tb;

    // Inputs
    reg [5:0] opcode;
    reg [5:0] func;

    // Outputs
    wire RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemRead, MemToReg;
    wire [3:0] ALUOp;

    // Instantiate the controller
    controller uut (
        .opcode(opcode),
        .func(func),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .Branch(Branch),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg)
    );

    // Display task for consistent formatting
    task display_signals;
        input [200*8:1] testname;
        begin
            $display("%s", testname);
            $display("Time=%0t | opcode=%b func=%b", $time, opcode, func);
            $display(" RegWrite=%b | RegDst=%b | ALUSrc=%b | ALUOp=%b | Branch=%b | MemWrite=%b | MemRead=%b | MemToReg=%b\n",
                RegWrite, RegDst, ALUSrc, ALUOp, Branch, MemWrite, MemRead, MemToReg);
        end
    endtask

    initial begin
        $display("\n=========================================");
        $display("Starting Controller Functional Testbench");
        $display("=========================================\n");

        // ---- R-type instructions ----
        opcode = 6'b000000; func = 6'b100000; #10; display_signals("R-type ADD");
        func = 6'b100010; #10; display_signals("R-type SUB");
        func = 6'b100100; #10; display_signals("R-type AND");
        func = 6'b100101; #10; display_signals("R-type OR");
        func = 6'b100111; #10; display_signals("R-type NOR");
        func = 6'b100110; #10; display_signals("R-type XOR");
        func = 6'b101010; #10; display_signals("R-type SLT");
        func = 6'b000010; #10; display_signals("R-type SRL");
        func = 6'b000000; #10; display_signals("R-type SLL");

        // ---- I-type arithmetic ----
        opcode = 6'b001000; func = 6'b000000; #10; display_signals("I-type ADDI");
        opcode = 6'b001010; func = 6'b000000; #10; display_signals("I-type SLTI");
        opcode = 6'b001100; func = 6'b000000; #10; display_signals("I-type ANDI");
        opcode = 6'b001101; func = 6'b000000; #10; display_signals("I-type ORI");
        opcode = 6'b001110; func = 6'b000000; #10; display_signals("I-type XORI");

        // ---- Memory instructions ----
        opcode = 6'b100011; func = 6'b000000; #10; display_signals("Memory LW");
        opcode = 6'b101011; func = 6'b000000; #10; display_signals("Memory SW");
        opcode = 6'b100001; func = 6'b000000; #10; display_signals("Memory LH");
        opcode = 6'b101001; func = 6'b000000; #10; display_signals("Memory SH");
        opcode = 6'b100000; func = 6'b000000; #10; display_signals("Memory LB");
        opcode = 6'b101000; func = 6'b000000; #10; display_signals("Memory SB");

        // ---- Branch instructions ----
        opcode = 6'b000100; func = 6'b000000; #10; display_signals("Branch BEQ");
        opcode = 6'b000101; func = 6'b000000; #10; display_signals("Branch BNE");
        opcode = 6'b000001; func = 6'b000001; #10; display_signals("Branch BGEZ");
        opcode = 6'b000001; func = 6'b000000; #10; display_signals("Branch BLTZ");
        opcode = 6'b000111; func = 6'b000000; #10; display_signals("Branch BGTZ");
        opcode = 6'b000110; func = 6'b000000; #10; display_signals("Branch BLEZ");

        // ---- Jump instructions ----
        opcode = 6'b000010; func = 6'b000000; #10; display_signals("Jump J");
        opcode = 6'b000011; func = 6'b000000; #10; display_signals("Jump and Link JAL");

        $display("\n==================================");
        $display("Controller Testbench Complete");
        $display("==================================\n");

        $stop;
    end

endmodule


