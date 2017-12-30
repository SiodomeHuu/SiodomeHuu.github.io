`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:58:27 04/17/2017 
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
	input [31:0] now_addr,
	input br,
	input j_or_b,
	input regnzp,
	input [31:0] offset,
	output reg pcmux,
	output reg [31:0] addr
);

reg [31:0] tpof;

always@(*)
begin
	if(br==0)
	begin
		pcmux=0;
	end
	else
	begin
		tpof=offset<<2;
		
		if(j_or_b==1)
		begin
			addr=tpof;
			pcmux=1;
		end
		else
		begin
			if(regnzp)
			begin
				addr=now_addr+tpof+32'h4;
				pcmux=1;
			end
			else
				pcmux=0;
		end	
	end
end

endmodule
