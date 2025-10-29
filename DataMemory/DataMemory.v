`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - data_memory.v
// Description - 32-Bit wide data memory.
//
// INPUTS:-
// Address: 32-Bit address input port.
// WriteData: 32-Bit input port.
// Clk: 1-Bit Input clock signal.
// MemWrite: 1-Bit control signal for memory write.
// MemRead: 1-Bit control signal for memory read.
//
// OUTPUTS:-
// ReadData: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design the above memory similar to the 'RegisterFile' model in the previous 
// assignment.  Create a 1K memory, for which we need 10 bits.  In order to 
// implement byte addressing, we will use bits Address[11:2] to index the 
// memory location. The 'WriteData' value is written into the address 
// corresponding to Address[11:2] in the positive clock edge if 'MemWrite' 
// signal is 1. 'ReadData' is the value of memory location Address[11:2] if 
// 'MemRead' is 1, otherwise, it is 0x00000000. The reading of memory is not 
// clocked.
//
// you need to declare a 2d array. in this case we need an array of 1024 (1K)  
// 32-bit elements for the memory.   
// for example,  to declare an array of 256 32-bit elements, declaration is: reg[31:0] memory[0:255]
// if i continue with the same declaration, we need 8 bits to index to one of 256 elements. 
// however , address port for the data memory is 32 bits. from those 32 bits, least significant 2 
// bits help us index to one of the 4 bytes within a single word. therefore we only need bits [9-2] 
// of the "Address" input to index any of the 256 words. 
////////////////////////////////////////////////////////////////////////////////

module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData); 

    input [31:0] Address; 	// Input Address 
    input [31:0] WriteData; // Data that needs to be written into the address 
    input Clk;
    input MemWrite; 		// Control signal for memory write 
    input MemRead; 			// Control signal for memory read 

    output reg[31:0] ReadData; // Contents of memory location at Address

    /* Please fill in the implementation here */
//declaration of Memory    
    reg[31:0] Memory[0:1023];
    
    //initializing
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            Memory[i] = 32'b0;
        end
    end
    
    wire [1:0] byte_off = Address[1:0];
    wire [9:0] word_address = Address[11:2];
//Writing to memory    
   always @(posedge Clk) begin
    if (MemWrite) begin
        case (byte_off)
            2'b00: begin // store the entire word
                Memory[word_address] <= WriteData;
            end

            2'b01: begin // store half word
                case (Address[1]) // select lower or upper half
                    1'b0: Memory[word_address][15:0]  <= WriteData[15:0];
                    1'b1: Memory[word_address][31:16] <= WriteData[15:0];
                    default: ; // do nothing
                endcase
            end

            2'b10: begin // store byte
                case (Address[1:0]) // 2-bit offset within the word
                    2'b00: Memory[word_address][7:0]   <= WriteData[7:0];
                    2'b01: Memory[word_address][15:8]  <= WriteData[7:0];
                    2'b10: Memory[word_address][23:16] <= WriteData[7:0];
                    2'b11: Memory[word_address][31:24] <= WriteData[7:0];
                    default: ; // do nothing
                endcase
            end

            default: ; // in case MemSize is something invalid
        endcase
    end
end



//Reading from memory    
    always @(negedge Clk) begin
        if (MemRead) begin
            case (byte_off)
                2'b00: begin // Load Word (LW)
                    ReadData = Memory[word_address];
                end
    
                2'b01: begin // Load Halfword (LH)
                    case (Address[1])
                        1'b0: ReadData = {{16{Memory[word_address][15]}},  Memory[word_address][15:0]};   // sign-extend lower half
                        1'b1: ReadData = {{16{Memory[word_address][31]}},  Memory[word_address][31:16]};  // sign-extend upper half
                        default: ReadData = 32'b0;
                    endcase
                end
    
                2'b10: begin // Load Byte (LB)
                    case (Address[1:0])
                        2'b00: ReadData = {{24{Memory[word_address][7]}},   Memory[word_address][7:0]};
                        2'b01: ReadData = {{24{Memory[word_address][15]}},  Memory[word_address][15:8]};
                        2'b10: ReadData = {{24{Memory[word_address][23]}},  Memory[word_address][23:16]};
                        2'b11: ReadData = {{24{Memory[word_address][31]}},  Memory[word_address][31:24]};
                        default: ReadData = 32'b0;
                    endcase
                end
    
                //default: ReadData = 32'b0; // fallback if MemSize invalid
            endcase
            
            //set everything to zero if nothing is being read
    end else begin
        ReadData = 32'b0;
    end
end
    
    
    

endmodule
