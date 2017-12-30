`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:17:24 05/03/2017 
// Design Name: 
// Module Name:    top 
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
module top(
	input clk,
	input rst_n
);

wire [31:0] j_z_nextpc;
wire PCWrite;

wire [31:0] now_addr;

wire MEMWrite;
wire IorD;
wire [31:0] mem_out;

wire RegDst;
wire MemToReg;
wire RegWrite;
wire IRWrite;
wire ALUSrcA;
wire [1:0] ALUSrcB;
wire ALURegWe;
wire [31:0] rego1;
wire [31:0] rego2;

wire [4:0] ALUControl;

wire [31:0] aluout;
wire flag;

wire NeedJmp;
wire BorJ;
wire pcen;

PC u_PC(
	clk,
	rst_n,
	pcen,
	j_z_nextpc,
	PCWrite,
	now_addr
);

MEMmodule u_MEMmodule(
	clk,
	rst_n,
	now_addr,
	aluout,
	IorD,
	rego2,
	MEMWrite,
	IRWrite,
	mem_out
);

REG_FILEmodule u_REGFILEmodule(
	clk,
	rst_n,
	mem_out,
	mem_out,
	RegDst,
	MemToReg,
	RegWrite,
	rego1,
	rego2
);

ALUmodule u_ALUmodule(
	clk,
	rst_n,
	rego1,
	now_addr,
	ALUSrcA,
	rego2,
	mem_out[15:0],
	ALUSrcB,
	ALUControl,
	ALURegWE,
	aluout,
	alu_lock,
	flag
);

branch u_branch(
	NeedJmp,
	BorJ,
	flag,
	now_addr,
	mem_out[15:0],
	mem_out[25:0],
	PCWrite,
	j_z_nextpc
);

FSM u_FSM(
	clk,
	rst_n,
	mem_out,
	RegDst,
	MemtoReg,
	IorD,
	MEMWrite,
	IRWrite,
	pcen,
	Branch,
	PCSrc,
	ALUControl,
	ALUSrcB,
	ALUSrcA,
	RegWrite,
	ALURegWe,
	NeedJmp,
	BorJ
);
endmodule
