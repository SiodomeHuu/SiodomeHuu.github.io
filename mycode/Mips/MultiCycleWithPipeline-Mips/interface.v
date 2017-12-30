`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:07:18 06/05/2017 
// Design Name: 
// Module Name:    interface 
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
module interface(
	input clk,
	input rst_n,
	
	input button,
	
	input [6:0] sw,
	
	input [31:0] data,
	
	output reg [7:0] smg,
	output reg [3:0] sel
 );




reg [1:0] tr;

reg [31:0] sw_count;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		sw_count<=32'd0;
		tr<=2'b00;
	end
	else
	begin
		if(sw_count==32'd9) //99)
		begin
			sw_count<=32'd0;
			tr<=tr+2'h1;
		end
		else
		begin
			sw_count<=sw_count+32'd1;
		end
	end
end

always@(*)
begin
	case(tr)
		2'h0:
			sel=4'b1110;
		2'h1:
			sel=4'b1101;
		2'h2:
			sel=4'b1011;
		2'h3:
			sel=4'b0111;
	default:
		sel=4'b1111;
	endcase
end

reg [3:0] sgnum;


always@(*)
begin
	
	if(sw[6])
	begin
		if(tr==2'h0)
			sgnum=data[19:16];
		else if(tr==2'h1)
			sgnum=data[23:20];
		else if(tr==2'h2)
			sgnum=data[27:24];
		else if(tr==2'h3)
			sgnum=data[31:28];
		else
		begin
		end
	end
	else
	begin
		if(tr==2'h0)
			sgnum=data[3:0];
		else if(tr==2'h1)
			sgnum=data[7:4];
		else if(tr==2'h2)
			sgnum=data[11:8];
		else if(tr==2'h3)
			sgnum=data[15:12];
		else
		begin
		end
	end
end


always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		smg<=8'h0;
	end
	else
	begin
		case(sgnum)
			4'h0: smg <= 8'b0000_0011;
			4'h1: smg <= 8'b1001_1111;
			4'h2: smg <= 8'b0010_0101;
			4'h3: smg <= 8'b0000_1101;
			4'h4: smg <= 8'b1001_1001;
			4'h5: smg <= 8'b0100_1001;
			4'h6: smg <= 8'b0100_0001;
			4'h7: smg <= 8'b0001_1111;
			4'h8: smg <= 8'b0000_0001;
			4'h9: smg <= 8'b0000_1001;
			4'hA: smg <= 8'b0001_0001;
			4'hb: smg <= 8'b1100_0001;
			4'hC: smg <= 8'b0110_0011;
			4'hd: smg <= 8'b1000_0101;
			4'hE: smg <= 8'b0110_0001;
			4'hF: smg <= 8'b0111_0001;
		default:
			smg<=8'b0;
		endcase
	end
end


endmodule
