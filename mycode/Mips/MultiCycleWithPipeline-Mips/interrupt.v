`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:07 05/25/2017 
// Design Name: 
// Module Name:    interrupt 
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
module interrupt(
	input clk,
	input rst_n,
	
	input buttonint,
	input syscall,
	
	input RTI,
	
	output reg to_syscall,
	output reg to_button,
	
	output reg start_int,
	output reg [31:0] int_id
);


always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		to_syscall<=0;
		to_button<=0;
	end
	else
	begin
		to_syscall<=syscall;
		to_button<=buttonint;
	end
end

reg has_int;

reg citai;



reg [15:0] count;
reg resetflag;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		count<=15'h0;
		resetflag<=0;
	end
	else if(has_int)
	begin
		if(count==15'd500)
		begin
			resetflag<=1;
			count<=15'd0;
		end
		else
		begin
			resetflag<=0;
			count<=count+15'h1;
		end
	end
	else
	begin
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		has_int<=0;
		start_int<=0;
		int_id<=0;
	end
	else if(!citai)
	begin
		if(buttonint)
		begin
			int_id<=32'h4;
			has_int<=1;
			start_int<=1;
		end
		else if(syscall)
		begin
			int_id<=32'h0;
			has_int<=1;
			start_int<=1;
		end
		else
		begin
		end
	end
	else
	begin
		if(RTI)
			has_int<=0;
		else if(resetflag)
			has_int<=0;
		else
			has_int<=citai;
		start_int<=0;
	end
end

always@(*)
begin
	citai=has_int;
end


endmodule
