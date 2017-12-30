`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:40:10 05/25/2017 
// Design Name: 
// Module Name:    IR_reg 
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
module IR_reg(
	input clk,
	input rst_n,
	
	input [31:0] pc,
	input [31:0] ir,
	
	input is_int,
	
	input ir_stall,
	input ir_bubble,
	
	
	//	Here are the vars from the fifth step
	input preg_we,
	input [4:0] pregaddr3,
	input [31:0] pregvalue3,
	// no need to know what value it is
	
	output reg [31:0] next_pc,
	output reg [31:0] next_ir,
	
	output reg [4:0] regaddr1,
	output reg [4:0] regaddr2,
	output reg [4:0] regaddr3, // need to be written at posedge and distribute
	
	output [31:0] alu_a,
	output  [31:0] alu_b, // REG_FILE or Imm outputs at posedge
	
	output [31:0] swdata, // only valid in command sw, connect to reg2
	
	output reg [4:0] op,
	output reg [5:0] optype, //posedge write here
	
	output reg RTI,
	output syscall
);
assign syscall = ir==32'h0000_000C ? 1 : 0;

wire [31:0] regout1;
wire [31:0] regout2;
assign swdata = regout2;

reg [31:0] next_temppc;

reg [31:0] local_swdata;

//Control Logical Unit
reg [4:0] ir_local_regaddr1;
reg [4:0] ir_local_regaddr2;
reg [4:0] ir_local_regaddr3;

reg [5:0] ir_local_optype;

// hex  op

// 3f nop (bubble)

// 00 t1=f(t2,t3)
// 01 t1=f(t2,shamt) sll srl sra
// 02 t1=f(t2,-) clo clz

// 04 t1=f(t2,imm) 
// 05 t1=f(t2,uint(imm))
// 06 t1=f(-,imm) lui li

// 10 pc=reg jr
// 11 pc=imm j
// 12 R(t1,t2) pc=pc+off branch

// 13 lw
// 14 sw

// 20 eret
// 21 syscall

// 30 ? extra state?

reg [4:0] ir_local_op;


always@(*)
begin
	if(ir_stall)
	begin
		ir_local_op=op;
		ir_local_optype=optype;
		next_temppc=next_pc;
	end
	else if(ir_bubble || is_int) //ir_bubble  && !is_int)
	begin
		ir_local_op=5'h0;
		ir_local_optype=6'h3F;
	end
	
	else if(ir==32'h0)
	begin
		ir_local_op=5'h0;
		ir_local_optype=6'h3F;
	end
	
	else if(ir==32'h4200_0018) //eret
	begin
		ir_local_optype=6'h20;
	end
	else if(ir==32'h0000_000C) //syscall
	begin
		ir_local_op=5'h12;
		ir_local_optype=6'h21;
	end
	else
	begin
		next_temppc=pc;
		case(ir[31:26])
			6'h0:
			begin
				if(ir[5:0]==6'b001000) //jr
				begin
					ir_local_optype=6'h10;
					ir_local_op=5'h12; //outputa
				end
				else if(ir[5:0] == 6'b000000) //sll
				begin
					ir_local_op=5'hD;
					ir_local_optype=6'h01;
				end
				else if(ir[5:0] == 6'b000010) //srl
				begin
					ir_local_op=5'hE;
					ir_local_optype=6'h01;
				end
				else if(ir[5:0] == 6'b000011) //sra
				begin
					ir_local_op=5'hF;
					ir_local_optype=6'h01;
				end
				else
				begin
					ir_local_optype=6'h00;
					if(ir[5:0]==6'b10_0000) //add
					begin
						ir_local_op=5'h01;
					end
					else if(ir[5:0]==6'b10_0001) //addu
					begin
						ir_local_op=5'h01;
					end
					else if(ir[5:0]==6'b10_0010) //sub
					begin
						ir_local_op=5'h02;
					end
					else if(ir[5:0]==6'b10_0011) //subu
					begin
						ir_local_op=5'h02;
					end
					else if(ir[5:0]==6'b10_0100) //and
					begin
						ir_local_op=5'h03;
					end
					else if(ir[5:0]==6'b10_0101) //or
					begin
						ir_local_op=5'h04;
					end
					else if(ir[5:0]==6'b10_0110) //xor
					begin
						ir_local_op=5'h05;
					end
					else if(ir[5:0]==6'b10_0111) //nor
					begin
						ir_local_op=5'h06;
					end
					else if(ir[5:0]==6'b00_0100) //sllv
					begin
						ir_local_op=5'h0D;
					end
					else if(ir[5:0]==6'b00_0110) //srlv
					begin
						ir_local_op=5'h0E;
					end
					else if(ir[5:0]==6'b00_0111) //srav
					begin
						ir_local_op=5'h0F;
					end
					else
					begin
					end
				end
			end //end 6'h0 calc
			6'b01_1100: //clo clz
			begin
				if(ir[5:0]==6'b10_0001) //clo
				begin
					ir_local_optype=6'h02;
					ir_local_op=5'h1E;
				end
				else if(ir[5:0]==6'b10_0000) //clz
				begin
					ir_local_optype=6'h02;
					ir_local_op=5'h1F;
				end
				else
				begin
				end
			end
			6'b00_1000: // addi
			begin
				ir_local_optype=6'h04;
				ir_local_op=5'h01;
			end
			6'b00_1100: //andi
			begin
				ir_local_optype=6'h05;
				ir_local_op=5'h03;
			end
			6'b00_1101: //ori
			begin
				ir_local_optype=6'h05;
				ir_local_op=5'h04;
			end
			6'b00_1110: //xori
			begin
				ir_local_optype=6'h05;
				ir_local_op=5'h05;
			end
			6'b00_1111: //lui
			begin
				ir_local_optype=6'h06;
				ir_local_op=5'h10;
			end
			6'b00_1001: //li
			begin
				ir_local_optype=6'h06;
				ir_local_op=5'h11;
			end
			6'b00_0010: //j
			begin
				ir_local_optype=6'h11;
				ir_local_op=5'h13; //output_b from imm
			end
			6'b00_0100: //beq
			begin
				ir_local_optype=6'h12;
				ir_local_op=5'h0B;
			end
			6'b00_0101: //bne
			begin
				ir_local_optype=6'h12;
				ir_local_op=5'h0C;
			end
			6'b00_0111: //bgtz
			begin
				ir_local_optype=6'h12;
				ir_local_op=5'h07;
			end
			6'b00_0110: //blez
			begin
				ir_local_optype=6'h12;
				ir_local_op=5'h0A;
			end
			6'b00_0001: //bgez or bltz
			begin
				if(ir[16]) //bgez
				begin
					ir_local_optype=6'h12;
					ir_local_op=5'h08;
				end
				else //bltz
				begin
					ir_local_optype=6'h12;
					ir_local_op=5'h09;
				end
			end
			6'b10_0011: //lw
			begin
				ir_local_optype=6'h13;
				ir_local_op=5'h01;
			end
			6'b101011: //sw
			begin
				ir_local_optype=6'h14;
				ir_local_op=5'h01;
			end
			default:
			begin
			end
			
		endcase
	end
end
//this logical com calcs the address input to reg
//and below calcs from reg value and imm to next process

reg [31:0] tpimm;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		tpimm<=32'h0;
	end
	else
	begin
		if(ir_local_optype==6'h01)
			tpimm<=$unsigned(ir[10:6]);
		else if(ir_local_optype==6'h04 || ir_local_optype==6'h13 || ir_local_optype==6'h14)
			tpimm<=$signed(ir[15:0]);
		else if(ir_local_optype==6'h05 || ir_local_optype==6'h06)
			tpimm<=$unsigned(ir[15:0]);
		else if(ir_local_optype==6'h11)
			tpimm<={$unsigned(ir[25:0]),2'h0};
		else
		begin
		end
	end
end

reg is_reg_or_imm;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		is_reg_or_imm<=0;
	end
	else
	begin
		if(ir_local_optype==6'h01 || ir_local_optype==6'h04 || ir_local_optype==6'h05
	 || ir_local_optype==6'h06  || ir_local_optype==6'h13  || ir_local_optype==6'h14  || ir_local_optype==6'h11)
		begin
			is_reg_or_imm<=1;
		end
		else
			is_reg_or_imm<=0;
	end
end

/*
always@(posedge clk or negedge rst_n)
begin
	if(optype==6'h01 || optype==6'h04 || optype==6'h05
	 || optype==6'h06  || optype==6'h13  || optype==6'h14  || optype==6'h11)
	 begin
		alu_b<=tpimm;
	 end
	 else
		alu_b=regout2;
end
*/

reg is_shamt;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		is_shamt<=0;
	else
	begin
		if(ir_local_optype==6'h01)
			is_shamt<=1;
		else
			is_shamt<=0;
	end
end

assign alu_a = is_shamt? regout2 : regout1;

assign alu_b = is_reg_or_imm ? tpimm : regout2;

/*
always@(*)
begin
		if(ir_stall)
		begin
		end
		else if(ir_local_optype==6'h3F) //bubble
		begin
		end
		else if(ir_local_optype==6'h00) //t1=f(t2,t3)
		begin
			alu_a=regout1;
			//alu_b<=regout2;
		end
		else if(ir_local_optype==6'h01) //t1=f(t2,shamt)
		begin
			alu_a=regout2;
			//alu_b<=tpimm;//$unsigned(ir[10:6]);
		end
		else if(ir_local_optype==6'h02) //t1=f(t2,-) clo clz
		begin
			alu_a=regout1;
			//palu_b<=32'hCCCC_CCCC;
		end
		else if(ir_local_optype==6'h04) //t1=f(t2,imm)
		begin
			alu_a=regout1;
			//alu_b<=tpimm;//$signed(ir[15:0]);
		end
		else if(ir_local_optype==6'h05) //t1=f(t2,uimm)
		begin
			alu_a=regout1;
			//alu_b<=tpimm;//$unsigned(ir[15:0]);
		end
		else if(ir_local_optype==6'h06) //t1=f(-,imm) lui li
		begin
			alu_a=regout2;
			//alu_b<=tpimm;//$unsigned(ir[15:0]);
		end
		else if(ir_local_optype==6'h10) //pc=reg jr
		begin
			alu_a=regout1;
			//alu_b<=32'hCCCC_CCCC;
		end
		else if(ir_local_optype==6'h11) //pc=imm j
		begin
			alu_a=32'hCCCC_CCCC;
			//alu_b<=tpimm;//{$unsigned(ir[25:0]),2'h0};
		end
		else if(ir_local_optype==6'h12) // R(t1,t2) pc=pc+off branch
		begin
			alu_a=regout1;
			//alu_b<=regout2;
		end
		
		else if(ir_local_optype==6'h13) //lw
		begin
			alu_a=regout1;
			//alu_b<=tpimm;//$signed(ir[15:0]);
		end
		else if(ir_local_optype==6'h14) //sw
		begin
			alu_a=regout1;
			//alu_b<=tpimm;//$signed(ir[15:0]);
		end
		else if(ir_local_optype==6'h21) //syscall
		begin
			alu_a=regout1;
		end
		else
		begin
			// doing nothing here
		end

end
*/

always@(*)
begin
	RTI=0;
	if(ir_stall)
	begin
		ir_local_regaddr1=regaddr1;
		ir_local_regaddr2=regaddr2;
		ir_local_regaddr3=regaddr3;
	end
	else if(ir_local_optype==6'h3F) //bubble
	begin
		ir_local_regaddr1=5'h0;
		ir_local_regaddr2=5'h0;
		ir_local_regaddr3=5'h0;
	end
	else if(ir_local_optype==6'h00) //t1=f(t2,t3)
	begin
		ir_local_regaddr1=ir[25:21];
		ir_local_regaddr2=ir[20:16];
		ir_local_regaddr3=ir[15:11];
	end
	else if(ir_local_optype==6'h01) //t1=f(t2,shamt)
	begin
		ir_local_regaddr1=ir[20:16];
		ir_local_regaddr3=ir[15:11];
	end
	else if(ir_local_optype==6'h02) //t1=f(t2,-) clo clz
	begin
		ir_local_regaddr1=ir[25:21];
		ir_local_regaddr3=ir[15:11];
	end
	else if(ir_local_optype==6'h04) //t1=f(t2,imm)
	begin
		ir_local_regaddr1=ir[25:21];
		ir_local_regaddr3=ir[20:16];
	end
	else if(ir_local_optype==6'h05) //t1=f(t2,uimm)
	begin
		ir_local_regaddr1=ir[25:21];
		ir_local_regaddr3=ir[20:16];
	end
	else if(ir_local_optype==6'h06) //t1=f(-,imm) lui li
	begin
		ir_local_regaddr3=ir[20:16];
	end
	else if(ir_local_optype==6'h10) //pc=reg jr
	begin
		ir_local_regaddr1=ir[25:21];
	end
	else if(ir_local_optype==6'h11) //pc=imm j
	begin
	end
	else if(ir_local_optype==6'h12) // R(t1,t2) pc=pc+off branch
	begin
		ir_local_regaddr1=ir[25:21];
		ir_local_regaddr2=ir[20:16];
	end
	
	else if(ir_local_optype==6'h13) //lw
	begin
		ir_local_regaddr1=ir[25:21];
		ir_local_regaddr3=ir[20:16];
	end
	else if(ir_local_optype==6'h14) //sw
	begin
		ir_local_regaddr1=ir[25:21];
		ir_local_regaddr2=ir[20:16];
	end
	
	
	else if(ir_local_optype==6'h20) //eret
	begin
		//RTI immediately
		RTI=1;
	end
	else if(ir_local_optype==6'h21) //syscall
	begin
		ir_local_regaddr1=5'h2;  //v0=0x2
	end
	else
	begin
		// doing nothing here
	end
end


// imm will be calc logically, while reg value need posedge



//at 2nd posedge, data write to output
//make sure 3rd pocess can use the data


reg two_bubble;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		optype<=6'h3F; // nop or bubble
		op<=5'h0;
		regaddr1<=5'h0;
		regaddr2<=5'h0;
		regaddr3<=5'h0;
		next_pc<=32'h0;
		next_ir<=32'h0;
		two_bubble<=1;
	end
	else
	begin
		next_pc<=next_temppc;
		next_ir<=ir;
		if(two_bubble)
		begin
			two_bubble<=0;
			optype<=6'h3F;
		end
		else
		begin
			optype<=ir_local_optype;
		end
		op<=ir_local_op;
		regaddr1<=ir_local_regaddr1;
		regaddr2<=ir_local_regaddr2;
		regaddr3<=ir_local_regaddr3;  // posedge already written
	end
end




REG_FILE u_REG_FILE(
	.clk(clk),
	.rst_n(rst_n),
	.r1_addr(ir_local_regaddr1),
	.r2_addr(ir_local_regaddr2),
	.r3_addr(pregaddr3), //note that value here comes from 5th process
	.r3_din(pregvalue3),
	.r3_wr(preg_we),
	.r1_dout(regout1),
	.r2_dout(regout2)
);


endmodule
