`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:35:00 11/30/2016 
// Design Name: 
// Module Name:    hex_8421BCD 
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
module hex_8421BCD(
	input [7:0] hex,
	output [7:0] BCD
);

wire [3:0] gw;
wire [3:0] bw;

wire [3:0] linshi;

wire jw1;
wire jw2;

wire [3:0] hex_;
wire [3:0] _hex;

assign linshi = (
	hex[7:4] == 4'h1 ? 4'd6 :(
		hex[7:4] == 4'h2 ? 4'd2 : (
			hex[7:4] == 4'h3 ? 4'd8 : (
				hex[7:4] == 4'h4 ? 4'd4 : (
					hex[7:4] == 4'h5 ? 4'd0 : (
						hex[7:4] == 4'h6 ? 4'd6 : 4'd0
					)
				)
			)
		)
	)
);

assign jw1 = hex[3:0] > 4'd9 ? 1 : 0;
assign hex_ = (jw1 == 1 ? hex[3:0] - 4'd10 : hex[3:0]);

wire [7:0] ystemp;
assign ystemp = hex_ + linshi;

assign jw2 = ystemp > 8'd9 ? 1 : 0;

wire [7:0] yunsuantemp;

assign yunsuantemp = hex_ + linshi - 8'd10;

assign BCD[3:0] = (jw2 == 1 ? yunsuantemp[3:0] : hex_ + linshi);

assign _hex = (
	hex[7:4] == 4'h0 ? 4'd0 : (
		hex[7:4] == 4'h1 ? 4'd1 : (
			hex[7:4] == 4'h2 ? 4'd3 : (
				hex[7:4] == 4'h3 ? 4'd4: (
					hex[7:4] == 4'h4 ? 4'd6 : (
						hex[7:4] == 4'h5 ? 4'd8 : (
							hex[7:4] == 4'h6 ? 4'd9 : 4'd0
						)
					)
				)
			)
		)
	)
) + jw1 + jw2;

assign BCD[7:4] = _hex;
endmodule
