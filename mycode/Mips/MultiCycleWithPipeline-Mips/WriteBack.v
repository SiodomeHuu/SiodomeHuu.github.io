`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:34:43 05/29/2017 
// Design Name: 
// Module Name:    WriteBack 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module WriteBack(
	input clk,
	input rst_n,
	input ipvalid,
	input [4:0] regaddr3,
	input [31:0] regdata,
	input [5:0] optype,
	
	output reg to_valid,
	output reg [4:0] to_regaddr3,
	output [31:0] to_regdata,
	
	output reg [31:0] delay_regdata,
	
	output reg reg_we
	
);
//although one clock is needed while writing to reg
//data must be available before posedge
//so this module should be logical

//assign to_regaddr3=regaddr3;
assign to_regdata=regdata;

assign local_reg_we = ( optype==6'h0 || optype==6'h1 || optype==6'h2 || optype==6'h4
	|| optype==6'h5 || optype==6'h6 || optype==6'h13) ? 1 : 0;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		delay_regdata<=32'hCCCC_CCCC;
	else
		delay_regdata<=regdata;
end

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		to_valid<=0;
	else
		to_valid<=ipvalid;
end

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		reg_we<=0;
	else
		reg_we<=local_reg_we;
end


always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		to_regaddr3<=5'h0;
	else
		to_regaddr3<=regaddr3;
end

endmodule
