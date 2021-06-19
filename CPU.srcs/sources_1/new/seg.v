`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 20:25:24
// Design Name: 
// Module Name: seg
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


module seg(
    input clk,
    input rst,
    input segcs,
    input segwrite,
    input hz,
    input[1:0] ledaddr,
    input [31:0] write_data,
    output reg [7:0] seg_location,
    output reg [7:0] seg_digit
    );

    reg [63:0] data;
    reg [3:0] count;
    wire [7:0] digit_0;
    wire [7:0] digit_1;
    wire [7:0] digit_2;
    wire [7:0] digit_3;
    wire [7:0] digit_4;
    wire [7:0] digit_5;
    wire [7:0] digit_6;
    wire [7:0] digit_7;

    seg_tube one (clk, write_data[3:0], digit_0);
    seg_tube two (clk, write_data[7:4], digit_1);
    seg_tube thr (clk, write_data[11:8], digit_2);
    seg_tube fou (clk, write_data[15:12], digit_3);
    seg_tube fiv (clk, write_data[19:16], digit_4);
    seg_tube six (clk, write_data[23:20], digit_5);
    seg_tube sev (clk, write_data[27:24], digit_6);
    seg_tube eig (clk, write_data[31:28], digit_7);

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            data <= 64'b11000000_11000000_11000000_11000000_11000000_11000000_11000000_11000000;
        end
        else if (segcs && segwrite) begin
	if(ledaddr == 2'b00)
            		data <= {data[63:32], digit_3, digit_2, digit_1, digit_0};
	else if(ledaddr == 2'b10)
		data <= {digit_3, digit_2, digit_1, digit_0, data[31:0]};
	else
		data <= data;
        end
        else begin
            data <= data;
        end
    end
    
    always @ (posedge hz, posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
            seg_location <= 8'b00000000;
        end
        else begin
            count <= count + 1;
    
            case(count)
            4'b0000: begin
                seg_location <= 8'b11111110;
                seg_digit <= data[7:0];
            end
            4'b0001: begin
                seg_location <= 8'b11111101;
                seg_digit <= data[15:8];
            end
            4'b0010: begin
                seg_location <= 8'b11111011;
                seg_digit <= data[23:16];
            end
            4'b0011: begin
                seg_location <= 8'b11110111;
                seg_digit <= data[31:24];
            end
            4'b0100: begin
                seg_location <= 8'b11101111;
                seg_digit <= data[39:32];
            end
            4'b0101: begin
                seg_location <= 8'b11011111;
                seg_digit <= data[47:40];
            end
            4'b0110: begin
                seg_location <= 8'b10111111;
                seg_digit <= data[55:48];
            end
            4'b0111: begin
                seg_location <= 8'b01111111;
                seg_digit <= data[63:56];
            end
            default:count<=4'b0000;

            endcase
        end
    end

endmodule
