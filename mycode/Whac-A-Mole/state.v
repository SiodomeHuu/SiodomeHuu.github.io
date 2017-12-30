`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:16:18 11/29/2016 
// Design Name: 
// Module Name:    state 
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
module state(
	input clk,
	input rst_n,
	input buttonpress,
	input delayover,
	input timeover,
	input scorezero,
	output [4:0] state
);

reg [4:0] curr_state;
reg [4:0] next_state;

//0 start
//1 wait for time set
//2 delay
//3 game start
//4 game halt

assign state = curr_state;

always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
		curr_state <= 5'b0;
	else
		curr_state <= next_state;
end



always@(*)
begin
	if(curr_state == 5'd0)
		next_state = 5'd1;
	else if(curr_state == 5'd1)
	begin
		if(buttonpress)
			next_state=5'd2;
		else
			next_state=5'd1;
	end
	else if(curr_state == 5'd2)
	begin
		if(delayover)
			next_state=5'd3;
		else
			next_state=5'd2;
	end
	else if(curr_state == 5'd3)
	begin
		if(timeover||scorezero)
			next_state=5'd4;
		else
			next_state=5'd3;
	end
	else
		next_state=5'd4;
end
endmodule
