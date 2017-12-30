`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:22:12 05/29/2017 
// Design Name: 
// Module Name:    DMemModule 
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
module DMemModule(
	input clk,
	input rst_n,
	
	
	input dmem_stall,
	input dmem_bubble,
	
	input [31:0] pc,
	input [31:0] ir,
	
	input [4:0] regaddr3,
	input [31:0] alu_ans,
	
	input [31:0] swdata,
	
	input [5:0] optype,
//	
	input [6:0] sw,
//
	output reg [5:0] to_optype,
	output reg [4:0] to_regaddr3,
	
	output [31:0] outdata,
	
	output reg [31:0] smg,
	output reg [7:0] led
);



wire we;

wire [31:0] douta;

assign we = optype==6'h14 ? 1 : 0;

DMem u_DMem(
	clk,
	we,
	alu_ans[6:2],
	swdata,
	douta
);


reg [6:0] local_sw;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		smg<=32'h0;
		led<=8'hFD;
		local_sw<=7'h0;
	end
	else
	begin
		local_sw<=sw;
		if(we && alu_ans==32'h78 ) //smg
		begin
			smg<=swdata;
		end
		else if(we && alu_ans==32'h7C ) //led
		begin
			led<=swdata[7:0];
		end
		else
		begin
		end
	end
end




reg [31:0] temp_aluans;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		temp_aluans<=32'hCCCC_CCCC;
	else if(!dmem_stall)
		temp_aluans<=alu_ans;
	else
	begin
	end
end

/*
reg [31:0] local_alu_ans;

always@(*)
begin
	if((to_optype==13) && alu_ans==32'h74)
		local_alu_ans=$unsigned(local_sw);
	else if(to_optype==13)
		local_alu_ans=douta;
	else
		local_alu_ans=alu_ans;
end
*/


reg [31:0] local_alu_ans;
reg [5:0] local_optype;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		local_alu_ans<=32'h0;
		local_optype<=6'h3f;
	end
	else
	begin
		local_alu_ans<=alu_ans;
		local_optype<=optype;
	end
end

/*
always@(*)
begin
	if(local_optype==6'h13 && local_alu_ans==32'h74)
	begin
		outdata=$unsigned(local_sw);
	end
	else if(local_optype==6'h13)
	begin
		outdata=douta;
	end
	else
		outdata=local_alu_ans;
end
*/
reg [1:0] which;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		which<=2'h0;
	else
		if(optype==6'h13 && alu_ans==32'h74)
			which<=2'h1;
		else if(optype==6'h13)
			which<=2'h2;
		else
			which<=2'h3;
end

/*
always@(*)
begin
	if(which==2'h1)
		outdata=$unsigned(local_sw);
	else if(which==2'h2)
		outdata=douta;
	else
		outdata=local_alu_ans;
end
*/

assign outdata = which==2'h1 ? $unsigned(local_sw) : (which==2'h2 ? douta : local_alu_ans);

/*
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		//local_alu_ans<=32'h0;
		outdata<=32'h0;
	else if((optype==6'h13) && alu_ans==32'h74)
	begin
		outdata<=$unsigned(local_sw);//local_alu_ans;
	end
	else if(optype==6'h13)
	begin
		outdata<=douta;
	end
	else
	begin
		outdata<=alu_ans;
	end
end
*/


//assign outdata = (optype == 6'h13) ? (  local_alu_ans== 32'h74 ? $unsigned(local_sw) : douta) : local_alu_ans;//temp_aluans;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		to_optype<=6'h3F;
		to_regaddr3<=5'h0;
	end
	else if(dmem_bubble)
	begin
		to_optype<=6'h3F;
	end
	else if(!dmem_stall)
	begin
		to_optype<=optype;
		to_regaddr3<=regaddr3;
	end
	else
	begin
	end
end

endmodule
