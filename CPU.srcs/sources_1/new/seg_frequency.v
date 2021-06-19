`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 21:17:02
// Design Name: 
// Module Name: seg_frequency
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


module seg_frequency(
    input clk,
    input rst,
    output hz
    );

    reg signal;
    reg [31:0] count;
    
    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            count <= 32'h0000;
            signal <= 1'b0;
        end
        else if (count == 32'd100000) begin
            count <= 32'h0000;
            signal = ~signal;
        end
        else begin
            count <= count + 1;
        end
    end

    assign hz = signal;

endmodule
