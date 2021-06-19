`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 20:13:41
// Design Name: 
// Module Name: hz
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


module hz(
    input clk,
    input rst,
    output hz
    );
    reg [0:0] signal;
    reg [31:0] n;
    
    always @(posedge clk, posedge rst) begin
    if (rst) begin
       n <= 32'h0000;
       signal <=1'b0;
    end
    else if (n==32'd500) begin
        n <= 32'h0000;
        signal = ~signal;
    end
    else
        n <= n + 1;
    end
        
    assign hz =signal;

endmodule
