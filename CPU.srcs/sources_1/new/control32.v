`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/04 14:36:24
// Design Name: 
// Module Name: control32
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


module control32(
    input[5:0] Opcode,          // instruction[31..26]
    input[5:0] Function_opcode, // instructions[5..0]
    input[21:0] Alu_resultHigh, // From the execution unit Alu_Result[31...10]
    output Jr,                  // 1 indicates the instruction is "jr", otherwise it's not "jr"
    output RegDST,              // 1 indicate destination register is "rd",otherwise it's "rt" output MemtoReg
    output ALUSrc,              // 1 indicate the 2nd data is immidiate (except "beq","bne")
    //output MemtoReg,          // 1 indicate read data from memory and write it
    output MemorIOtoReg,        // 1 indicates that data needs to be read from memory or I/O to the register
    output RegWrite,            // 1 indicate write register, otherwise it's not
    output MemRead,             // 1 indicates that the instruction needs to read from the memory
    output MemWrite,            // 1 indicate write data memory, otherwise it's not
    output IORead,              // 1 indicates I/O read
    output IOWrite,             // 1 indicates I/O write
    output Branch,              // 1 indicate the instruction is "beq" , otherwise it's not
    output nBranch,             // 1 indicate the instruction is "bne", otherwise it's not
    output Jmp,                 // 1 indicate the instruction is "j", otherwise it's not
    output Jal,                 // 1 indicate the instruction is "jal", otherwise it's not
    output I_format,            // 1 indicate the instruction is I-type but isn't “beq","bne","LW" or "SW" output Sftmd; // 1 indicate the instruction is shift instruction
    output Sftmd,               // 1 indicate the instruction is shift instruction
    output[1:0] ALUOp
    // if the instruction is R-type or I_format, ALUOp is 2'b10; if the instruction is“beq” or “bne“, ALUOp is 2'b01
    // if the instruction is“lw” or “sw“, ALUOp is 2'b00；
    );
    wire R_format;
    wire Lw;
    wire Sw;

    //“RegDST” is used to determine the destination in the register file which is determined by rd(1) or rt(0).
    assign R_format = (Opcode==6'b000000) ? 1'b1 : 1'b0;
    assign RegDST = R_format && (~I_format) && (~Lw);

    //“I_format” is used to identify if the instruction is I_type(except for beq, bne, lw and sw). e.g. addi, subi, ori, andi...
    assign I_format = (Opcode[5:3]==3'b001) ? 1'b1 : 1'b0;

    assign Lw = (Opcode==6'b100011) ? 1'b1 : 1'b0;
    assign Sw = (Opcode==6'b101011) ? 1'b1 : 1'b0;

    //“Jr” is used to identify whether the instruction is jr or not.
    assign Jr = ((Function_opcode==6'b001000)&&(Opcode==6'b000000)) ? 1'b1 : 1'b00;
    assign Jal = (Opcode==6'b000011) ? 1'b1 : 1'b0;
    assign Jmp = (Opcode==6'b000010) ? 1'b1 : 1'b0;

    assign Branch =  (Opcode==6'b000100) ? 1'b1:1'b0;
    assign nBranch =  (Opcode==6'b000101) ? 1'b1:1'b0;

    //assign MemWrite = (Sw==1'b1) ? 1'b1 : 1'b0;
    //assign MemtoReg = (Lw==1'b1) ? 1'b1 : 1'b0;
    assign ALUSrc = (I_format || Lw || Sw);
    
    //“RegWrite” is used to determine whether to write registe(1) or not(0).
    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr); // Write memory or write IO
    
    //“ALUOp” is used to code the type of instructions described in the table on the left hand.
    assign ALUOp = {(R_format || I_format),(Branch || nBranch)};
    
    //“Sftmd ” is used to identify whether the instruction is shift or not.
    assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)
                ||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)
                ||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))
                && R_format) ? 1'b1 : 1'b0;

    assign MemWrite = (Sw == 1'b1 && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1 : 1'b0;   // Write memory
    assign MemRead = (Lw == 1'b1 && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1 : 1'b0;    // Read memory
    assign IORead = (Lw == 1'b1 && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1 : 1'b0;     // Read input port
    assign IOWrite = (Sw == 1'b1 && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1: 1'b0;     // Write output port
    
    // Read operations require reading data from memory or I/O to write to the register
    assign MemorIOtoReg = IORead || MemRead;

endmodule
