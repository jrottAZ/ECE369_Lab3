`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 02:12:06 PM
// Design Name: 
// Module Name: controller
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


module controller(opcode, func, rtField, RegWrite, RegDst, ALUSrc, ALUOp, Branch, MemWrite, MemRead, MemToReg, jump, branchType, JorJR, Jal);
    input [5:0] opcode;
    input [5:0] func;
    input [4:0] rtField;
    output reg RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemRead, MemToReg, jump, branchType, JorJR, Jal;
    output reg [3:0] ALUOp;
    parameter rType = 6'b000000, addi = 6'b001000, slti = 6'b001010, lw = 6'b100011, mul = 6'b011100;
    parameter sw = 6'b101011, lh = 6'b100001, sh = 6'b101001, lb = 6'b100000, sb = 6'b101000;
    parameter andi = 6'b001100, ori = 6'b001101, xori = 6'b001110, beq = 6'b000100, bne = 6'b000101;
    parameter bg = 6'b000001, bgtz = 6'b000111, blez = 6'b000110, j = 6'b000010, jal = 6'b000011;
     
    
    always @(*) begin
        RegWrite   <= 0;
        RegDst   <= 0;
        ALUSrc <= 0;
        ALUOp    <= 4'b0000;
        Branch <= 0;
        MemWrite  <= 0;
        MemRead <= 0;
        MemToReg   <= 0;
        jump <= 0;
        branchType <= 0;
        JorJR <= 0;
        Jal <= 0;
        
        
        case(opcode)
    
            rType: begin
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 1;
                ALUSrc <= 0;
                Branch <= 0;
                RegDst <= 1;
                case(func)
                
                    //ADD
                    6'b100000: begin
                        ALUOp <= 4'b0010;
                        RegWrite <= 1;
                    end
                    
                    //SUB
                    6'b100010: begin
                        ALUOp <= 4'b0011;
                        RegWrite <= 1;
                    end
                    
                    //SLT
                    6'b101010: begin
                        ALUOp <= 4'b0100;
                        RegWrite <= 1;
                    end
                    
                    //AND
                    6'b100100: begin
                        ALUOp <= 4'b0000;
                        RegWrite <= 1;
                    end
                    
                    //OR
                    6'b100101: begin
                        ALUOp <= 4'b0001;
                        RegWrite <= 1;
                    end
                    
                    //NOR
                    6'b100111: begin
                        ALUOp <= 4'b0101;
                        RegWrite <= 1;
                    end
                    
                    //XOR
                    6'b100110: begin
                        ALUOp <= 4'b1010;
                        RegWrite <= 1;
                    end
                    
                    //SRL
                    6'b000010: begin
                        ALUOp <= 4'b1001;
                        RegWrite <= 1;
                    end
                    
                    //SLL
                    6'b000000: begin
                        ALUOp <= 4'b1000;
                        RegWrite <= 1;
                    end
                    
                    //JR
                    6'b001000: begin
                        RegWrite <= 0;
                        jump <= 1;
                        JorJR <= 1;
                    end
                
                endcase
            end
            
            mul: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 1;
                ALUSrc <= 0;
                Branch <= 0;
                RegDst <= 1;
                ALUOp <= 4'b1111;
            end
            
            addi: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 1;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 4'b0010;
                RegDst <= 0;
            end
            
            slti: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 1;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 4'b0100;
                RegDst <= 0;
            end
            
            lw: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 1;
                MemToReg <= 0;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 4'b0010;
                RegDst <= 0;
            end
            
            sw: begin
                RegWrite <= 0;
                MemWrite <= 1;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 4'b0010;
                RegDst <= 0;
            end

            lh: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 1;
                MemToReg <= 0;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 2'b00;
                RegDst <= 0;
            end
            
            sh: begin
                RegWrite <= 0;
                MemWrite <= 1;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 2'b00;
                RegDst <= 0;
            end
            
            lb: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 1;
                MemToReg <= 0;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 2'b00;
                RegDst <= 0;
            end
            
            sb: begin
                RegWrite <= 0;
                MemWrite <= 1;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 2'b00;
                RegDst <= 0;
            end
        
           andi: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 1;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 4'b0000;
                RegDst <= 0;
            end
            
            ori: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 1;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 4'b0001;
                RegDst <= 0;
            end
            
            xori: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 1;
                ALUSrc <= 1;
                Branch <= 0;
                ALUOp <= 4'b1010;
                RegDst <= 0;
            end
            
             beq: begin
                RegWrite <= 0;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 0;
                Branch <= 1;
                ALUOp <= 4'b0011;
                RegDst <= 0;
            end
            
            bne: begin
                RegWrite <= 0;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 0;
                Branch <= 1;
                ALUOp <= 4'b0011;
                RegDst <= 0;
                branchType <= 1;
            end
            
            bg: begin
                RegWrite <= 0;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 0;
                Branch <= 1;
                RegDst <= 0;
                
                case(rtField)
                
                    //BGEZ
                    5'b00001: begin
                        ALUOp <= 4'b1100; 
                    end
                    
                    //BLTZ
                    5'b00000: begin
                        ALUOp <= 4'b1011;
                    end
                
                endcase
            end
            
            bgtz: begin
                RegWrite <= 0;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 0;
                Branch <= 1;
                ALUOp <= 4'b1110;
                RegDst <= 0;
            end
            
            blez: begin
                RegWrite <= 0;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 0;
                Branch <= 1;
                ALUOp <= 4'b1101;
                RegDst <= 0;
            end
            
            j: begin
                RegWrite <= 0;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 0;
                Branch <= 0;
                ALUOp <= 4'b0110;
                RegDst <= 0;
                jump <= 1;
            end
            
            jal: begin
                RegWrite <= 1;
                MemWrite <= 0;
                MemRead <= 0;
                MemToReg <= 0;
                ALUSrc <= 0;
                Branch <= 0;
                ALUOp <= 4'b0110;
                RegDst <= 0;
                jump <= 1;
                Jal <= 1;
            end
            
            
            

        endcase
    end

endmodule
