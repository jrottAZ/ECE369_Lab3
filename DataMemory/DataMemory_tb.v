`timescale 1ns / 1ps

module DataMemory_tb();

    reg [31:0] Address;
    reg [31:0] WriteData;
    reg Clk;
    reg MemWrite;
    reg MemRead;

    wire [31:0] ReadData;

    // Instantiate the memory module
    DataMemory u0(
        .Address(Address),
        .WriteData(WriteData),
        .Clk(Clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ReadData(ReadData)
    );

    // Clock generator
    initial begin
        Clk = 1'b0;
        forever #10 Clk = ~Clk;
    end

    // Task to perform a write and show what happens
    task write_mem;
        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge Clk);
            Address = addr;
            WriteData = data;
            MemWrite = 1;
            MemRead  = 0;
            #40
            @(posedge Clk);  // perform the write
            MemWrite = 0;
            #1;
            $display("[WRITE] @%0t | Addr=0x%0h | Data=0x%08h | MemSize=%b | Mem[%0d]=0x%08h",
                     $time, addr, data, addr[11:10], addr[9:2], u0.Memory[addr[9:2]]);
        end
    endtask

    // Task to perform a read and show what happens
    task read_mem;
        input [31:0] addr;
        begin
            @(negedge Clk);
            Address = addr;
            MemWrite = 0;
            MemRead  = 1;
            #40
            @(negedge Clk);
            #1;
            $display("[READ ] @%0t | Addr=0x%0h | MemSize=%b | ReadData=0x%08h | Mem[%0d]=0x%08h",
                     $time, addr, addr[11:10], ReadData, addr[9:2], u0.Memory[addr[9:2]]);
            @(posedge Clk);
            MemRead = 0;
        end
    endtask

    // Main stimulus
    initial begin
        // Initialize
        Address   = 32'b0;
        WriteData = 0;
        MemWrite  = 0;
        MemRead   = 0;

        #25;

        $display("\n=== Starting Data Memory Test ===\n");

        // Test 1: Write full word
        write_mem(32'd100, 32'hAABBCCDD);
        #40;
        read_mem(32'd100);

        // Test 2: Write halfword (lower half)
        write_mem(32'h105, 32'h67671234);
        #40;
        read_mem(32'h105);
        
        //Test 3: Write halfword (upper half)
        write_mem(32'h106, 32'h12345678);
        #40;
        read_mem(32'h106);

        // Test 3: Write byte (upper byte)
        write_mem(32'd108, 32'h676700FF);
        #40;
        read_mem(32'd108);

        // Test 4: Write full word again
        write_mem(32'd112, 32'h12345678);
        #40;
        read_mem(32'd112);

        

        $display("\n=== Test Complete ===\n");
        #50;
        $stop;
        
    end

endmodule
