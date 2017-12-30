`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:19:34 11/29/2016 
// Design Name: 
// Module Name:    timer 
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
module timer(
	input clk,
	input rst_n,
	input [7:0] sw,
	input [4:0] state,
	output timeover,
	output [7:0] resttime
);

reg [7:0] iresttime;

assign resttime=iresttime;

assign timeover = iresttime == 8'b0 ? 1 : 0;

always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
		iresttime <= 8'b0;
	else
	begin
		if(state == 5'd1) // wait for set
			iresttime <= sw;
		else if(state == 5'd3 && decen) //playing,decrease time
		begin
			if(iresttime[3:0] == 4'b0)
			begin
				if(iresttime[7:4]==4'b0)
				begin //pass
				end
				else
				begin
					iresttime[7:4] <= iresttime[7:4] - 4'd1;
					iresttime[3:0] <= 4'd9;
				end
			end
			else
				iresttime[3:0] <= iresttime[3:0] - 4'd1;
		end
		else
		begin
		end
	end
end

reg [31:0] deccount;
reg decen;

always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
	begin
		deccount <= 32'b0;
		decen <= 0;
	end
	else
	begin
		if(deccount == 32'd9999_9999)
		begin
			decen <= 1;
			deccount <= 32'b0;
		end
		else
		begin
			deccount <= deccount + 32'b1;
			decen <= 0;
		end
	end
end
endmodule
