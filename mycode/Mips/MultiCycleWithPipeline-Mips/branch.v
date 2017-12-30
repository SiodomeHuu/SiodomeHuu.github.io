`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:47:13 05/29/2017 
// Design Name: 
// Module Name:    branch 
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
module branch(
	input clk,
	input rst_n,
	
	input [5:0] optype,
	
	input [31:0] pc,
	input [31:0] ir,
	
	input [31:0] walu_out,
	input wflag,
	
	output reg pcjump,
	output reg [31:0] real_pc,
	output reg ir_bubble
	
);


wire [31:0] tempdd;
assign tempdd = {$signed(ir[15:0]),2'h0};


reg ir_bubble_two;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		ir_bubble_two<=0;
	end
	else
	begin
		if(!ir_bubble_two && ir_bubble==1)
			ir_bubble_two<=1;
		else
			ir_bubble_two<=0;
	end
end

always@(*)
begin
	if(optype==6'h12 && wflag) //pc=pc+offset
	begin
		ir_bubble=1;
		real_pc = pc+tempdd+32'h4; //{$signed(ir[15:0]),2'h0};
	end
	else if(optype==6'h10 || optype==6'h11) //jump
	begin
		real_pc = walu_out;
		ir_bubble=1;
	end
	
	else if(optype==6'h21)
	begin
		ir_bubble=1;
	end
	
	else
	begin
		if(!ir_bubble_two)
			ir_bubble=0;
		else
			ir_bubble=1;
	end
end

always@(*)
begin
	if((optype==6'h12 && wflag) || optype==6'h10 || optype==6'h11)
	begin
		pcjump=1;
	end
	else
		pcjump=0;
end


endmodule
