`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 11:11:08
// Design Name: 
// Module Name: Ifetc32
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


module Ifetc32(Instruction,branch_base_addr,Addr_result,Read_data_1,
                Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr,pco);
    output[31:0] Instruction;       // the instruction fetched from this module
    output[31:0] branch_base_addr;  // (pc+4) to ALU which is used by branch type instruction
    output[31:0] link_addr;         // (pc+4) to decoder which is used by jal instruction
    input clock,reset;              // Clock and reset
    // from ALU
    input[31:0] Addr_result;        // the calculated address from ALU
    input Zero;                     // while Zero is 1, it means the ALUresult is zero
    // from Decoder
    input[31:0] Read_data_1;        // the address of instruction used by jr instruction
    // from controller
    input Branch;                   // while Branch is 1,it means current instruction is beq
    input nBranch;                  // while nBranch is 1,it means current instruction is bnq
    input Jmp;                      // while Jmp 1,it means current instruction is jump
    input Jal;                      // while Jal is 1,it means current instruction is jal
    input Jr;                       // while Jr is 1,it means current instruction is jr
    output pco;

    prgrom instmem(
        .clka(clock),               // input wire clka
        .addra(PC[15:2]),           // input wire [13:0] addra
        .douta(Instruction)         // output wire [31:0] douta
    );

    wire[31:0] PC_plus_4;
    wire[31:0] branch_base_addr;
    reg[31:0] PC, Next_PC;
    reg[31:0] link_addr;

    assign PC_plus_4[31:2] = PC[31:2] + 1'b1;
    assign PC_plus_4[1:0] = PC[1:0];
    assign branch_base_addr = PC_plus_4;
    assign pco = PC;

    always @* begin
        if (((Branch == 1) && (Zero == 1)) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = Addr_result;              // the calculated new value for PC
        
        else if (Jr == 1)
            Next_PC = Read_data_1;              // the value of $31 register
        
        else Next_PC = PC_plus_4[31:2];         // PC+4
    end

    always @(negedge clock) begin
        if (reset == 1)
            PC <= 32'h0000_0000;
        else begin
            if((Jmp == 1) || (Jal == 1)) begin
                PC <= {PC[31:28], Instruction[27:0] << 2};
            end
            else begin
                PC <= Next_PC << 2;
            end
        end
    end

    always @(posedge Jal) begin
        link_addr <= (PC_plus_4 >> 2);
    end
endmodule
