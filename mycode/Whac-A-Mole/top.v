`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:09:59 11/29/2016 
// Design Name: 
// Module Name:    top 
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
module top(
	input clk,
	input rst_n,
	input [7:0] sw,
	input buttonset,
	
	output [7:0] led,
	output [7:0] smg,
	output [3:0] sel
);

wire buttonpress;

wire [15:0] data;

wire [4:0] state;

wire [15:0] delay;

wire delayover;

wire [7:0] resttime;

wire [7:0] score;
wire [7:0] scoreBCD;

wire timeover;
wire scorezero;

button u_button(
.clk(clk),
.rst_n(rst_n),
.button(buttonset),
.buttonpress(buttonpress)
);

state u_state(
.clk(clk),
.rst_n(rst_n),
.buttonpress(buttonpress),
.delayover(delayover),
.timeover(timeover),
.scorezero(scorezero),
.state(state)
);

gamelogic u_gamelogic(
.clk(clk),
.rst_n(rst_n),
.state(state),
.sw(sw),
.score(score),
.scorezero(scorezero),
.led(led)
);

delay u_delay(
.clk(clk),
.rst_n(rst_n),
.state(state),
.data(delay),
.delayover(delayover)
);

timer u_timer(
.clk(clk),
.rst_n(rst_n),
.sw(sw),
.state(state),
.timeover(timeover),
.resttime(resttime)
);

hex_8421BCD u_hex_8421BCD(
.hex(score),
.BCD(scoreBCD)
);


muxer u_muxer(
.state(state),
.delay(delay),
.resttime(resttime),
.score(scoreBCD),
.timeover(timeover),
.scorezero(scorezero),
.data(data)
);

code u_code(
.clk(clk),
.rst_n(rst_n),
.data(data),
.smg(smg),
.sel(sel)
);

endmodule
