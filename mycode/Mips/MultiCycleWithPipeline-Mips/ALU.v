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

//0 nop
//1 +
//2 -
//3 &
//4 |
//5 ^
//6 ~|
//7 alu_a>0?
//8 alu_a>=0?
//9 alu_a<0?
//A alu_a<=0?
//B alu_a==alu_b?
//C alu_a!=alu_b?
//D sll
//E srl
//F sra
//10 lui
//11 li
//20 output_a
//21 output_b

reg [31:0] alu_out2;

reg [31:0] alutp;

always @(*)
begin
	flag=0;
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
		5'h8: //bgez
			begin
				if(alu_a[31]==0)
					flag=1;
				else
					flag=0;
			end

		5'h9: //bltz
			begin
				if(alu_a[31]==1)
					flag=1;
				else
					flag=0;
			end
			
		5'hA: //blez
			begin
				if(alu_a[31]==1 || (alu_a==32'b0))
					flag=1;
				else
					flag=0;
			end		
			
		5'hB: //beq
			begin
				if(alu_a==alu_b)
					flag=1;
				else
					flag=0;
			end
		5'hC: //bne
			begin
				if(alu_a==alu_b)
					flag=0;
				else
					flag=1;
			end
		5'hD: //shift left logical
			alu_out2=alu_a << alu_b;
		5'hE: //shift right logical
			alu_out2=alu_a>>alu_b;
		5'hF: //shift right ar??
			alu_out2=alu_a>>>alu_b;
		5'h1E: //clo
		begin
			alutp=~(alu_a);
			if(alutp[31:0]==32'b0)
				alu_out2=32'd32;
			else if(alutp[31:1]==31'b0)
				alu_out2=32'd31;
			else if(alutp[31:2]==30'b0)
				alu_out2=32'd30;
			else if(alutp[31:3]==29'b0)
				alu_out2=32'd29;
			else if(alutp[31:4]==28'b0)
				alu_out2=32'd28;
			else if(alutp[31:5]==27'b0)
				alu_out2=32'd27;
			else if(alutp[31:6]==26'b0)
				alu_out2=32'd26;
			else if(alutp[31:7]==25'b0)
				alu_out2=32'd25;
			else if(alutp[31:8]==24'b0)
				alu_out2=32'd24;
			else if(alutp[31:9]==23'b0)
				alu_out2=32'd23;
			else if(alutp[31:10]==22'b0)
				alu_out2=32'd22;
			else if(alutp[31:11]==21'b0)
				alu_out2=32'd21;
			else if(alutp[31:12]==20'b0)
				alu_out2=32'd20;
			else if(alutp[31:13]==19'b0)
				alu_out2=32'd19;
			else if(alutp[31:14]==18'b0)
				alu_out2=32'd18;
			else if(alutp[31:15]==17'b0)
				alu_out2=32'd17;
			else if(alutp[31:16]==16'b0)
				alu_out2=32'd16;
			else if(alutp[31:17]==15'b0)
				alu_out2=32'd15;
			else if(alutp[31:18]==14'b0)
				alu_out2=32'd14;
			else if(alutp[31:19]==13'b0)
				alu_out2=32'd13;
			else if(alutp[31:20]==12'b0)
				alu_out2=32'd12;
			else if(alutp[31:21]==11'b0)
				alu_out2=32'd11;
			else if(alutp[31:22]==10'b0)
				alu_out2=32'd10;
			else if(alutp[31:23]==9'b0)
				alu_out2=32'd9;
			else if(alutp[31:24]==8'b0)
				alu_out2=32'd8;
			else if(alutp[31:25]==7'b0)
				alu_out2=32'd7;
			else if(alutp[31:26]==6'b0)
				alu_out2=32'd6;
			else if(alutp[31:27]==5'b0)
				alu_out2=32'd5;
			else if(alutp[31:28]==4'b0)
				alu_out2=32'd4;
			else if(alutp[31:29]==3'b0)
				alu_out2=32'd3;
			else if(alutp[31:30]==2'b0)
				alu_out2=32'd2;
			else if(alutp[31]==1'b0)
				alu_out2=32'd1;
			else
				alu_out2=32'd0;
		end
		5'h1F: //clz
		begin
			alutp=alu_a;
			if(alutp[31:0]==32'b0)
				alu_out2=32'd32;
			else if(alutp[31:1]==31'b0)
				alu_out2=32'd31;
			else if(alutp[31:2]==30'b0)
				alu_out2=32'd30;
			else if(alutp[31:3]==29'b0)
				alu_out2=32'd29;
			else if(alutp[31:4]==28'b0)
				alu_out2=32'd28;
			else if(alutp[31:5]==27'b0)
				alu_out2=32'd27;
			else if(alutp[31:6]==26'b0)
				alu_out2=32'd26;
			else if(alutp[31:7]==25'b0)
				alu_out2=32'd25;
			else if(alutp[31:8]==24'b0)
				alu_out2=32'd24;
			else if(alutp[31:9]==23'b0)
				alu_out2=32'd23;
			else if(alutp[31:10]==22'b0)
				alu_out2=32'd22;
			else if(alutp[31:11]==21'b0)
				alu_out2=32'd21;
			else if(alutp[31:12]==20'b0)
				alu_out2=32'd20;
			else if(alutp[31:13]==19'b0)
				alu_out2=32'd19;
			else if(alutp[31:14]==18'b0)
				alu_out2=32'd18;
			else if(alutp[31:15]==17'b0)
				alu_out2=32'd17;
			else if(alutp[31:16]==16'b0)
				alu_out2=32'd16;
			else if(alutp[31:17]==15'b0)
				alu_out2=32'd15;
			else if(alutp[31:18]==14'b0)
				alu_out2=32'd14;
			else if(alutp[31:19]==13'b0)
				alu_out2=32'd13;
			else if(alutp[31:20]==12'b0)
				alu_out2=32'd12;
			else if(alutp[31:21]==11'b0)
				alu_out2=32'd11;
			else if(alutp[31:22]==10'b0)
				alu_out2=32'd10;
			else if(alutp[31:23]==9'b0)
				alu_out2=32'd9;
			else if(alutp[31:24]==8'b0)
				alu_out2=32'd8;
			else if(alutp[31:25]==7'b0)
				alu_out2=32'd7;
			else if(alutp[31:26]==6'b0)
				alu_out2=32'd6;
			else if(alutp[31:27]==5'b0)
				alu_out2=32'd5;
			else if(alutp[31:28]==4'b0)
				alu_out2=32'd4;
			else if(alutp[31:29]==3'b0)
				alu_out2=32'd3;
			else if(alutp[31:30]==2'b0)
				alu_out2=32'd2;
			else if(alutp[31]==1'b0)
				alu_out2=32'd1;
			else
				alu_out2=32'd0;
		end
		5'h10: //lui
			begin
				alu_out2[31:16]=alu_b[15:0];
				alu_out2[15:0]=alu_a[15:0];
			end
		5'h11: //li
			begin
				alu_out2[31:16]=alu_a[31:16];
				alu_out2[15:0]=alu_b[15:0];
			end
		5'h12: //output_a
			alu_out2=alu_a;
		5'h13:
			alu_out2=alu_b;
		default:
			alu_out2=32'hcccccccc;
	endcase
end


endmodule
