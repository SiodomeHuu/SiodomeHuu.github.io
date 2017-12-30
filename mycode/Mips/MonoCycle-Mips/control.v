`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:09 04/17/2017 
// Design Name: 
// Module Name:    control 
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
module control(
	input clk,
	input rst_n,
	
	input [31:0] instruction,
	
	output reg [1:0] optype, //0-R 1-I 2-J
	output reg [4:0] aluop,
	
	output reg reg_AOM,
	output reg regwe,
	output reg Wr,
	
	output reg memwe,
	
	output reg br,
	output reg j_or_b
);

//add:
// 000000_[r5][r5][r5]_[5=0x0][6=0x20]
// 31:26   25:21 20:16  15:10    10:5    5:0

//addi
//001000_[r5][r5][imm]
//31:26  25:21 20:16 15:0

//lw
//100011_[r5][r5][imm]

//sw
//101011_[r5][r5][imm]

//j
//000010_[26]

//bgtz
//000111_[r5][empty][imm]



always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
	end
	else
	begin
	end
end


reg [31:0] inter_instruct;
always@(*)
begin
	inter_instruct=instruction;
	aluop=5'b1;
	case(inter_instruct[31:26])
		6'b000000: // add
		begin
			if(inter_instruct[10:0]==11'h20)
			begin
				optype=2'h0;
				reg_AOM=1;
				regwe=1;
				memwe=0;
				Wr=0;
				br=0;
			end
		end
		6'b001000: //addi
		begin
			optype=2'h1;
			reg_AOM=1;
			regwe=1;
			memwe=0;
			Wr=0;
			br=0;
		end
		6'b100011: //lw
		begin
			optype=2'h1;
			regwe=1;
			reg_AOM=0;
			memwe=0;
			Wr=0;
			br=0;
		end
		6'b101011: //sw
		begin
			optype=2'h1;
			regwe=0;
			reg_AOM=0;
			memwe=1;
			Wr=1;
			br=0;
		end
		6'b000111: //bgtz
		begin
			optype=2'h1;
			regwe=0;
			reg_AOM=0;
			memwe=0;
			Wr=0;
			br=1;
			j_or_b=0;
			aluop=5'h7;
		end
		6'b000010: //j
		begin
			optype=2'h2;
			regwe=0;
			reg_AOM=0;
			memwe=0;
			Wr=0;
			br=1;
			j_or_b=1;
		end
		default:
		begin
			optype=2'h3;
			regwe=0;
			reg_AOM=0;
			memwe=0;
			Wr=0;
			br=0;
		end
	endcase
	
end


endmodule
