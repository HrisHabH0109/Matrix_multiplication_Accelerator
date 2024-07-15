`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2024 12:43:06
// Design Name: 
// Module Name: IEEE_veriliog
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


module IEEE_754_multiplication(input [31:0] num1,input [31:0] num2,output reg [31:0] result);
// Intermediate signals

wire result_sign;
wire [7:0] exponent_sum;
wire [7:0] exponent_sum_norm;
wire [47:0] mantissa_product;
wire [22:0] product_shifted;
wire [31:0] result_mantissa;

assign result_sign=num1[31]^num2[31];

// Instantiate modules
IEEE_754_exponent_adder exponent_adder(num1[30:23], num2[30:23], exponent_sum);
IEEE_754_mantissa_multiplier mantissa_multiplier(num1[22:0], num2[22:0], mantissa_product);
IEEE_754_mantissa_normalizer mantissa_normalizer(mantissa_product,exponent_sum,exponent_sum_norm,product_shifted);
IEEE_754_result_format result_format(result_sign, exponent_sum_norm, product_shifted, result_mantissa);
// Output result
always @* begin
if(num1==32'h 00000000 || num1==32'h 80000000 || num2==32'h 00000000 || num2==32'h 80000000)begin
    result=32'h 00000000;
end
else begin
    result=result_mantissa;
    end
end

endmodule

// Module for adding exponents
module IEEE_754_exponent_adder(input [7:0] exponent1,input [7:0] exponent2,output reg [7:0] exponent_sum);
    // Exponent addition
    always @* begin
        exponent_sum= exponent1 + exponent2 - 127; // Subtract bias
    end
endmodule

// Module for multiplying mantissas
module IEEE_754_mantissa_multiplier(input [22:0] mantissa1,input [22:0] mantissa2,output reg [47:0] mantissa_product);
    // Mantissa multiplication
    always @* begin
        mantissa_product = {1'b1,mantissa1} * {1'b1,mantissa2}; // Multiply mantissas and extend to 48 bits
    end
endmodule


// Module for normalizing mantissa
module IEEE_754_mantissa_normalizer(input [47:0] mantissa_product,input [7:0] exponent_sum,output reg [7:0] exponent_sum_norm,output reg [22:0] mantissa_normalized);
    // Mantissa normalization
    always @* begin
        if (mantissa_product[47] == 1'b1)begin
            mantissa_normalized= mantissa_product[46:24];//alloting req
            exponent_sum_norm=exponent_sum+1;
            end
        else begin
            mantissa_normalized = mantissa_product[45:23]; // No normalization needed
            exponent_sum_norm=exponent_sum;
            end
    end
endmodule


// Module for formatting result
module IEEE_754_result_format(input sign_extended,input [7:0] exponent_sum_norm,input [22:0] mantissa_normalized,output reg [31:0] result);
    // Result formatting
    always @* begin
        if (exponent_sum_norm >= 255)
            result = {sign_extended, 8'b11111111, 23'b0}; // Overflow: Set result to infinity
        else if (exponent_sum_norm <= 105)
            result = {sign_extended, 8'b00000000, 23'b0}; // Underflow: Set result to zero
        else
            result = {sign_extended, exponent_sum_norm, mantissa_normalized}; // Normal case
    end
endmodule
