`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:05:50 03/14/2017 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
input signed [31:0] alu_a,
input signed [31:0] alu_b,
input [4:0] alu_op,
output [31:0] alu_out,
output reg flag
);


assign alu_out = alu_out2;


reg [31:0] alu_out2;

always @(*)
begin
	case(alu_op)
		5'h0:
			alu_out2=32'b0;
		5'h1:
			alu_out2=alu_a+alu_b;
		5'h2:
			alu_out2=alu_a-alu_b;
		5'h3:
			alu_out2=alu_a&alu_b;
		5'h4:
			alu_out2=alu_a|alu_b;
		5'h5:
			alu_out2=alu_a^alu_b;
		5'h6:
			alu_out2=~(alu_a|alu_b);
		5'h7: //bgtz
			begin
				if(alu_a[31]==0 && (!(alu_a==32'b0)))
					flag=1;
				else
					flag=0;
			end
		default:
			alu_out2=32'hcccccccc;
	endcase
end


endmodule
