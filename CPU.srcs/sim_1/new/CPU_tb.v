`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 23:40:40
// Design Name: 
// Module Name: CPU_tb
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


module CPU_tb( );

    reg clock = 0;
    reg reset = 0;
    wire[23:0] leds;
    reg[23:0] switches = 24'h000000;
    
    CPU_TOP u(.reset(reset), .clk(clock), .switch2N4(switches), .led2N4(leds));
    initial begin
        #25 reset = 1;
        #100 reset = 0;
//TEST1
        #100 switches = ~24'h000000;

        #100 switches = ~24'h100000;

        #100 switches = ~24'h200055;

        #100 switches = ~24'h300000;

        #100 switches = ~24'h400000;

        #100 switches = ~24'h500000;

        #100 switches = ~24'h600000;

        #100 switches = ~24'h700000;
//TEST2
        #100 switches = ~24'h801101;
        #100 switches = ~24'h900000;

        #100 switches = ~24'h801101;
        #100 switches = ~24'hA00000;

        #100 switches = ~24'h801101;
        #100 switches = ~24'hB00000;

        #100 switches = ~24'h801101;
        #100 switches = ~24'hC00000;

        #100 switches = ~24'h801101;
        #100 switches = ~24'hD00000;

        #100 switches = ~24'h801101;
        #100 switches = ~24'hE00000;

        #100 switches = ~24'h801101;
        #100 switches = ~24'hF00000;
    end
    always #1 clock=~clock;
        
endmodule