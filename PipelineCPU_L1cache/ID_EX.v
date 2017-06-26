// ID_EX

module ID_EX ( clk,  
               rst,
			   stall,
               // input
				ID_Ins,
			   ID_Flush,
			   // WB
			   ID_MemtoReg,
			   ID_RegWrite,
			   // M
			   ID_MemRead,
			   ID_MemWrite,			   
			   // EX
			  // ID_Reg_imm,			
			   // pipe
			   ID_JumpCtrl,
			   ID_JalCtrl,
			   ID_LhCtrl,
			   ID_ShCtrl,
			   ID_Beq,
			   ID_Bne,
			   ID_ALUSrc,
			   ID_PC,
			   ID_ALUOp,			   
			   ID_Opcode,
			   ID_Funct,
			   ID_shamt,
			   ID_Rs_data,
			   ID_Rt_data,
			   ID_se_imm,
			   ID_WR_out,
			   ID_Rs,
			   ID_Rt,
			   // output
			   EX_Ins,
			   EX_MemtoReg,
			   EX_RegWrite,
			   // M
			   EX_MemRead,
			   EX_MemWrite,			  
			   // EX			  
			   // pipe
			   EX_JumpCtrl,
			   EX_JalCtrl,
			   EX_LhCtrl,
			   EX_ShCtrl,
			   EX_Beq,
			   EX_Bne,
			   EX_ALUSrc,
			   EX_PC,
			   EX_ALUOp,
			   EX_Opcode,
			   EX_Funct,
			   EX_shamt,
			   EX_Rs_data,
			   EX_Rt_data,
			   EX_se_imm,
			   EX_WR_out,
			   EX_Rs,
			   EX_Rt		   			   
			   );
	
	parameter pc_size = 32;			   
	parameter data_size = 32;
	
	input clk, rst,stall;
	input ID_Flush;
	
	// WB
	input ID_MemtoReg;
	input ID_RegWrite;
	// M
	input ID_MemWrite,ID_MemRead;
	
	// EX
	//input ID_Reg_imm;
	
	// pipe
	input [1:0] ID_JumpCtrl;
	input ID_JalCtrl,ID_LhCtrl,ID_ShCtrl,ID_Beq,ID_Bne,ID_ALUSrc;
    input [pc_size-1:0] ID_PC;
    input [1:0] ID_ALUOp;	
	input [5:0] ID_Opcode,ID_Funct;
    input [4:0] ID_shamt;
    input [data_size-1:0] ID_Rs_data,ID_Ins;
    input [data_size-1:0] ID_Rt_data;
    input [data_size-1:0] ID_se_imm;
    input [4:0] ID_WR_out;
    input [4:0] ID_Rs;
    input [4:0] ID_Rt;
	
	// WB
	output reg EX_MemtoReg;
	output reg EX_RegWrite;
	// M
	output reg EX_MemWrite,EX_MemRead;	
	// EX	
	// pipe
	output reg [1:0] EX_JumpCtrl;
	output reg EX_JalCtrl,EX_LhCtrl,EX_ShCtrl,EX_Beq,EX_Bne,EX_ALUSrc;
	output reg [pc_size-1:0] EX_PC;
	output reg [1:0] EX_ALUOp;
	output reg [5:0] EX_Opcode,EX_Funct;
	output reg [4:0] EX_shamt;
	output reg [data_size-1:0] EX_Rs_data,EX_Ins;
	output reg [data_size-1:0] EX_Rt_data;
	output reg [data_size-1:0] EX_se_imm;
	output reg [4:0] EX_WR_out;
	output reg [4:0] EX_Rs;
	output reg [4:0] EX_Rt;
	
	initial begin
		EX_MemtoReg=0;
		EX_RegWrite=0;
		EX_MemRead=0;
		EX_MemWrite=0;
		EX_JumpCtrl=0;
		EX_JalCtrl=0;
		EX_LhCtrl=0;
		EX_ShCtrl=0;
		EX_Beq=0;
		EX_Bne=0;
		EX_ALUSrc=0;
		EX_PC=0;
		EX_ALUOp=0;
		EX_Opcode=0;
		EX_Funct=0;
		EX_shamt=0;
		EX_Rs_data=0;
		EX_Rt_data=0;
		EX_se_imm=0;
		EX_WR_out=0;
		EX_Rs=0;
		EX_Rt=0;
		EX_Ins=0;
	end
	
	always @(negedge clk ) begin	
	
		if(rst)begin
			EX_MemtoReg <=0;
			EX_RegWrite <=0;
			EX_MemRead <=0;
			EX_MemWrite <=0;
			EX_JumpCtrl <=0;
			EX_JalCtrl <=0;
			EX_LhCtrl <=0;
			EX_ShCtrl <=0;
			EX_Beq <=0;
			EX_Bne <=0;
			EX_ALUSrc <=0;
			EX_PC <=0;
			EX_ALUOp <=0;
			EX_Opcode <=0;
			EX_Funct <=0;
			EX_shamt <=0;
			EX_Rs_data <=0;
			EX_Rt_data <=0;
			EX_se_imm <=0;
			EX_WR_out <=0;
			EX_Rs <=0;
			EX_Rt <=0;
			EX_Ins<=0;
		end
		else if(stall)begin
			EX_MemtoReg <= EX_MemtoReg;
			EX_RegWrite <= EX_RegWrite;
			EX_MemRead <= EX_MemRead;
			EX_MemWrite <= EX_MemWrite;
			EX_JumpCtrl <= EX_JumpCtrl;
			EX_JalCtrl <= EX_JalCtrl;
			EX_LhCtrl <= EX_LhCtrl;
			EX_ShCtrl <= EX_ShCtrl;
			EX_Beq <= EX_Beq;
			EX_Bne <= EX_Bne;
			EX_ALUSrc <= EX_ALUSrc;
			EX_PC <= EX_PC;
			EX_ALUOp <= EX_ALUOp;
			EX_Opcode <= EX_Opcode;
			EX_Funct <= EX_Funct;
			EX_shamt <= EX_shamt;
			EX_Rs_data <= EX_Rs_data;
			EX_Rt_data <= EX_Rt_data;
			EX_se_imm <= EX_se_imm;
			EX_WR_out <= EX_WR_out;
			EX_Rs <= EX_Rs;
			EX_Rt <= EX_Rt;
			EX_Ins <= EX_Ins;
		end
		else if(ID_Flush)begin
			EX_MemtoReg <=0;
			EX_RegWrite <=0;
			EX_MemRead <=0;
			EX_MemWrite <=0;
			EX_JumpCtrl <=0;
			EX_JalCtrl <=0;
			EX_LhCtrl <=0;
			EX_ShCtrl <=0;
			EX_Beq <=0;
			EX_Bne <=0;
			EX_ALUSrc <=0;
			EX_PC <=0;
			EX_ALUOp <=0;
			EX_Opcode <=0;
			EX_Funct <=0;
			EX_shamt <=0;
			EX_Rs_data <=0;
			EX_Rt_data <=0;
			EX_se_imm <=0;
			EX_WR_out <=0;
			EX_Rs <=0;
			EX_Rt <=0;
			EX_Ins<=0;
		end
		else begin
			EX_MemtoReg <= ID_MemtoReg;
			EX_RegWrite <= ID_RegWrite;
			EX_MemRead <= ID_MemRead;
			EX_MemWrite <= ID_MemWrite;
			EX_JumpCtrl <= ID_JumpCtrl;
			EX_JalCtrl <= ID_JalCtrl;
			EX_LhCtrl <= ID_LhCtrl;
			EX_ShCtrl <= ID_ShCtrl;
			EX_Beq <= ID_Beq;
			EX_Bne <= ID_Bne;
			EX_ALUSrc <= ID_ALUSrc;
			EX_PC <= ID_PC;
			EX_ALUOp <= ID_ALUOp;
			EX_Opcode <= ID_Opcode;
			EX_Funct <= ID_Funct;
			EX_shamt <= ID_shamt;
			EX_Rs_data <=ID_Rs_data;
			EX_Rt_data <=ID_Rt_data;
			EX_se_imm <= ID_se_imm;
			EX_WR_out <= ID_WR_out;
			EX_Rs <= ID_Rs;
			EX_Rt <= ID_Rt;
			EX_Ins<= ID_Ins;
		end
	
	end
	
endmodule










