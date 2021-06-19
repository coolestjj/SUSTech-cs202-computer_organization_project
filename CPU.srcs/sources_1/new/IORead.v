`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 21:38:49
// Design Name: 
// Module Name: IORead
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


module IORead(
    input rst,
    input IORead,
    input SwitchCtrl,
    input [15:0] switch_data,
    output reg [15:0] data
    );
    
    always @* begin
        if (rst == 1) begin
            data = 16'h0000;
        end
        else if (IORead == 1) begin
            if (SwitchCtrl == 1) begin
                data = switch_data;
            end
            else begin
                data = data;
            end
        end
    end
endmodule
