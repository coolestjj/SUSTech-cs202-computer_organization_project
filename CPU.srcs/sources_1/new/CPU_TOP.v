`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 11:29:50
// Design Name: 
// Module Name: CPU_TOP
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


module CPU_TOP(
    reset,
    clk,
    switch2N4,
    led2N4,
    seg_location,
    seg_digit
    );

    input reset;
    input clk;
    input[23:0] switch2N4;
    output[23:0] led2N4;
    output [7:0] seg_location;
    output [7:0] seg_digit;

    wire clock;
    wire hz;

    // Ifetch
    wire [31:0] Instruction;
    wire Zero;
    wire [31:0] Read_data_1;
    wire Branch,nBranch,Jmp,Jal,Jr,pco;
    // Executs
    wire [31:0] Read_data_2;
    wire [31:0] Imme_extend;
    wire [31:0] PC_plus_4; // (pc + 4) to alu
    wire [1:0] ALUOp;
    wire ALUSrc,I_format,Sftmd;
    wire [31:0] ALU_Result;
    wire [21:0] Alu_resultHigh;
    wire [31:0] Addr_Result;
    // controller
    wire RegDst,MemorIOtoReg,RegWrite,MemRead,MemWrite,IORead,IOWrite;
    // seg
    wire [7:0] seg_location;
    wire [7:0] seg_digit;
    // switchs
    wire SwitchCtrl;
    // IORead
    wire [15:0] ioread_data;
    // led
    wire LEDCtrl;
    //
    wire [31:0] write_data;
    wire [31:0] address;
    wire [31:0] opcplus4; // (pc + 4) to decoder
    wire [31:0] read_data_fromMemory;
    wire [31:0] read_data;

    cpuclk cpuclk(.clk_in1(clk), .clk_out1(clock));

    Ifetc32 Ifetch(.Instruction(Instruction),
                .branch_base_addr(PC_plus_4),   // (pc + 4) to alu
                .Addr_result(Addr_Result),
                .Read_data_1(Read_data_1),
                .Branch(Branch),
                .nBranch(nBranch),
                .Jmp(Jmp),
                .Jal(Jal),
                .Jr(Jr),
                .Zero(Zero),
                .clock(clock),
                .reset(reset),
                .link_addr(opcplus4),   // (pc + 4) to decoder
                .pco(pco));

    Idecode32 Idecode(.Read_data_1(Read_data_1),
                    .Read_data_2(Read_data_2),
                    .Instruction(Instruction),
                    .read_data(read_data),
                    .ALU_result(ALU_Result),
                    .Jal(Jal),
                    .RegWrite(RegWrite),
                    .MemorIOtoReg(MemorIOtoReg),
                    .RegDst(RegDst),
                    .Imme_extend(Imme_extend),
                    .clock(clock),
                    .reset(reset),
                    .opcplus4(opcplus4));

    control32 controller(.Opcode(Instruction[31:26]),
                    .Function_opcode(Instruction[5:0]),
                    .Alu_resultHigh(Alu_resultHigh),
                    .Jr(Jr),
                    .RegDST(RegDst),
                    .ALUSrc(ALUSrc),
                    .MemorIOtoReg(MemorIOtoReg),
                    .RegWrite(RegWrite),
                    .MemRead(MemRead),
                    .MemWrite(MemWrite),
                    .IORead(IORead),
                    .IOWrite(IOWrite),
                    .Branch(Branch),
                    .nBranch(nBranch),
                    .Jmp(Jmp),
                    .Jal(Jal),
                    .I_format(I_format),
                    .Sftmd(Sftmd),
                    .ALUOp(ALUOp));

    Executs32 execute(.Read_data_1(Read_data_1),
                    .Read_data_2(Read_data_2),
                    .Imme_extend(Imme_extend),
                    .Function_opcode(Instruction[5:0]),
                    .opcode(Instruction[31:26]),
                    .ALUOp(ALUOp),
                    .Shamt(Instruction[10:6]),
                    .ALUSrc(ALUSrc),
                    .I_format(I_format),
                    .Zero(Zero),
                    .Sftmd(Sftmd),
                    .ALU_Result(ALU_Result),
                    .Alu_resultHigh(Alu_resultHigh),
                    .Addr_Result(Addr_Result),
                    .PC_plus_4(PC_plus_4),
                    .Jr(Jr));
    
    dmemory32 memory(.read_data(read_data_fromMemory),
                    .address(address),
                    .write_data(write_data),
                    .MemWrite(MemWrite),
                    .clock(clock));

    MemOrIO memorio(.mRead(MemRead),
                .mWrite(MemWrite),
                .ioRead(IORead),
                .ioWrite(IOWrite),
                .addr_in(ALU_Result),
                .addr_out(address), 
                .m_rdata(read_data_fromMemory),
                .io_rdata(ioread_data),
                .r_wdata(read_data),  // to decoder
                .r_rdata(Read_data_2),
                .write_data(write_data),
                .LEDCtrl(LEDCtrl),
                .SwitchCtrl(SwitchCtrl));

    switchs switch(.switclk(clock),
                .switrst(reset),
                .switchread(IORead),
                .switchcs(SwitchCtrl),
                .switchaddr(address[1:0]),
                .switchrdata(ioread_data),
                .switch_i(switch2N4));

    leds led(.led_clk(clock),
            .ledrst(reset),
            .ledwrite(IOWrite),
            .ledcs(LEDCtrl),
            .ledaddr(address[1:0]),
            .ledwdata(write_data[15:0]),
            .ledout(led2N4));

    hz uhz(.clk(clock),
        .rst(reset),
        .hz(hz));

    seg seg(.clk(clock),
        .rst(reset),
        .segcs(LEDCtrl),
        .segwrite(IOWrite),
        .hz(hz),
        .ledaddr(address[1:0]),
        .write_data(write_data),
        .seg_location(seg_location),
        .seg_digit(seg_digit));

endmodule
