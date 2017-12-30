`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:08 05/28/2017 
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
// Revision 0.01 - FileCreated
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALUmodule(
	input clk,
	input rst_n,
	
	input alu_stall,
	input alu_bubble,
	//from previous process
	input [31:0] pc,
	input [31:0] ir,
	input [4:0] regaddr1,
	input [4:0] regaddr2,
	input [4:0] regaddr3,
	input [31:0] alu_a,
	input [31:0] alu_b,
	input [4:0] op,
	input [5:0] optype,
	
	input [31:0] swdata,
	
	//backword from alu answer
	input [4:0] a_bwregaddr,
	input [31:0] a_bw_data,
	input a_valid,
	//backword from write back
	input [4:0] b_bwregaddr,
	input [31:0] b_bw_data,
	input b_valid,
	
	
	//
	output [31:0] walu_out,
	output wflag,
	
	// this output
	output reg to_valid,
	output reg [4:0] to_regaddr3,
	output reg [31:0] alu_out, //this will connect to a_bwregaddr
	output reg flag,
	output reg [31:0] to_swdata,
	//continue distributing

	output reg [31:0] to_pc,
	output reg [31:0] to_ir,
	output reg [5:0] to_optype
	
);

reg [31:0] local_d1;
reg [31:0] local_d2;



always@(*)
begin
	local_d1=alu_a;
	local_d2=alu_b;
	if(optype==6'h00 || optype==6'h12) //t1=f(t2,t3)
	begin
		if(a_bwregaddr==regaddr1 && a_valid)
		begin
			local_d1=a_bw_data;
		end
		else if(b_bwregaddr==regaddr1 && b_valid)
		begin
			local_d1=b_bw_data;
		end
		else
		begin
			local_d1=alu_a;
		end
				
		if(a_bwregaddr==regaddr2 && a_valid)
		begin
			local_d2=a_bw_data;
		end
		else if(b_bwregaddr==regaddr2 && b_valid)
		begin
			local_d2=b_bw_data;
		end
		else
		begin
			local_d2=alu_b;
		end
	end
	
	else if(optype==6'h01 || optype==6'h02 || optype==6'h04 || optype==6'h05
		|| optype==6'h10 || optype==6'h13 || optype==6'h14)
	begin //imm type
		if(a_bwregaddr==regaddr1 && a_valid)
		begin
			local_d1=a_bw_data;
		end
		else if(b_bwregaddr==regaddr1 && b_valid)
		begin
			local_d1=b_bw_data;
		end
		else
		begin
			local_d1=alu_a;
		end
		
		if(a_bwregaddr==regaddr2 && a_valid)
		begin
			local_swdata=a_bw_data;
		end
		else if(b_bwregaddr==regaddr2 && b_valid)
		begin
			local_swdata=b_bw_data;
		end
		else
		begin
			local_swdata=swdata;
		end
		
	end
	else
	begin
	end
end



ALU u_ALU(
	.alu_a(local_d1),
	.alu_b(local_d2),
	.alu_op(op),
	.alu_out(walu_out),
	.flag(wflag)
);

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		alu_out<=32'hCCCC_CCCC;
		flag<=0;
	end
	else
	begin
		alu_out<=walu_out;
		flag<=wflag;
	end
end

reg [31:0] local_pc;
reg [31:0] local_ir;
reg [31:0] local_optype;
reg [31:0] local_swdata;

always@(*)
begin
	if(alu_stall)
	begin
		local_pc=to_pc;
		local_ir=to_ir;
		local_optype=to_optype;
	end
	else if(alu_bubble)
	begin
		local_optype=6'h3F;
	end
	begin
		local_pc=pc;
		local_ir=ir;
		local_optype=optype;
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		to_pc<=32'h0;
		to_ir<=32'h0;
		to_optype<=6'h3F;
		to_regaddr3<=5'h0;
		to_valid<=0;
	end
	else if(alu_stall)
	begin
		to_pc<=local_pc;
		to_ir<=local_ir;
		to_optype<=local_optype;
		to_swdata<=local_swdata;
	end
	else
	begin
		to_pc<=pc;
		to_ir<=ir;
		to_optype<=optype;


		to_swdata<=local_swdata;
		
		to_regaddr3<=regaddr3;
		
		if(local_optype==6'h00 || local_optype==6'h01 || local_optype==6'h02
		|| local_optype==6'h04 || local_optype==6'h05 || local_optype==6'h06 || local_optype==6'h13)
			to_valid<=1;
		else
			to_valid<=0;
	end
end


endmodule
