`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:19:32 03/20/2017 
// Design Name: 
// Module Name:    alternative_REG_FILE 
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
module REG_FILE(
	input clk,
	input rst_n,
	input [4:0] r1_addr,
	input [4:0] r2_addr,
	input [4:0] r3_addr,
	input [31:0] r3_din,
	input r3_wr,
	output [31:0] r1_dout,
	output [31:0] r2_dout
);



reg [31:0] now_regs[31:0];
reg [31:0] next_regs[31:0];

reg [4:0] local_r1_addr;
reg [4:0] local_r2_addr;

assign r1_dout=  (r3_wr == 1 && local_r1_addr==r3_addr) ? r3_din : now_regs[local_r1_addr][31:0];
assign r2_dout=  (r3_wr == 1 && local_r2_addr==r3_addr) ? r3_din : now_regs[local_r2_addr][31:0];


always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		local_r1_addr<=5'h0;
		local_r2_addr<=5'h0;
	end
	else
	begin
		local_r1_addr<=r1_addr;
		local_r2_addr<=r2_addr;
	end
end


always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		now_regs[0]<=32'b0;
		now_regs[1]<=32'b0;
		now_regs[2]<=32'b0;
		now_regs[3]<=32'b0;
		now_regs[4]<=32'b0;
		now_regs[5]<=32'b0;
		now_regs[6]<=32'b0;
		now_regs[7]<=32'b0;
		now_regs[8]<=32'b0;
		now_regs[9]<=32'b0;
		now_regs[10]<=32'b0;
		now_regs[11]<=32'b0;
		now_regs[12]<=32'b0;
		now_regs[13]<=32'b0;
		now_regs[14]<=32'b0;
		now_regs[15]<=32'b0;
		now_regs[16]<=32'b0;
		now_regs[17]<=32'b0;
		now_regs[18]<=32'b0;
		now_regs[19]<=32'b0;
		now_regs[20]<=32'b0;
		now_regs[21]<=32'b0;
		now_regs[22]<=32'b0;
		now_regs[23]<=32'b0;
		now_regs[24]<=32'b0;
		now_regs[25]<=32'b0;
		now_regs[26]<=32'b0;
		now_regs[27]<=32'b0;
		now_regs[28]<=32'b0;
		now_regs[29]<=32'b0;
		now_regs[30]<=32'b0;
		now_regs[31]<=32'b0;
	end
	else
	begin
		now_regs[0]<=next_regs[0];
		now_regs[1]<=next_regs[1];
		now_regs[2]<=next_regs[2];
		now_regs[3]<=next_regs[3];
		now_regs[4]<=next_regs[4];
		now_regs[5]<=next_regs[5];
		now_regs[6]<=next_regs[6];
		now_regs[7]<=next_regs[7];
		now_regs[8]<=next_regs[8];
		now_regs[9]<=next_regs[9];
		now_regs[10]<=next_regs[10];
		now_regs[11]<=next_regs[11];
		now_regs[12]<=next_regs[12];
		now_regs[13]<=next_regs[13];
		now_regs[14]<=next_regs[14];
		now_regs[15]<=next_regs[15];
		now_regs[16]<=next_regs[16];
		now_regs[17]<=next_regs[17];
		now_regs[18]<=next_regs[18];
		now_regs[19]<=next_regs[19];
		now_regs[20]<=next_regs[20];
		now_regs[21]<=next_regs[21];
		now_regs[22]<=next_regs[22];
		now_regs[23]<=next_regs[23];
		now_regs[24]<=next_regs[24];
		now_regs[25]<=next_regs[25];
		now_regs[26]<=next_regs[26];
		now_regs[27]<=next_regs[27];
		now_regs[28]<=next_regs[28];
		now_regs[29]<=next_regs[29];
		now_regs[30]<=next_regs[30];
		now_regs[31]<=next_regs[31];
	end
	if(r3_wr)
		now_regs[r3_addr]<=r3_din;
	else
	begin
	end
end


always@(*)
begin
	next_regs[0]=now_regs[0];
	next_regs[1]=now_regs[1];
	next_regs[2]=now_regs[2];
	next_regs[3]=now_regs[3];
	next_regs[4]=now_regs[4];
	next_regs[5]=now_regs[5];
	next_regs[6]=now_regs[6];
	next_regs[7]=now_regs[7];
	next_regs[8]=now_regs[8];
	next_regs[9]=now_regs[9];
	next_regs[10]=now_regs[10];
	next_regs[11]=now_regs[11];
	next_regs[12]=now_regs[12];
	next_regs[13]=now_regs[13];
	next_regs[14]=now_regs[14];
	next_regs[15]=now_regs[15];
	next_regs[16]=now_regs[16];
	next_regs[17]=now_regs[17];
	next_regs[18]=now_regs[18];
	next_regs[19]=now_regs[19];
	next_regs[20]=now_regs[20];
	next_regs[21]=now_regs[21];
	next_regs[22]=now_regs[22];
	next_regs[23]=now_regs[23];
	next_regs[24]=now_regs[24];
	next_regs[25]=now_regs[25];
	next_regs[26]=now_regs[26];
	next_regs[27]=now_regs[27];
	next_regs[28]=now_regs[28];
	next_regs[29]=now_regs[29];
	next_regs[30]=now_regs[30];
	next_regs[31]=now_regs[31];

//	if(r3_wr)
//	begin
//		next_regs[r3_addr]=r3_din;
//	end
//	else
//	begin
//	end
end
endmodule
