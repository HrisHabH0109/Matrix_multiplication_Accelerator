`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2024 22:40:24
// Design Name: 
// Module Name: IEEE_Adder
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

module IEEE_754_Adder(input [31:0] num1,input [31:0] num2,output reg [31:0] result);
// Intermediate signals

wire result_sign;
wire [7:0] exponent_compare;
wire [7:0] exponent_max;
wire k;
wire [23:0] mantissa_1;
wire [23:0] mantissa_2;
wire [24:0] mantissa_sum;
wire [7:0] exponent_max_norm;
wire [22:0] result_mantissa;
wire final_sign;
wire [31:0] number_out;
wire [7:0] lead;
wire [23:0] num_lead;


assign result_sign=num1[31]^num2[31];

// Instantiate modules
IEEE_754_exponent_comp exponent_comp1(num1[30:23], num2[30:23], exponent_compare,k,exponent_max);
IEEE_754_mantissa_shifter mantissa_shifter1(num1[22:0], num2[22:0],k,exponent_compare, mantissa_1,mantissa_2);
IEEE_754_mantissa_adder mantissa_adder1(mantissa_1, mantissa_2,result_sign,k, mantissa_sum);
leading_zeros_finder leading(mantissa_sum[23:0],lead,num_lead);
IEEE_754_mantissa_normalizer_adder mantissa_normalizer1(mantissa_sum,exponent_max,result_sign,lead,num_lead,exponent_max_norm,result_mantissa);
IEEE_754_final_sign fin_sign(k,num1[31],num2[31],final_sign);
IEEE_754_result_format_adder result_format(final_sign, exponent_max_norm,result_mantissa,number_out);
// Output result
always @* begin
if((num1==32'h 00000000 || num1==32'h 80000000)&& (num2==32'h 00000000 || num2==32'h 80000000))begin
    result=32'h 00000000;
end
else if(num1==32'h 00000000 || num1==32'h 80000000) begin
    result=num2;
end
else if(num2==32'h 00000000 || num2==32'h 80000000) begin
    result=num1;
end
else begin
    result=number_out;
    end
end
endmodule

// Module for comparing exponents
module IEEE_754_exponent_comp (input [7:0] exponent1,input [7:0] exponent2,output reg [7:0] exponent_comp,output reg k,output reg [7:0] exponent_max);
    // Exponent addition
    always @* begin
    if(exponent1>=exponent2)begin
        k=0;
        exponent_comp=exponent1-exponent2;
        exponent_max=exponent1;
        end
    else begin
        k=1;
        exponent_comp=exponent2-exponent1;
        exponent_max=exponent2;
        end
    end
endmodule

// Module for shifting mantissas
module IEEE_754_mantissa_shifter(input [22:0] mantissa1,input [22:0] mantissa2,input k,input [7:0] exponent_comp,output reg [23:0] mantissa_out_1,output reg [23:0] mantissa_out_2);
    // Mantissa multiplication
    always @* begin
        if(k==1'b0)begin
            mantissa_out_2=({1'b1,mantissa2})>>exponent_comp;
            mantissa_out_1={1'b1,mantissa1};
            end
        else begin
            mantissa_out_1=({1'b1,mantissa1})>>exponent_comp;
            mantissa_out_2={1'b1,mantissa2};
            end
    end
endmodule


// Module for adding mantissa
module IEEE_754_mantissa_adder(input [23:0] mantissa1,input [23:0] mantissa2,input result_sign,input k,output reg [24:0] mantissa_sum);
    // Mantissa adding2
    always @* begin
        if (result_sign==1'b0)begin
            mantissa_sum={1'b0,mantissa1}+{1'b0,mantissa2};
            end
        else begin
            if(k==1'b0)begin
                mantissa_sum={1'b0,mantissa1}-{1'b0,mantissa2};
                end
             else begin
                mantissa_sum={1'b0,mantissa2}-{1'b0,mantissa1};
                end
            end
    end
endmodule

module leading_zeros_finder(input [23:0] num,output reg [7:0] leading_zeros,output reg [23:0] num2);
integer i; // Move the declaration outside the always block
reg x;
always @(*) begin
    x=1'b0;
    leading_zeros =8'b00000000;
    for (i = 23; i >=0; i = i - 1) begin
        x=num[i]|x;
        if (x==1'b0) begin
        leading_zeros = leading_zeros + 8'b00000001;
        end 
    end
    num2=num<<leading_zeros;
end
endmodule

module IEEE_754_mantissa_normalizer_adder(input [24:0] mantissa_sum,input [7:0] exponent_max,input result_sign,input [4:0] lead,input [23:0] num_lead,output reg [7:0] exponent_max_norm,output reg [22:0] result_mantissa);

   
    always @* begin
        if(result_sign==1'b0)begin
            if(mantissa_sum[24]==1'b1)begin
                exponent_max_norm=exponent_max+1;
                result_mantissa= mantissa_sum[23:1];
                end
            else begin
                exponent_max_norm=exponent_max;
                result_mantissa=mantissa_sum[22:0];
                end
            end
        else begin
                exponent_max_norm=exponent_max-{3'b000,lead};
                result_mantissa=num_lead[22:0];
            end
        end
endmodule



module IEEE_754_final_sign(input k,input num1,input num2,output reg sign);
    always @* begin
        if(k==0)begin
        sign=num1;
        end
        else begin
        sign=num2;
        end
        end
endmodule

// Module for formatting result
module IEEE_754_result_format_adder(input sign_extended,input [7:0] exponent_sum_norm,input [22:0] mantissa_normalized,output reg [31:0] result);
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
