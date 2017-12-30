`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:41:17 11/30/2016 
// Design Name: 
// Module Name:    logic 
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
module gamelogic(
	input clk,
	input rst_n,
	input [4:0] state,
	input [7:0] sw,
	output reg  scorezero,
	output [8:0] score,
	output [7:0] led
);

reg [7:0] target_sw;

reg [7:0] iscore;

assign score = iscore;
assign led = target_sw;


reg [31:0] a;

wire [2:0] rand;
wire [31:0] _A;
wire [31:0] _B;
assign _A = 32'd214013;
assign _B = 32'd2531011;
assign rand = a[2:0];

always@(posedge clk or posedge rst_n) //rand func
begin
	if(rst_n)
		a <= sw;
	else
		a <= (a*_A+_B)>>16 & 16'h7FFFF;
end



always@(posedge clk or posedge rst_n) //logic func
begin
	if(rst_n)
	begin
		target_sw <= sw;
		dishu_en <= 1;
		scorecount_en <= 0;
	end
	else
	begin
		if(state == 5'd1)
		begin
			target_sw <= sw;
		end
		if(next_dishu && state == 5'd3)
		begin
			target_sw[ rand ] <= !target_sw[ rand ];
			dishu_en <= 0;
			scorecount_en <= 1;
		end
		else if(next && state == 5'd3)
		begin		
			dishu_en <= 1;
			scorecount_en <= 0;
		end
	end
end


reg dishu_en;
reg [31:0] rdcount;
reg next_dishu;

always@(posedge clk or posedge rst_n)  //delay after punch
begin
	if(rst_n || !dishu_en)
	begin
		rdcount <= 32'b0;
		next_dishu <= 0;
	end
	else
	begin
		if(rdcount == 32'd3999_9999)
		begin
			rdcount <= 32'b0;
			next_dishu <= 1;
		end
		else
		begin
			rdcount <= rdcount + 32'd1;
			next_dishu <= 0;
		end
	end
end

reg scorecount_en;
reg [63:0] scorecount;
reg next;
always@(posedge clk or posedge rst_n) //count time and evaluate score
begin
	if(rst_n)
	begin
		scorecount <= 64'b0;
		iscore <= 8'd50;
		next <= 0;
		scorezero <= 0;
	end
	else if(!scorecount_en)
	begin
		scorecount <= 64'b0;
		next <= 0;
	end
	else if(state == 5'd3)
	begin
		if(sw == target_sw)
		begin
			//pass?
			if(scorecount < 64'd1500_0000) //150ms +2
				iscore <= (iscore > 8'd96 ?  8'd99 : iscore + 8'd2);
			else if(scorecount < 64'd5000_0000) //500ms +1
				iscore <= (iscore > 8'd97 ?  8'd99 : iscore + 8'd1);
//			else if(scorecount < 32'd10000_0000) //1000ms 0
//				iscore <= iscore;
			else if(scorecount < 64'd15000_0000) //1.5s -3
			begin
				if(iscore < 8'd3)
				begin
					iscore <= 0;
					scorezero <= 1;
				end
				else
					iscore <= iscore - 8'd3; 
			end
			else if(scorecount < 64'd19000_0000) //+0.5s -5 score
			begin
				if(iscore < 8'd5)
				begin
					iscore <= 0;
					scorezero <= 1;
				end
				else
					iscore <= iscore - 8'd5;
			end
			else
			begin
			end
			next <= 1;
			scorecount <= 64'b0;
		end
		else
		begin
			if(scorecount > 64'd19000_0000)
			begin
				if(iscore < 8'd4)
				begin
					iscore <= 0;
					scorezero <= 1;
				end
				else
				begin
					scorecount <= 64'd14000_0000;
					iscore <= iscore - 8'd3;
				end
			end
			else
			begin
				scorecount <= scorecount + 64'b1;
			end
			next <= 0;
		end
	end
	else
	begin
	end
end


endmodule
