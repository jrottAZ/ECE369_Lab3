`timescale 1ns / 1ps

module ALU32Bit_tb();

    // Inputs
    reg [3:0] ALUControl;
    reg signed [31:0] A, B;

    // Outputs
    wire signed [31:0] ALUResult;
    wire Zero;

    // Instantiate the ALU
    ALU32Bit uut (
        .ALUControl(ALUControl),
        .A(A),
        .B(B),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // Task for easy testing
    task run_test;
        input [3:0] ctrl;
        input signed [31:0] a, b;
        input [127:0] name;   
        begin
            ALUControl = ctrl;
            A = a;
            B = b;
            #20;
            $display("Test: %-10s | ALUCtrl=%b | A=%0d (0x%h) | B=%0d (0x%h) | Result=%0d (0x%h) | Zero=%b",
                     name, ALUControl, A, A, B, B, ALUResult, ALUResult, Zero);
        end
    endtask

    initial begin
        $display("\n=== Starting ALU32Bit Comprehensive Testbench ===\n");

        // Logical ops
        run_test(4'b0000, 32'h0F0F0F0F, 32'hF0F0F0F0, "AND");
        run_test(4'b0001, 32'h0F0F0F0F, 32'hF0F0F0F0, "OR");
        
        // Arithmetic
        run_test(4'b0010, 32'd5, 32'd10, "ADD");
        run_test(4'b0011, 32'd5, 32'd10, "SUB (A-B)");
        run_test(4'b0011, 32'd10, 32'd10, "SUB (zero)");

        // Comparison ops
        run_test(4'b0100, 32'd3, 32'd7, "SLT");
        run_test(4'b0100, 32'd9, 32'd2, "SLT (false)");
        run_test(4'b0110, 32'd8, 32'd5, "SGT");
        run_test(4'b0110, 32'd3, 32'd9, "SGT (false)");

        // Logic ops
        run_test(4'b0101, 32'hFFFF0000, 32'h0F0F0F0F, "NOR");
        run_test(4'b1010, 32'hAAAA5555, 32'h5555AAAA, "XOR");

        // Shift ops
        run_test(4'b1000, 32'h00000001, 32'd4, "SLL");
        run_test(4'b1001, 32'h00000010, 32'd2, "SRL");

        // Sign checks
        run_test(4'b1011, 32'h00000001, 0, "GTEZ (+)");
        run_test(4'b1011, 32'hFFFFFFFF, 0, "GTEZ (-)");
        run_test(4'b1100, 32'hFFFFFFFF, 0, "LTZ (-)");
        run_test(4'b1101, 32'h00000002, 0, "GTZ (+)");
        run_test(4'b1110, 32'hFFFFFFFF, 0, "LTEZ (-)");
        run_test(4'b1110, 32'h00000002, 0, "LTEZ (+)");

        // Multiplication tests
        run_test(4'b1111, 32'hFFFFFFFE, 32'h40000000, "MULT neg");
        run_test(4'b1111, 32'hF0000000, 32'h00000010, "MULT large");

        $display("\n=== All tests completed ===\n");
        $finish;
    end

endmodule
