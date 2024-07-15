`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2024 01:11:00
// Design Name: 
// Module Name: PE
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


module PE(input clk,input reset,input [31:0] in_a,input [31:0] in_b,output reg [31:0] out_a,output reg [31:0] out_b,output reg [31:0] out_c);
wire [31:0] product;
wire [31:0] answer;
wire [31:0] current_state;

D_FF D1(clk,reset,answer,current_state);
IEEE_754_multiplication multi1(in_a,in_b,product);
IEEE_754_Adder adder1(product,current_state,answer);
initial begin
out_a<=0;
out_b<=0;
out_c<=0;
end

always @(posedge clk) begin
        out_a<=in_a;
        out_b<=in_b;
        out_c<=answer;
    end
endmodule

module D_FF(input clk,input reset,input [31:0] answer,output reg [31:0] current_state);
    always @(posedge clk) begin
    if(reset) begin
    current_state<= 32'b0_00000000_00000000000000000000000;
    end
    else begin
    current_state<=answer;
    end
    end
endmodule
