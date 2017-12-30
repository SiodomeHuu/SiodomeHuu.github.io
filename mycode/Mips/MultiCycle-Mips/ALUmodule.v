`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:17:23 05/05/2017 
// Design Name: 
// Module Name:    ALUmodule 
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
module ALUmodule(
	input clk,
	input rst_n,
	
	input [31:0] rego1,
	input [31:0] PC,
	input ALUSrcA,
	
	input [31:0] rego2,
	input [15:0] imm,
	input [1:0] ALUSrcB,
	
	input [4:0] alu_op,
	
	input ALURegWe,
	output [31:0] alu_out,
	output reg [31:0] alu_lock_next,
	output flag

);

wire [31:0] alu_a;
assign alu_a= ALUSrcA ? rego1 : PC;

wire [31:0] SignExtend;
assign SignExtend[15:0]=imm;
assign SignExtend[31:16]= imm[15]==1 ? 16'hFFFF : 16'h0;


wire [31:0] alu_b;


assign alu_b= ALUSrcB==2'h0 ? rego2 : (
	ALUSrcB==2'h2 ? SignExtend : (
	ALUSrcB==2'h3 ? SignExtend << 2 : 32'h4
));


ALU u_ALU(
	alu_a,
	alu_b,
	alu_op,
	alu_out,
	flag
);


reg [31:0] alu_lock_now;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		alu_lock_now<=32'hCCCC_CCCC;
	end
	else
	begin
		alu_lock_now<=alu_lock_next;
	end
end

always@(*)
begin
	if(ALURegWe)
		alu_lock_next=alu_out;
	else
		alu_lock_next=alu_lock_now;
end
endmodule
