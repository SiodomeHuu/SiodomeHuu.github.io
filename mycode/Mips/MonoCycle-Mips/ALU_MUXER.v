`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:50 04/17/2017 
// Design Name: 
// Module Name:    ALU_MUXER 
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
module ALU_MUXER(
	input [31:0] regop1,
	input [31:0] regop2,
	
	input [15:0] imm,
	input [25:0] jtypeImm,
	
	input [1:0] optype,
	
	
	output [31:0] aluip1,
	output reg [31:0] aluip2
);

assign aluip1=regop1;


always@(*)
begin
	if(optype==2'h0) //r-type
		aluip2=regop2;
	else if(optype==2'h1) //i-type
	begin
		if(imm[15]==0)
			aluip2[31:16]=16'b0;
		else
			aluip2[31:16]=16'hFFFF;
		aluip2[15:0]=imm;
	end
	else if(optype==2'h2) //j-type
	begin
		if(jtypeImm[25]==0)
			aluip2[31:26]=6'b0;
		else
			aluip2[31:26]=6'b111111;
		aluip2[25:0]=jtypeImm;
	end
	else
		aluip2=32'b0;
end

endmodule
