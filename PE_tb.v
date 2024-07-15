`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2024 23:56:03
// Design Name: 
// Module Name: adder_tb
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


module PE_tb;
reg clk;
reg reset;
reg [31:0]in_a;
reg [31:0]in_b;
wire [31:0]out_a;
wire [31:0]out_b;
wire [31:0]out_z;

PE DUT(.clk(clk),.reset(reset),.in_a(in_a),.in_b(in_b),.out_a(out_a),.out_b(out_b),.out_z(out_z));
    always #5 clk = ~clk;
    
    initial begin
    clk = 0;
    reset = 1;
    in_a = 32'h 00000000;
    in_b = 32'h 00000000;

    #5;
    reset=0;
    in_a = 32'b0_00000000_00000000000000000000000;
    in_b = 32'b0_00000000_00000000000000000000000;
    
    #5 
    in_a = 32'b0_10000000_01100000000000000000000;
    in_b = 32'b0_10000000_00000000000000000000000;
    
    #15 $finish;
end
endmodule
