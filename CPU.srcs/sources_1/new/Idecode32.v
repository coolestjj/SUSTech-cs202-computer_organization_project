`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/04 10:32:27
// Design Name: 
// Module Name: Idecode32
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


module Idecode32(
    output[31:0] Read_data_1,
    output[31:0] Read_data_2,
    input [31:0] Instruction,               // Instructions from the fetch unit
    input [31:0] read_data,  				// data from DATA RAM or I/O port
    input [31:0] ALU_result,   				// The result of the operation from the execution unit needs to be expanded to 32 bits
    input        Jal,                       // From control unit, description is JAL instruction
    input        RegWrite,                  // From control unit
    input        MemorIOtoReg,              // From control unit
    input        RegDst,                    // From control unit
    output[31:0] Imme_extend,               // The expanded 32-bit immediate output of the decoding unit
    input		 clock,
    input        reset,
    input [31:0] opcplus4                   // From fetch unit, used in JAL
);

    reg[31:0] register[0:31];               // 32 32-bit registers in the register group
    reg[4:0]  write_register_address;       // register to write
    reg[31:0] write_data;                   // data to write

    wire[4:0]  rs_address;                  // register to read first (rs)
    wire[4:0]  rt_address;                  // register to read second (rt), register to write (rt) I-form
    wire[4:0]  rd_address;                  // register to write (rd) R-form
    wire[15:0] immediate;                   // immediate value in the instruction
    wire[5:0]  opcode;
    
    assign opcode     = Instruction[31:26];
    assign rs_address = Instruction[25:21];       // rs 
    assign rt_address = Instruction[20:16];       // rt (R-form to read, I-form to write)
    assign rd_address = Instruction[15:11];       // rd (R-form)
    assign immediate  = Instruction[15:0];        // immediate value (I-form)

    wire sign;  // sign bit
    assign sign = Instruction[15];
    assign Imme_extend[31:0] = (opcode == 6'b001100 || opcode == 6'b001101)
                                ? { {16{1'b0} }, immediate} : // ZeroExtImm (ori, andi)
                                  { {16{sign} }, immediate};  // SignExtImm
    
    assign Read_data_1 = register[rs_address];
    assign Read_data_2 = register[rt_address];
    
    // This process specifies the target registers under different instructions
    always @* begin                                            
        if (RegWrite == 1) begin
            if (Jal == 1'b1) begin
                write_register_address = 5'b11111;
            end
            else if (RegDst == 1'b1) begin
                write_register_address = rd_address;
            end
            else begin
                write_register_address = rt_address;
            end
        end
    end
    
    // This process basically implements the multiplexer at the bottom right of 
    // the structure diagram to prepare the data to be written
    always @* begin 
        if (Jal == 1'b1) begin
            write_data = opcplus4;
        end                                 // Jal
        else if (MemorIOtoReg == 1'b0) begin
                write_data = ALU_result;
        end                                 // R instruction
        else begin
            write_data = read_data;
        end    
    end
    
    integer i;
    // write register
    always @(posedge clock) begin
        if (reset == 1) begin                // Initialize register group
            for (i = 0; i < 32; i = i + 1)
                register[i] <= 0;
        end 
        else if (RegWrite == 1) begin        // Register 0 always equals to 0
            register[write_register_address] <= write_data;    
        end
    end
endmodule
