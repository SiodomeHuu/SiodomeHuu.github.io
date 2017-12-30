`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:49 05/25/2017 
// Design Name: 
// Module Name:    pc 
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
module pc(
	input clk,
	input rst_n,
	
	input syscall,
	input button,
	
	input [31:0] target,
	input [31:0] int_id,
	
	input start_int,
	input RTI,
	input pc_stall,
	input pc_jump,
	

	
	output [31:0] pc
);

assign pc=now_pc;

reg [31:0] now_pc;
reg [31:0] next_pc;


always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		now_pc<=32'b0;
	else
		now_pc<=next_pc;
end

//below are interrupt unit

reg [31:0] int_pc;



always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		int_pc<=32'b0;
	else if(start_int && syscall)
		int_pc<=now_pc-32'h4;
	else if(start_int && button)
		int_pc<=now_pc-32'h8;
	else
	begin
	end
end

reg flg;
reg [2:0] ct;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		flg<=0;
		ct<=3'h0;
	end
	else
	begin
		if(start_int && button)
			flg<=1;
		else
		begin
		end
		
		if(ct!=3'h3 && flg)
		begin
			ct<=ct+3'h1;
		end
		else
		begin
			ct<=3'h0;
			flg<=0;
		end
	end
end

//next_pc
wire [31:0] base;
assign base = 32'h40;

always@(*)
begin
	if(RTI)
		next_pc=int_pc;
	else if(start_int)
		next_pc=(base+int_id)<<2;
	else if(pc_stall)
		next_pc=now_pc;
	else if(pc_jump)
		next_pc=target;
	else
		next_pc=now_pc+32'h4;
end

endmodule
