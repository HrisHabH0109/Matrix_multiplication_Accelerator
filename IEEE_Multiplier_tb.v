`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2024 16:28:38
// Design Name: 
// Module Name: IEEE_Multiplication_tb
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


module IEEE_754_multiplication_tb;
    // Signals
    reg [31:0] num1, num2;
    wire [31:0] result;
    // Instantiate DUT
    IEEE_754_multiplication dut (.num1(num1),.num2(num2),.result(result));

    // Stimulus generation
    initial begin
        $monitor($time,"num1=%b,num2=%b,result=%b",num1,num2,result);
        // Test Case 1: Positive numbers
        num1 = 32'b00000011111110000000000000000000; 
        num2 = 32'b00000011111110000000000000000000; 
        
        #10;
        // Test Case 2: Negative numbers
        num1 = 32'h3f000000;  // -2.75
        num2 = 32'h3f000000;  // 2
        #10;
        // Test Case 3: Zero
        num1 = 32'b00000000000000000000000000000000; 
        num2 = 32'b01111111101000000000000000000000;  
        #10;
        // Test Case 4: Large numbers
        num1 = 32'b00111111111111111111111111111111;
        num2 = 32'b00111111111111111111111111111111; 
        #10;
        // Test Case 5: Underflow
        num1 = 32'b00000000000000000000000000000001; 
        num2 = 32'b00000000000000000000000000000001; 
        #10;
        // Test Case 6: Overflow
        num1 = 32'b01111111100000000000000000000000; 
        num2 = 32'b00111111101000000000000000000000; 
        #10 $finish;
        end
endmodule
