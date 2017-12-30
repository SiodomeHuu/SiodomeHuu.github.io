`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:07:29 05/02/2017 
// Design Name: 
// Module Name:    FSM 
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
module FSM(
	input clk,
	input rst_n,
	input [31:0] ir,
	
	output reg RegDst,
	output reg MemtoReg,
	
	output reg IorD,
	output reg MemWrite,
	output reg IRWrite,
	output reg pcen,
	output reg Branch,
	output reg PCSrc,
	output reg [4:0] ALUControl,
	output reg [1:0] ALUSrcB,
	output reg ALUSrcA,
	output reg RegWrite,
	
	output reg ALURegWe,
	
	output reg NeedJmp,
	output reg BorJ
);

// 00 halt
// 01 out=(pc=pc') pc'=pc+4 
// 02 fetch command,logic switch,set all muxer data
// 10 add; get alu answer
// 11 write back
// 20 addi get alu answer
// (11) 21 write back

// 30 lw add,get address
// 31 read
// 32 write back
// 40 sw add,get address,get data
// 41 write

// 50 bgtz, get flag & pc,write to pc'
// 60 j, get pc, write to pc'


reg [7:0] nowstate;
reg [7:0] nextstate;


always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		nowstate<=8'h0;
	end
	else
		nowstate<=nextstate;
end

always@(*)
begin
	case(nowstate)
	8'h0:
		nextstate=8'h1;
	8'h1:
		nextstate=8'h2;
	8'h2:
		begin
			case(ir[31:26])
			6'h0:
				nextstate=8'h10; //add
			6'h8:
				nextstate=8'h20; //addi
			6'h23:
				nextstate=8'h30; //lw
			6'h2B:
				nextstate=8'h40; //sw
			6'h2:
				nextstate=8'h50; //j
			6'h7:
				nextstate=8'h60; //bgtz
			default:
				nextstate=8'h0;
			endcase
		end
	8'h10:
		nextstate=8'h11;
	8'h20:
		nextstate=8'h21;
	8'h30:
		nextstate=8'h31;
	8'h31:
		nextstate=8'h32;
	8'h40:
		nextstate=8'h41;
	8'h50:
		nextstate=8'h51;
	8'h60:
		nextstate=8'h61;
	default:
		nextstate=8'h1;
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		pcen<=1;
		MemWrite<=0;
		RegWrite<=0;
		IorD<=0;
		IRWrite<=0;
		Branch<=0;
		PCSrc<=0;
		ALUControl<=5'b0;
		ALUSrcB<=2'b0;
		ALUSrcA<=0;
		RegWrite<=0;
		ALURegWe<=0;
		NeedJmp<=0;
		BorJ<=0;
	end
	else
	begin
	case(nextstate)
	8'h1:
	begin
		//PC into mem_addr
		pcen<=0;
		IRWrite<=1;
	end
	8'h2:
	begin
		//mem data is already prepared
		IRWrite<=0; //lock instruction
	end
	8'h10:
	begin //add
		RegDst<=1;
		RegWrite<=1;
		ALUSrcA<=1;
		ALUSrcB<=2'b00;
		ALURegWe<=1;
		ALUControl<=5'h1;
		MemtoReg<=0;
	end
	8'h11:
	begin
		RegDst<=0;
		RegWrite<=0;
		ALUSrcA<=0;
		ALUControl<=5'h0;
		pcen<=1;
		ALURegWe<=0;
	end
	8'h20: //addi
	begin
		RegDst<=0;
		RegWrite<=1;
		ALUSrcA<=1;
		ALUSrcB<=2'b10;
		ALUControl<=5'h1;
		MemtoReg<=0;
		ALURegWe<=1;
	end
	8'h21:
	begin
		RegDst<=0;
		RegWrite<=0;
		ALUSrcA<=0;
		ALUSrcB<=2'b0;
		ALUControl<=5'h0;
		pcen<=1;
		ALURegWe<=0;
	end
	8'h30: //lw
	begin
		ALUSrcA<=1;
		ALUSrcB<=2'b11;
		ALUControl<=5'h1;
		IorD<=1;
		ALURegWe<=1;
	end
	8'h31:
	begin
		ALURegWe<=0;
		IorD<=0;
		ALUControl<=5'h0;
		ALUSrcA<=0;
		ALUSrcB<=2'b0;
		//after posedge, mem data is already
		RegDst<=0;
		RegWrite<=1;
	end
	8'h32:
	begin
		//this posedge, write data to reg
		RegWrite<=0;
		pcen<=1;
	end
	8'h40: //sw
	begin
		ALUSrcA<=1;
		ALUSrcB<=2'b11;
		ALUControl<=5'h1;
		IorD<=1;
		ALURegWe<=1; //next posedge, address is ready, rego2 is also ready
		MemWrite<=1;
	end
	8'h41:
	begin
		MemWrite<=0;
		ALURegWe<=0;
		IorD<=0;
		ALUSrcA<=0;
		ALUSrcB<=2'b0;
		ALUControl<=5'h0;
		pcen<=1;
	end
	8'h50: //bgtz
	begin
		ALUSrcA<=1;
		ALUControl<=5'h7;
		NeedJmp<=1;
		BorJ<=1;
	end
	8'h51: //this posedge,flag is set
	begin
		NeedJmp<=0;
		BorJ<=0;
		pcen<=1;
	end
	8'h60: //j
	begin
		NeedJmp<=1;
		BorJ<=0;
	end
	8'h61:
	begin
		NeedJmp<=0;
		pcen<=1;
	end
	endcase
	end
end
endmodule
