`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:26:50 05/02/2017 
// Design Name: 
// Module Name:    REG_FILEmodule 
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
module REG_FILEmodule(
	input clk,
	input rst_n,
	input [31:0] ir,
	
	input [31:0] aluans,
	
	input RegDst,
	input MemToReg,
	input RegWrite,
	
	output reg [31:0] rego1,
	output reg [31:0] rego2
);

wire [31:0] regot1;
wire [31:0] regot2;

wire [4:0] regaddr1;
wire [4:0] regaddr2;
wire [4:0] regaddr3;

assign regaddr1=ir[25:21];
assign regaddr2=ir[20:16];
assign regaddr3= RegDst ? ir[15:11] : ir[20:16] ;

wire [31:0] wd;
assign wd = MemToReg ? ir : aluans;

REG_FILE u_RegFile(
	clk,
	rst_n,
	regaddr1,
	regaddr2,
	regaddr3,
	wd,
	RegWrite,
	regot1,
	regot2
);

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		rego1<=32'hcccccccc;
		rego2<=32'hcccccccc;
	end
	else
	begin
		rego1<=regot1;
		rego2<=regot2;
	end
end
endmodule
