`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:55:49 05/25/2017 
// Design Name: 
// Module Name:    IMemModule 
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
module IMemModule(
	input clk,
	input rst_n,
	input [31:0] addr,

	output reg [31:0] pc,
	output [31:0] ir
);

IMem u_IMem(
	clk,
	addr[8:2],
	ir
);

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		pc<=32'h0;
	else
		pc<=addr;
end

endmodule
