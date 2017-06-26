
// top

module core (
			  clk,
              rst,
			  // Instruction Cache
			  IC_stall,
			  IC_Address,
              Instruction,
			  // Data Cache
			  DC_stall,
			  DC_Address,
			  DC_Read_enable,
			  DC_Write_enable,
			  DC_Write_Data,
			  DC_Read_Data
			  );

	parameter data_size = 32;
	parameter mem_size = 16;
	parameter pc_size = 18;
	
	input  clk, rst;
	
	// Instruction Cache
	input  IC_stall;
	//output [mem_size-1:0] IC_Address;
	input  [data_size-1:0] Instruction;
	
	// Data Cache
	input  DC_stall;
	output [mem_size-1:0] DC_Address;
	output DC_Read_enable;
	output DC_Write_enable;
	output [data_size-1:0] DC_Write_Data;
    input  [data_size-1:0] DC_Read_Data;
	
	//If IC stall and DC stall ,stall CPU
	//wire stall;	
	//assign stall=(IC_stall || DC_stall);
	
	//-------------wire declaration-----------
	
	// PC out;
	wire  [data_size-1:0] PCin;
	wire  [data_size-1:0] PCout;
	
	// PC+4 out;
	wire  [data_size-1:0]  PC4Out,PC8Out;
	
	// control unit output
	wire  [1:0]  ALUOp;
	wire  [1:0]  JumpCtrl;	
	wire  RegDst,BranchEq,BranchNeq,MemRead,MemToReg,MemWrite, ALUSrc ,RegWrite ,JalCtrl ,LhCtrl, ShCtrl ; 
	
	//  5bit mux for RegDstMux 5bit
	wire  [4:0]	 RegDstMuxOut;
	
	//JalRegMuxOut Output is to select WriteRegister, RegDstMuxOut(Rt or Rs) or R[31]=> $ra  
	wire  [4:0] JalRegMuxOut;//5bit
	
	// Regfile Output
	wire  [data_size-1:0] Read_data_1,Read_data_2;
	
	//ALUSrc Mux Output 
	wire  [data_size-1:0] ALUSrcMuxOut;
	
	//ALUControl Output
	wire  [3:0] ALUCtrlOut;
	
	//ALU Output
	wire  [data_size-1:0] ALUOutput;
	wire  Zero;	
	
	// branch logic 
	wire  [data_size-1:0] signExtendOut; 
	wire  [data_size-1:0] branchOffset; 
	wire  [data_size-1:0] branchAddress; // branchTarget	
	wire  Beq,Bne,Branch;
	
	// jumpAddress
	wire [data_size-1:0] jumpAddress;
	
	//sh Mux and shsignExtendOut
	wire  [data_size-1:0] shsignExtendOut;
	wire  [data_size-1:0] shMuxOut;		
	
	//lh Mux and lhsignExtendOut
	wire  [data_size-1:0] lhsignExtendOut;
	wire  [data_size-1:0] lhMuxOut;	
	
	//MemToReg
	wire  [data_size-1:0] MemToRegMuxOut;
	
	//JalMuxOut 
	wire  [data_size-1:0] JalMuxOut;
	
	//--------Pipeline wire----------
	
	wire stall;
	assign stall=(IC_stall || DC_stall);
	
	output [mem_size-1:0] IC_Address;
	//IC_Address 16 bit
	assign IC_Address = PCout[17:2];
	
	//IF_ID
	wire [data_size-1:0]  IF_Ins,ID_Ins,EX_Ins,M_Ins,WB_Ins,ID_PC4;
	
	assign IF_Ins=Instruction;	
	
	//HDU
	wire PCWrite,IF_Write,IF_Flush,ID_Flush ;
	
	//ID_EX
	wire EX_MemtoReg;
	wire EX_RegWrite;
	wire EX_MemWrite,EX_MemRead;
	wire [1:0] EX_JumpCtrl;
	wire EX_JalCtrl,EX_LhCtrl,EX_ShCtrl,EX_Beq,EX_Bne,EX_ALUSrc;
	wire [data_size-1:0] EX_PC;
	wire [1:0] EX_ALUOp;
	wire [5:0] EX_Opcode,EX_Funct;
	wire [4:0] EX_shamt;
	wire [data_size-1:0] EX_Rs_data;
	wire [data_size-1:0] EX_Rt_data;
	wire [data_size-1:0] EX_se_imm;
	wire [4:0] EX_WR_out;
	wire [4:0] EX_Rs;
	wire [4:0] EX_Rt;	
	
	//ForwardA,ForwardB	
	wire [data_size-1:0] FAout,FBout;

	// EX_MEM
	wire M_MemtoReg;	
	wire M_RegWrite;
	wire M_MemWrite,M_MemRead;
	wire [data_size-1:0] M_ALU_result;
	wire [data_size-1:0] M_Rt_data;
	wire [data_size-1:0] M_PCplus8;
	wire [4:0] M_WR_out;
	wire M_JalCtrl,M_LhCtrl,M_ShCtrl;		
	
	//M_WB
	wire WB_MemtoReg;
	wire WB_RegWrite;
    wire [data_size-1:0] WB_DM_Read_Data;
    wire [data_size-1:0] WB_WD_out;
    wire [4:0] WB_WR_out;
	
	//FU
	wire [1:0] ForwardA;
	wire [1:0] ForwardB; 	
	
	/*
	//Debug message
	always @* begin
		if (clk)begin
			$monitor("PCin=%h,IM=%4d,IF_Ins=%h,ID_Ins=%h IF_Flush=%2b,ID_Flush=%2b\n",PCin,IC_Address,IF_Ins,ID_Ins,IF_Flush,ID_Flush);			
		end			
	end */
	
	
	//------------module declaration--------------
	
	//Program Counter
	PC   PC1( 
			.clk(clk), 
			.rst(rst),
			.stall(stall),
			.PCWrite(PCWrite),
			.PCin(PCin), 
			.PCout(PCout)
			);
 	
	//PC + 4
	adder PC_4(
			.A(PCout),
			.B(4),
			.C(PC4Out)		
			);
			
	//IF_ID 
	IF_ID IF_ID1( 
			.clk(clk),
            .rst(rst),
			.stall(stall),
			// input
			.IF_Write(IF_Write),
			.IF_Flush(IF_Flush),
			.IF_PC4(PC4Out),
			.IF_Ins(Instruction),
			// output
			.ID_PC4(ID_PC4),
			.ID_Ins(ID_Ins)
			);	
	//HDU		
	HDU HDU1( // input
			 .ID_Rs(ID_Ins[25:21]),
             .ID_Rt(ID_Ins[20:16]),
			 .EX_WR_out(EX_WR_out),
			 .EX_MemtoReg(EX_MemtoReg),
			 .EX_JumpCtrl(EX_JumpCtrl),
			 .Branch(Branch),//if Branch=1 要跳
			 // output
			 .PCWrite(PCWrite),//stall  PCWrite=0
			 .IF_Write(IF_Write),//stall IF_Write=0
			 .IF_Flush(IF_Flush),
			 .ID_Flush(ID_Flush)
			 );	
	
	//Control unit
	Controller ControlUnit( 
	        //inuput
			.opcode(ID_Ins[31:26]),//OpCode
			.funct(ID_Ins[5:0]),//funct
			//output
			.RegDst(RegDst),
			.JumpCtrl(JumpCtrl),
			.JalCtrl(JalCtrl),
			.BranchEq(BranchEq),
			.BranchNeq(BranchNeq),
			.MemRead(MemRead),
			.MemToReg(MemToReg),
			.ALUOp(ALUOp),
			.MemWrite(MemWrite),
			.ALUSrc(ALUSrc),
			.RegWrite(RegWrite),
			.LhCtrl(LhCtrl),
			.ShCtrl(ShCtrl)
			);
			
	//Regfile 
	Regfile Register( 
			.clk(clk), 
			.rst(rst),						
			.Read_addr_1(ID_Ins[25:21]),//Rs
			.Read_addr_2(ID_Ins[20:16]),//Rt
			.Read_data_1(Read_data_1), //Out
            .Read_data_2(Read_data_2), //Out
			.RegWrite(WB_RegWrite),
			.Write_addr(WB_WR_out), //RegDstMuxOut(Rt or Rs) or R[31]=> $ra 
			.Write_data(MemToRegMuxOut) 
			 );		
			 
	//signExtend 16 => 32 bit for branch instruction
	sign_Extend32 signExtend(
			.In16(ID_Ins[15:0]),
			.Out32(signExtendOut)
			);
			
	//mux_5bit select Rt or Rs to be WriteReg ,
	//RegDst = 1  output=>Rd , RegDst = 0  output=>Rt
	mux_5bit RegDstMux(
			.A(ID_Ins[20:16]), //0 Rt
			.B(ID_Ins[15:11]), //1 Rd
			.Ctrl(RegDst),
			.Out(RegDstMuxOut)
			);		

	//Jal,Jalr return address PC+8 should store in register R[31]		
	mux_5bit JalRegMux(
			.A(RegDstMuxOut), //0
			.B(5'd31), //1
			.Ctrl(JalCtrl),
			.Out(JalRegMuxOut)
			);	
	
	//ID_EX
	ID_EX ID_EX1( 
			   .clk(clk),  
               .rst(rst),
			   .stall(stall),
               // input 
			   .ID_Ins(ID_Ins),//ID_Ins
			   .ID_Flush(ID_Flush),
			   // WB
			   .ID_MemtoReg(MemToReg),
			   .ID_RegWrite(RegWrite),
			   // M
			   .ID_MemRead(MemRead),
			   .ID_MemWrite(MemWrite),			   
			   // EX			 
			   .ID_JumpCtrl(JumpCtrl),
			   .ID_JalCtrl(JalCtrl),
			   .ID_LhCtrl(LhCtrl),
			   .ID_ShCtrl(ShCtrl),
			   .ID_Beq(BranchEq),
			   .ID_Bne(BranchNeq),
			   .ID_ALUSrc(ALUSrc),
			   .ID_PC(ID_PC4),
			   .ID_ALUOp(ALUOp),			   
			   .ID_Opcode(ID_Ins[31:26]),
			   .ID_Funct(ID_Ins[5:0]),
			   .ID_shamt(ID_Ins[10:6]),
			   .ID_Rs_data(Read_data_1),
			   .ID_Rt_data(Read_data_2),
			   .ID_se_imm(signExtendOut),
			   .ID_WR_out(JalRegMuxOut),
			   .ID_Rs(ID_Ins[25:21]),
			   .ID_Rt(ID_Ins[20:16]),
			   // output
			   .EX_Ins(EX_Ins),//EX_Ins 
			   .EX_MemtoReg(EX_MemtoReg),
			   .EX_RegWrite(EX_RegWrite),
			   // M
			   .EX_MemRead(EX_MemRead),
			   .EX_MemWrite(EX_MemWrite),			  
			   // EX
			   .EX_JumpCtrl(EX_JumpCtrl),
			   .EX_JalCtrl(EX_JalCtrl),
			   .EX_LhCtrl(EX_LhCtrl),
			   .EX_ShCtrl(EX_ShCtrl),
			   .EX_Beq(EX_Beq),
			   .EX_Bne(EX_Bne),
			   .EX_ALUSrc(EX_ALUSrc),
			   .EX_PC(EX_PC),
			   .EX_ALUOp(EX_ALUOp),
			   .EX_Opcode(EX_Opcode),
			   .EX_Funct(EX_Funct),
			   .EX_shamt(EX_shamt),
			   .EX_Rs_data(EX_Rs_data),
			   .EX_Rt_data(EX_Rt_data),
			   .EX_se_imm(EX_se_imm),
			   .EX_WR_out(EX_WR_out),
			   .EX_Rs(EX_Rs),
			   .EX_Rt(EX_Rt)		   			   
			   );	


	assign Beq=(EX_Beq & Zero);//beq 成立,則Zero 回傳 1 ,Beq=1 
	assign Bne=(EX_Bne & (!Zero));//bne 成立,則Zero 回傳 0 ,Bne=1 
	assign Branch=(Beq|Bne);//表示Beq|Bne 其中一個成立,要跳
		
	//branch offset address should shift left 2 bit => offset*4
	assign branchOffset = EX_se_imm<<2 ;		
			
	// branch logic
	adder branchAdd(
			.A(EX_PC),//PC4
			.B(branchOffset),
			.C(branchAddress)			
			);	
			
	assign jumpAddress ={EX_PC[31:28],EX_Ins[25:0],2'b00};	//這邊要注意要用EX_stage的Ins,不可以用IF_stage的Ins 也就是上面input的Instruction 
	
	//Jump Mux
	Jmux_32bit JumpMux( 
			.PC4Out(PC4Out),
			.BranchTarget(branchAddress), 
			.JumpJal(jumpAddress), 
			.JrJalr(FAout), //Rs
			.Branch(Branch),			
			.JumpCtrl(EX_JumpCtrl),
			.Out(PCin)
			);	
			
	//ForwardA
	ForwardA FAmux( 
			//input
			.ForwardA(ForwardA), 
			.EX_Rs_data(EX_Rs_data), 
			.WB_out(MemToRegMuxOut),//Forward from WB 01
			.MEM_ALUout(JalMuxOut),//Forward from MEM 10
			//output
			.FAout(FAout)	
			);	
			
	//ForwardB		
	ForwardB FBmux( 
			//input
			.ForwardB(ForwardB), 
			.EX_Rt_data(EX_Rt_data),//No Forward 00
			.WB_out(MemToRegMuxOut),//Forward from WB 01
			.MEM_ALUout(JalMuxOut),//Forward from MEM 10
			//output
			.FBout(FBout)	
			);		
			

	//ALUSrc Mux select Rt or signExtendOut 	
	mux_32bit ALUSrcMux(
			.A(FBout),//0 
			.B(EX_se_imm),//1
			.Ctrl(EX_ALUSrc),
			.Out(ALUSrcMuxOut)
			);
			
	//ALUControl
	ALUControl ALUCtrl( 
			.ALUOp(EX_ALUOp),
			.OpCode(EX_Opcode),
			.Funct(EX_Funct),
			.ALUControl(ALUCtrlOut)
			);
	
	//ALU		
	ALU ALUunit(
			.ALUControl(ALUCtrlOut),
			.src1(FAout), //should check out Rs
			.src2(ALUSrcMuxOut),
			.shamt(EX_shamt),//shamt for srl ,sll 
			.ALUOut(ALUOutput),
			.Zero(Zero)
			);			
	
	//PC+8  PC4Out+4 for jal instruction
	adder PC_8(
			.A(EX_PC),
			.B(4),
			.C(PC8Out)		
			);		
			
	//EX_M
	EX_M EX_M1( 
			  .clk(clk),
			  .rst(rst),
			  .stall(stall),
			  // input
			  .EX_Ins(EX_Ins),//EX_Ins
			  .EX_MemtoReg(EX_MemtoReg),
			  .EX_RegWrite(EX_RegWrite),
			  // M
			  .EX_MemRead(EX_MemRead),
			  .EX_MemWrite(EX_MemWrite),
			  .EX_ALU_result(ALUOutput),//ALUOutput
			  .EX_Rt_data(FBout),//FBout Rt_data
			  .EX_PCplus8(PC8Out),
			  .EX_WR_out(EX_WR_out),
			  .EX_JalCtrl(EX_JalCtrl),
			  .EX_LhCtrl(EX_LhCtrl),
			  .EX_ShCtrl(EX_ShCtrl),
			  // output
			  .M_Ins(M_Ins),//M_Ins	
			  .M_MemtoReg(M_MemtoReg),
			  .M_RegWrite(M_RegWrite),
			  .M_MemRead(M_MemRead),
			  .M_MemWrite(M_MemWrite),
			  .M_ALU_result(M_ALU_result),
			  .M_Rt_data(M_Rt_data),
			  .M_PCplus8(M_PCplus8),
			  .M_WR_out(M_WR_out),
			  .M_JalCtrl(M_JalCtrl),
			  .M_LhCtrl(M_LhCtrl),
			  .M_ShCtrl(M_ShCtrl)
			  );		
			
	//JalCtrl Mux	return address PC+8 or M_ALU_result store in Write_data	
	mux_32bit JalCtrlMux(
			.A(M_ALU_result),//0
			.B(M_PCplus8),//1
			.Ctrl(M_JalCtrl),
			.Out(JalMuxOut)
			);		
			
	//Extract M_Rt_data left most 16bits and signExtend 16 -> 32 bit for SH instruction
	sign_Extend32 SHsignExtend(
			.In16(M_Rt_data[15:0]),
			.Out32(shsignExtendOut)
			);
	
	//sh mux output M_Rt_data or shsignExtendOut 
	mux_32bit shMux(
			.A(M_Rt_data),//0
			.B(shsignExtendOut),//1
			.Ctrl(M_ShCtrl),
			.Out(shMuxOut)
			);	
			
	//DC logic not in top ,so we should output some wire	
	assign DC_Address = M_ALU_result[17:2];//DC_Address 16bit
	assign DC_Write_Data = shMuxOut;
	assign DC_Write_enable = M_MemWrite;
	assign DC_Read_enable = M_MemRead;	
	
	//Extract DC_Read_Data left most 16bits and signExtend 16 -> 32 bit for LH instruction
	sign_Extend32 LHsignExtend(
			.In16(DC_Read_Data[15:0]),
			.Out32(lhsignExtendOut)
			);	

	//lh mux output DM_Read_Data or lhsignExtendOut
	mux_32bit lhMux(
			.A(DC_Read_Data),//0
			.B(lhsignExtendOut),//1
			.Ctrl(LhCtrl),
			.Out(lhMuxOut)
			);	
	
	//MEM_WB		
	M_WB M_WB1( 
			  .clk(clk),
              .rst(rst),
			  .stall(stall),
			  // input
			  .M_Ins(M_Ins),
			  .M_MemtoReg(M_MemtoReg),
			  .M_RegWrite(M_RegWrite),
			  .M_DM_Read_Data(lhMuxOut),
			  .M_WD_out(JalMuxOut),
			  .M_WR_out(M_WR_out),
			  // output	
			  .WB_Ins(WB_Ins),
			  .WB_MemtoReg(WB_MemtoReg),
			  .WB_RegWrite(WB_RegWrite),			
			  .WB_DM_Read_Data(WB_DM_Read_Data),
			  .WB_WD_out(WB_WD_out),
              .WB_WR_out(WB_WR_out)
			  );
	
	// MemToRegMux		
	mux_32bit MemToRegMux(
			.A(WB_WD_out),//0
			.B(WB_DM_Read_Data),//1 
			.Ctrl(WB_MemtoReg),
			.Out(MemToRegMuxOut)
			);		
	//FU
	FU FU1( 
			// input 
			.EX_Rs(EX_Rs),
            .EX_Rt(EX_Rt),
			.M_RegWrite(M_RegWrite),
			.M_WR_out(M_WR_out),
			.WB_RegWrite(WB_RegWrite),
			.WB_WR_out(WB_WR_out),
			// output
			.ForwardA(ForwardA),
			.ForwardB(ForwardB)			
			);	
	
endmodule


























