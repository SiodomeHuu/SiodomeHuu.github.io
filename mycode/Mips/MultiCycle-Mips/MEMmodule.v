`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:14:42 05/02/2017 
// Design Name: 
// Module Name:    MEMmodule 
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
module MEMmodule(
	input clk,
	input rst_n,
	
	input [31:0] pc,
	input [31:0] data_addr,
	input IorD,
	input [31:0] mem_wd,
	input WE,
	input IRWrite,
	output reg [31:0] now_Instr
);

wire [31:0] real_addr;
assign real_addr[31:30] = 2'b0;
assign real_addr[29:0] = IorD ? data_addr[31:2] :  pc[31:2];

wire [31:0] memout;

MEM u_MEM(
	clk,
	WE,
	real_addr,
	mem_wd,
	memout
);


//reg [31:0] now_Instr;
reg [31:0] next_Instr;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		now_Instr<=32'hCCCC_CCCC;
	end
	else
	begin
		now_Instr<=next_Instr;
	end
end

always@(*)
begin
	if(IRWrite)
		next_Instr=memout;
	else
		next_Instr=now_Instr;
end
endmodule
