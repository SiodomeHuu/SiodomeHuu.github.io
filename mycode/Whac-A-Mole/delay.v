`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:55:29 11/29/2016 
// Design Name: 
// Module Name:    delay 
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
module delay(
	input clk,
	input rst_n,
	input [4:0] state,
	output reg [15:0] data,
	output delayover
);

reg [31:0] delaycount;
reg idelayover;

assign delayover=idelayover;

always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
	begin
		delaycount <= 32'b0;
		idelayover <= 0;
		data <= 16'hFFFF;
	end
	else
	begin
		if(delaycount == 32'd0)
			data <= 16'h3FFF;
		else if(delaycount == 32'd1_0000_0000)
			data <= 16'h2FFF;
		else if(delaycount == 32'd2_0000_0000)
			data <= 16'h1FFF;
		else if(delaycount == 32'd3_0000_0000)
			data <= 16'h9AFF;
		else if(delaycount == 32'd4_0000_0000)
			idelayover <= 1;
		else
		begin
		end
		if(~idelayover)
			delaycount <= delaycount + 32'h1;
	end
end
endmodule
