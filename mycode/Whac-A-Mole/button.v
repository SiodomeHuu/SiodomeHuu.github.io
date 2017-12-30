`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:11:08 11/29/2016 
// Design Name: 
// Module Name:    button 
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
module button(
	input clk,
	input rst_n,
	input button,
	output reg buttonpress
);


reg [19:0] count;
reg en;
reg update;


always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
	begin
		count <= 20'h0;
		en<=1'b0;
		update <= 1'b0;
		buttonpress <= 1'b0;
	end
	else
	begin
		buttonpress <= 1'b0;
		if(button)
		begin
			if(count == 20'd9_99999)
			begin
				en <= 1'b1;
			end
			else
			begin
				count <= count + 20'h1;
				en <= 1'b0;
			end
		end
		else
		begin
			count <= 20'h0;
			en <= 1'b0;
			update <= 1'b0;
		end
		if(en && !update)
		begin
			buttonpress <= 1'b1;
			update <= 1'b1;
		end
	end
end
endmodule
