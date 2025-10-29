`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - DataMemory_tb.v
// Description - Comprehensive testbench for 'DataMemory.v'
////////////////////////////////////////////////////////////////////////////////

module DataMemory_tb(); 

    reg     [31:0]  Address;
    reg     [31:0]  WriteData;
    reg             Clk;
    reg             MemWrite;
    reg             MemRead;
    reg     [1:0]   MemSize;
    wire    [31:0]  ReadData;

    // Instantiate DataMemory
    DataMemory uut(
        .Address(Address), 
        .WriteData(WriteData), 
        .Clk(Clk), 
        .MemWrite(MemWrite), 
        .MemRead(MemRead), 
        .MemSize(MemSize),
        .ReadData(ReadData)
    ); 

    // Clock generation
    initial begin
        Clk = 0;
        forever #10 Clk = ~Clk;
    end

    // Helper task for display
    task show_op;
        input [127:0] op_name;
        input [31:0] addr;
        input [31:0] wdata;
        input [31:0] rdata;
        input [1:0]  size;
        begin
            $display("Time=%0t | %-8s | Addr=0x%08h (%0d) | Size=%s | WriteData=0x%08h | ReadData=0x%08h (%0d)",
                $time, op_name, addr, addr,
                (size==2'b00) ? "WORD" :
                (size==2'b01) ? "HALF" :
                (size==2'b10) ? "BYTE" : "UNK",
                wdata, rdata, rdata);
        end
    endtask

    initial begin
        $display("\n=== Starting DataMemory Comprehensive Testbench ===\n");

        // Initialize
        Address = 0; WriteData = 0;
        MemWrite = 0; MemRead = 0; MemSize = 2'b00;
        #20;

        // --- Test 1: Store Word ---
        Address = 32'd100;
        WriteData = 32'h12345678;
        MemSize = 2'b00; // word
        MemWrite = 1; MemRead = 0;
        @(posedge Clk);
        MemWrite = 0;
        #1 show_op("WRITE", Address, WriteData, 0, MemSize);

        // --- Test 2: Read Word ---
        MemRead = 1;
        @(negedge Clk);
        #1 show_op("READ", Address, WriteData, ReadData, MemSize);
        MemRead = 0;

        // --- Test 3: Store Halfword (lower half) ---
        Address = 32'd104;
        WriteData = 32'h0000ABCD;
        MemSize = 2'b01;
        MemWrite = 1;
        @(posedge Clk);
        MemWrite = 0;
        #1 show_op("WRITE", Address, WriteData, 0, MemSize);

        // --- Test 4: Read Halfword (lower) ---
        MemRead = 1;
        @(negedge Clk);
        #1 show_op("READ", Address, WriteData, ReadData, MemSize);
        MemRead = 0;

        // --- Test 5: Store Byte ---
        Address = 32'd108;
        WriteData = 32'h000000EF;
        MemSize = 2'b10;
        MemWrite = 1;
        @(posedge Clk);
        MemWrite = 0;
        #1 show_op("WRITE", Address, WriteData, 0, MemSize);

        // --- Test 6: Read Byte ---
        MemRead = 1;
        @(negedge Clk);
        #1 show_op("READ", Address, WriteData, ReadData, MemSize);
        MemRead = 0;

        // --- Test 7: Multiple words ---
        Address = 32'd112; WriteData = 32'hCAFEBABE;
        MemSize = 2'b00; MemWrite = 1;
        @(posedge Clk);
        MemWrite = 0;
        #1 show_op("WRITE", Address, WriteData, 0, MemSize);

        MemRead = 1;
        @(negedge Clk);
        #1 show_op("READ", Address, WriteData, ReadData, MemSize);
        MemRead = 0;

        #20;
        $display("\n=== DataMemory Testbench Completed ===\n");
        $finish;
    end

endmodule
