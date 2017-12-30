`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:08 05/02/2017 
// Design Name: 
// Module Name:    PC 
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
module PC(
	input clk,
	input rst_n,
	
	input pcen,
	
	input [31:0] addr,
	input en,
	
	output [31:0] now_addr
);

assign now_addr=nextaddr;

reg [31:0] nowaddr;
reg [31:0] nextaddr;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		nowaddr<=32'hFFFF_FFFC;
	end
	else if(pcen)
	begin
		nowaddr<= nextaddr;
	end
	

end

always@(*)
begin
	if(en)
		nextaddr=addr;
	else
		nextaddr=nowaddr+32'h4;
end


endmodule
