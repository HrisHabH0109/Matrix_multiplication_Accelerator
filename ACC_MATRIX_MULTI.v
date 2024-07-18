`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2024 11:34:07
// Design Name: 
// Module Name: ACC_MATRIX_MULTI
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
module ACC_MATRIX_MULTI #(parameter Sys_row=9, parameter Sys_column=9)
(
    input clk,
    input reset,
    input [Sys_row*32-1:0] data_arr,
    input [Sys_column*32-1:0] wt_arr,
    output reg [287:0] acc_result1,
    output reg [287:0] acc_result2,
    output reg [287:0] acc_result3,
    output reg [287:0] acc_result4,
    output reg [287:0] acc_result5,
    output reg [287:0] acc_result6,
    output reg [287:0] acc_result7,
    output reg [287:0] acc_result8,
    output reg [287:0] acc_result9
);

    wire [31:0] data_out[80:0];
    wire [31:0] wt_out[80:0];
    wire [31:0] acc_out[80:0];
    genvar p;
    generate for(p=0;p<81;p=p+1)begin
        if(p==0) begin
        PE acc(clk,reset,data_arr[287:256], wt_arr[287:256], data_out[p], wt_out[p],acc_out[p]);
        end
        else if(p<9)begin
        PE acc(clk,reset,data_arr[287-(p*32):256-(p*32)], wt_out[p-1], data_out[p], wt_out[p],acc_out[p]);
        end
        else if((p%9)==0)begin
        PE acc(clk,reset,data_out[p-9], wt_arr[287-((p/9)*32):256-((p/9)*32)], data_out[p], wt_out[p],acc_out[p]);
        end
        else begin
        PE acc(clk,reset,data_out[p-9], wt_out[p-1], data_out[p], wt_out[p],acc_out[p]);
        end
     end
     endgenerate
            
     integer i;
always @(posedge clk) begin
    acc_result1={acc_out[0]};acc_result2={acc_out[9]};acc_result3={acc_out[18]};
    acc_result4={acc_out[27]};acc_result5={acc_out[36]};acc_result6={acc_out[45]};
    acc_result7={acc_out[54]};acc_result8={acc_out[63]};acc_result9={acc_out[72]};
    for(i=1;i<9;i=i+1)begin
    acc_result1={acc_result1,acc_out[i]};acc_result2={acc_result2,acc_out[i+9]};acc_result3={acc_result3,acc_out[i+18]};
    acc_result4={acc_result4,acc_out[i+27]};acc_result5={acc_result5,acc_out[i+36]};acc_result6={acc_result6,acc_out[i+45]};
    acc_result7={acc_result7,acc_out[i+54]};acc_result8={acc_result8,acc_out[i+63]};acc_result9={acc_result9,acc_out[i+72]};
    end
    end
endmodule
