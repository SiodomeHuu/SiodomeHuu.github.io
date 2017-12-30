`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:42 05/30/2017 
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
	
	input [6:0] sw,
	input buttonpress,
	
	output [7:0] smg,
	output [3:0] sel,
	
	output [7:0] led
);





wire button;

butt u_butt(
	.clk(clk),
	.rst_n(rst_n),
	.buttonpress(buttonpress),
	.button(button)
);

wire [31:0] smgdata;

interface u_interface(
	.clk(clk),
	.rst_n(rst_n),
	.button(button),
	.sw(sw),
	.data(smgdata),
	.smg(smg),
	.sel(sel)
);


wire ir_to_int_syscall;
wire imem_to_int_RTI;

wire int_to_pc_start_int;
wire [31:0] int_to_pc_int_id;

wire int_to_pc_syscall;
wire int_to_pc_button;


wire [4:0] dmem_to_wb_regaddr3;
wire [4:0] wb_to_reg_regaddr3;
wire [31:0] wb_to_reg_delay_regdata;
wire wb_to_reg_reg_we;

interrupt u_interrupt(
	.clk(clk),
	.rst_n(rst_n),
	
	.buttonint(button),
	.syscall(ir_to_int_syscall),
	
	.RTI(imem_to_int_RTI),
	
	.to_syscall(int_to_pc_syscall),
	.to_button(int_to_pc_button),
	
	.start_int(int_to_pc_start_int),
	.int_id(int_to_pc_int_id)
);

wire [31:0] branch_to_pc_target;
wire pc_stall;
wire pc_jump;
wire [31:0] pc_to_imem_pc;



pc u_pc(
	.clk(clk),
	.rst_n(rst_n),
	
	.syscall(int_to_pc_syscall),
	.button(int_to_pc_button),
	
	.target(branch_to_pc_target),
	.int_id(int_to_pc_int_id),
	
	.start_int(int_to_pc_start_int),
	.RTI(imem_to_int_RTI),
	.pc_stall(pc_stall),
	.pc_jump(pc_jump),
	
	.pc(pc_to_imem_pc)
);


wire [31:0] imem_to_reg_pc;
wire [31:0] imem_to_reg_ir;

IMemModule u_IMemModule(
	.clk(clk),
	.rst_n(rst_n),
	.addr(pc_to_imem_pc),

	.pc(imem_to_reg_pc),
	.ir(imem_to_reg_ir)
);




wire ir_stall;
assign ir_stall = 0;
wire ir_bubble;



wire [31:0] reg_to_alu_pc;
wire [31:0] reg_to_alu_ir;
wire [4:0] reg_to_alu_regaddr1;
wire [4:0] reg_to_alu_regaddr2;
wire [4:0] reg_to_alu_regaddr3;
wire [31:0] reg_to_alu_alu_a;
wire [31:0] reg_to_alu_alu_b;
wire [31:0] reg_to_alu_swdata;
wire [4:0] reg_to_alu_op;
wire [5:0] reg_to_alu_optype;



IR_reg u_IR_reg(
	.clk(clk),
	.rst_n(rst_n),
	
	.pc(imem_to_reg_pc),
	.ir(imem_to_reg_ir),
	
	.is_int( buttonpress ), //int_to_pc_start_int ),
	
	.ir_stall(ir_stall),
	.ir_bubble(ir_bubble),
	
	
	//	Here are the vars from the fifth step
	.preg_we(wb_to_reg_reg_we),
	.pregaddr3(wb_to_reg_regaddr3),
	.pregvalue3(wb_to_reg_delay_regdata),
	// no need to know what value it is
	
	.next_pc(reg_to_alu_pc),
	.next_ir(reg_to_alu_ir),
	
	.regaddr1(reg_to_alu_regaddr1),
	.regaddr2(reg_to_alu_regaddr2),
	.regaddr3(reg_to_alu_regaddr3), // need to be written at posedge and distribute
	
	.alu_a(reg_to_alu_alu_a),
	.alu_b(reg_to_alu_alu_b), // REG_FILE or Imm outputs at posedge
	
	.swdata(reg_to_alu_swdata), // only valid in command sw, connect to reg2
	
	.op(reg_to_alu_op),
	.optype(reg_to_alu_optype), //posedge write here
	
	.RTI(imem_to_int_RTI),
	
	.syscall(ir_to_int_syscall)

);


wire alu_stall;
assign alu_stall=0;
wire alu_bubble;
assign alu_bubble=0;

wire [31:0] walu_out;
wire wflag; //immediate var

wire [4:0] alu_to_dmem_regaddr3;
wire [31:0] alu_to_dmem_alu_out;
wire alu_to_branch_flag;
wire [31:0] alu_to_dmem_swdata;

wire [31:0] alu_to_dmem_pc;
wire [31:0] alu_to_dmem_ir;
wire [5:0] alu_to_dmem_optype;


wire [4:0] alu_to_alu_bwregaddr;
wire [31:0] alu_to_alu_bwdata;
wire [4:0] bw_to_alu_bwregaddr;
wire [31:0] bw_to_alu_bwdata;

assign alu_to_alu_bwregaddr = alu_to_dmem_regaddr3;
assign alu_to_alu_bwdata = alu_to_dmem_alu_out;

assign bw_to_alu_bwregaddr = wb_to_reg_regaddr3;
assign bw_to_alu_bwdata = wb_to_reg_regdata;

wire alu_to_alu_valid;
wire dmem_to_alu_valid;

ALUmodule u_ALUmodule(
	.clk(clk),
	.rst_n(rst_n),

	.alu_stall(alu_stall),
	.alu_bubble(alu_bubble),
	//from previous process
	.pc(reg_to_alu_pc),
	.ir(reg_to_alu_ir),
	.regaddr1(reg_to_alu_regaddr1),
	.regaddr2(reg_to_alu_regaddr2),
	.regaddr3(reg_to_alu_regaddr3),
	.alu_a(reg_to_alu_alu_a),
	.alu_b(reg_to_alu_alu_b),
	.op(reg_to_alu_op),
	.optype(reg_to_alu_optype),
	
	.swdata(reg_to_alu_swdata),
	////////////////////////////////////////////////////////////////////////////////////////////
	//backword from alu answer
	.a_valid(alu_to_alu_valid),
	.a_bwregaddr(alu_to_alu_bwregaddr),
	.a_bw_data(alu_to_alu_bwdata),
	//backword from write back
	.b_valid(dmem_to_alu_valid),
	.b_bwregaddr(dmem_to_wb_regaddr3),
	.b_bw_data(bw_to_alu_bwdata),
	
	
	//
	.walu_out(walu_out),
	.wflag(wflag),
	
	// this output
	.to_regaddr3(alu_to_dmem_regaddr3),
	.alu_out(alu_to_dmem_alu_out), //this will connect to a_bwregaddr
	.flag(alu_to_branch_flag),
	.to_swdata(alu_to_dmem_swdata),
	//continue distributing
	.to_valid(alu_to_alu_valid),
	.to_pc(alu_to_dmem_pc),
	.to_ir(alu_to_dmem_ir),
	.to_optype(alu_to_dmem_optype)
	
	//.syscall(ir_to_int_syscall)
);


wire dmem_stall;
wire dmem_bubble;
wire [5:0] dmem_to_wb_optype;

wire [31:0] dmem_to_wb_outdata;

assign dmem_stall = 0;
assign dmem_bubble = 0;

DMemModule u_DMemModule(
	.clk(clk),
	.rst_n(rst_n),
	
	.dmem_stall(dmem_stall),
	.dmem_bubble(dmem_bubble),
	
	.pc(alu_to_dmem_pc),
	.ir(alu_to_dmem_ir),
	
	.regaddr3(alu_to_dmem_regaddr3),
	.alu_ans(alu_to_dmem_alu_out),
	.swdata(alu_to_dmem_swdata),
	
	.optype(alu_to_dmem_optype),
	.sw(sw),
	
	.to_optype(dmem_to_wb_optype),
	.to_regaddr3(dmem_to_wb_regaddr3),
	
	.outdata(dmem_to_wb_outdata),
	.smg(smgdata),
	.led(led)
);




wire [31:0] wb_to_reg_regdata;


WriteBack u_WriteBack(
	.clk(clk),
	.rst_n(rst_n),
	.ipvalid(alu_to_alu_valid),
	
	.regaddr3(dmem_to_wb_regaddr3),
	.regdata(dmem_to_wb_outdata),
	.optype(dmem_to_wb_optype),
	
	.to_valid(dmem_to_alu_valid),
	.to_regaddr3(wb_to_reg_regaddr3),
	.to_regdata(wb_to_reg_regdata),
	
	.delay_regdata(wb_to_reg_delay_regdata),
	
	.reg_we(wb_to_reg_reg_we)
);



branch u_branch(
	.clk(clk),
	.rst_n(rst_n),
	
	.optype(reg_to_alu_optype),
	
	.pc(reg_to_alu_pc),
	.ir(reg_to_alu_ir),
	
	.walu_out(walu_out),
	.wflag(wflag),
	
	.pcjump(pc_jump),
	.real_pc(branch_to_pc_target),
	.ir_bubble(ir_bubble)
);



endmodule
