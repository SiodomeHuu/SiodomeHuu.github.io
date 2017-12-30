`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:58:44 11/29/2016 
// Design Name: 
// Module Name:    muxer 
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
module muxer(
	input [4:0] state,
	input [15:0] delay,
	
	input [7:0] resttime,
	input [7:0] score,
	
	input timeover,
	input scorezero,
	output [15:0] data
);


wire [15:0] temp;
wire [15:0] halt;

assign temp[15:8] = scorezero == 1 ? 8'b0 : score[7:0];
assign temp[7:0] = timeover == 1 ? 8'b0 : resttime;


assign data = (state==5'd2 ? delay: temp );

endmodule
