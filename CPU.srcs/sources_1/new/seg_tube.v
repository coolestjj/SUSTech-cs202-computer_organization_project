`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 20:26:55
// Design Name: 
// Module Name: seg_tube
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


module seg_tube(
    input clk,
    input [3:0] data,
    output reg [7:0] digit
    );
    always @ (data) begin
        case (data)
            4'b0000: digit = 8'b11000000; //0
            4'b0001: digit = 8'b11111001; //1
            4'b0010: digit = 8'b10100100; //2
            4'b0011: digit = 8'b10110000; //3
            4'b0100: digit = 8'b10011001; //4
            4'b0101: digit = 8'b10010010; //5
            4'b0110: digit = 8'b10000010; //6
            4'b0111: digit = 8'b11111000; //7
            4'b1000: digit = 8'b10000000; //8
            4'b1001: digit = 8'b10010000; //9
            4'b1010: digit = 8'b10001000; //A
            4'b1011: digit = 8'b10000011; //b
            4'b1100: digit = 8'b10100111; //c
            4'b1101: digit = 8'b10100001; //d
            4'b1110: digit = 8'b10000110; //E
            4'b1111: digit = 8'b10001110; //F
            default: digit = 8'b11111111;
        endcase
    end
endmodule
