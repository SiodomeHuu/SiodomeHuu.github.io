`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:29:36 04/17/2017 
// Design Name: 
// Module Name:    pc 
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
module pc(
	input clk,
	input rst_n,
	input muxer,
	input [31:0] addr,
	output [31:0] now_addr
);

assign now_addr=nowaddr;

reg [31:0] nowaddr;
reg [31:0] nextaddr;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		nowaddr<=32'hFFFF_FFFB;
	end
	else
	begin
		if(nextaddr==32'hFFFF_FFFF)
			nowaddr<=0;
		else
			nowaddr<= ( muxer ? addr : nextaddr);
	end
end



always@(*)
begin
	nextaddr=nowaddr+32'h4;
end


endmodule
