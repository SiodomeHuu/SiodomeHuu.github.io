`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:08:56 06/05/2017 
// Design Name: 
// Module Name:    butt 
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
module butt(
	input clk,
	input rst_n,
	input buttonpress,
	
	output button
);

assign button = buttonpress;// valid; // buttonpress; //valid;


reg [31:0] cycle_count;

reg valid;
reg sgcycle;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		valid<=0;
		cycle_count<=0;
		sgcycle<=0;
	end
	else
	begin
		if(buttonpress)
		begin
			if(cycle_count==32'd999)
			begin
				if(!sgcycle)
				begin
					valid<=1;
					sgcycle<=1;
				end
				else
				begin
					valid<=0;
				end
			end
			else
			begin
				cycle_count<=cycle_count+32'h1;
			end
		end
		else
		begin
			cycle_count<=32'h0;
			valid<=0;
			sgcycle<=0;
		end
	end

end


endmodule
