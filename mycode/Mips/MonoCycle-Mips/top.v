`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:30 04/17/2017 
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


wire muxer;
wire [31:0] addr;


wire [31:0] now_addr;
wire [31:0] ir_addr;
assign ir_addr=now_addr>>2;

pc u_pc(
	clk,
	rst_n,
	muxer,
	addr,
	now_addr
);

wire [31:0] instruction;
ir u_ir(
	ir_addr,
	instruction
);

wire [4:0] aluop;
wire [1:0] optype;
wire reg_AOM;
wire regwe;

wire memwe;

wire Wr;

wire br;
wire j_or_b;
control u_control(
	clk,
	rst_n,
	instruction,
	optype,
	aluop,
	reg_AOM,
	regwe,
	Wr,
	memwe,
	
	br,
	j_or_b
);


wire [4:0] regip1;
assign regip1=instruction[25:21];

wire [4:0] regip2;
assign regip2=instruction[20:16];

wire [4:0] regip3;
assign regip3=instruction[15:11];

wire [31:0] reg_ipdata;
wire [31:0] aluout;

wire [31:0] dout;

assign reg_ipdata=(reg_AOM ? aluout : dout);

wire [31:0] regop1;
wire [31:0] regop2;

wire [4:0] regaddr1;
wire [4:0] regaddr2;
wire [4:0] regaddr3;


REG_MUXER u_REG_MUXER(
	regip1,
	regip2,
	regip3,
	Wr,
	optype,
	regaddr1,
	regaddr2,
	regaddr3
);


REG_FILE u_REG_FILE(
	clk,
	rst_n,
	regaddr1,
	regaddr2,
	regaddr3,
	reg_ipdata,
	regwe,
	regop1,
	regop2
);

wire [31:0] memipdata;
assign memipdata=regop2;



wire [31:0] aluip1;
wire [31:0] aluip2;


wire nzp;

wire [15:0] imm;
assign imm=instruction[15:0];
wire [25:0] jtypeImm;
assign jtypeImm=instruction[25:0];
ALU_MUXER u_ALU_MUXER(
	regop1,
	regop2,
	imm,
	jtypeImm,
	optype,
	aluip1,
	aluip2
);

ALU u_ALU(
	aluip1,
	aluip2,
	aluop,
	aluout,
	nzp
);

wire [31:0] memaddr;
assign memaddr=aluout>>2;

mem u_mem(
	memaddr,
	memipdata,
	clk,
	memwe,
	dout
);

branch u_branch(
	now_addr,
	br,
	j_or_b,
	nzp,
	aluip2,
	muxer,
	addr
);

endmodule
