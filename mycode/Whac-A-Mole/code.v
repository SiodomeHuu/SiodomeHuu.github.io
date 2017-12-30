`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:22:57 11/29/2016 
// Design Name: 
// Module Name:    code 
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
module code(
	input clk,
	input rst_n,
	input [15:0] data,
	output reg [7:0] smg,
	output [3:0] sel
);

reg [3:0] isel;
reg [19:0] selcount;
reg selen;

reg [1:0] temp;
reg [3:0] num;

assign sel = isel;

always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
	begin
		selcount <= 20'd0;
		selen <= 0;
	end
	else if(selcount == 20'd99_999)
	begin
		selcount <= 20'd0;
		selen <= 1;
	end
	else
	begin
		selcount <= selcount + 20'h1;
		selen <= 0;
	end
end

always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
	begin
		isel <= 4'b1111;
		smg <= 8'b1111_1111;
		temp <= 2'b00;
	end
	else
	begin
		if(selen)
		begin
			case(temp)
				2'h0:
				begin
					isel<=4'b1110;
					num<=data[3:0];
				end
				2'h1:
				begin
					isel<=4'b1101;
					num<=data[7:4];
				end
				2'h2: 
				begin
					isel<=4'b1011;
					num<=data[11:8];
				end
				2'h3:
				begin
					isel<=4'b0111;
					num<=data[15:12];
				end
				default:
				begin
					isel<=4'b1111;
					num<=4'hF;
				end
			endcase
			temp <= temp+1;
		end
		case(num)
			4'h0: smg = 8'b0000_0011;
			4'h1: smg = 8'b1001_1111;
			4'h2: smg = 8'b0010_0101;
			4'h3: smg = 8'b0000_1101;
			4'h4: smg = 8'b1001_1001;
			4'h5: smg = 8'b0100_1001;
			4'h6: smg = 8'b0100_0001;
			4'h7: smg = 8'b0001_1111;
			4'h8: smg = 8'b0000_0001;
			4'h9: smg = 8'b0000_1001;
			4'hA: smg = 8'b0011_1001; //character:o
			default: smg = 8'b1111_1111;
		endcase
	end
end


endmodule
