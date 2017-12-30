`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:26:39 04/17/2017 
// Design Name: 
// Module Name:    REG_MUXER 
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
module REG_MUXER(
	input [4:0] reg1,
	input [4:0] reg2,
	input [4:0] reg3,

	input Wr,
	input [1:0] optype,
	
	output reg [4:0] regaddr1,
	output reg [4:0] regaddr2,
	output reg [4:0] regaddr3
);

always@(*)
begin
	if(optype==2'h0) //r-type
	begin
		regaddr1=reg1;
		regaddr2=reg2;
		regaddr3=reg3;
	end
	else if(optype==2'h1) //i-type
	begin
		if(Wr)
		begin
			regaddr1=reg1;
			regaddr2=reg2;
		end
		else
		begin
			regaddr1=reg1;
			regaddr3=reg2;
		end
	end

end

endmodule
