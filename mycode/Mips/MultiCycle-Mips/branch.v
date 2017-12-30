`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:41 05/05/2017 
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
	input need_jmp,
	input b_or_j,
	input branch_flag,
	input [31:0] pc,
	input [15:0] imm,
	input [25:0] jimm,
	output reg pcmux,
	output reg [31:0] new_pc
);

reg [31:0] Imm;
reg [31:0] JImm;

always@(*)
begin
	Imm[1:0]=2'b0;
	JImm[1:0]=2'b0;
	Imm[17:2]=imm;
	JImm[27:2]=jimm;
	if(imm[15])
		Imm[31:18]=14'b1111111_1111111;
	else
		Imm[31:18]=14'h0;
	if(jimm[25])
		JImm[31:28]=4'hF;
	else
		JImm[31:28]=4'b0;
end


always@(*)
begin
	pcmux=0;
	if(need_jmp)
	begin
		if(b_or_j)
		begin
			if(branch_flag)
			begin
				new_pc=Imm+32'h4;
				pcmux=1;
			end
			else
				pcmux=0;
		end
		else
		begin
			new_pc=JImm+32'h4;
			pcmux=1;
		end
	end
end

endmodule
