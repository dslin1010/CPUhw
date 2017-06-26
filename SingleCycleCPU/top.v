// top

module top ( clk,
             rst,
			 // Instruction Memory
			 IM_Address,
             Instruction,
			 // Data Memory
			 DM_Address,
			 DM_enable,
			 DM_Write_Data,
			 DM_Read_Data);

	parameter data_size = 32;
	parameter mem_size = 16;	

	input  clk, rst;
	
	// Instruction Memory
	output [mem_size-1:0] IM_Address;	
	input  [data_size-1:0] Instruction;

	// Data Memory
	output [mem_size-1:0] DM_Address;
	output DM_enable;
	output [data_size-1:0] DM_Write_Data;	
    input  [data_size-1:0] DM_Read_Data;
	
	//-------------wire declaration-----------
	
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
	
	assign Beq=(BranchEq & Zero);//beq 成立,則Zero 回傳 1 ,Beq=1 
	assign Bne=(BranchNeq & (!Zero));//bne 成立,則Zero 回傳 0 ,Bne=1 
	assign Branch=(Beq|Bne);//表示Beq|Bne 其中一個成立,要跳
	
	//branch offset address should shift left 2 bit => offset*4
	assign branchOffset = signExtendOut<<2 ;		
	
	// jumpAddress
	wire [data_size-1:0] jumpAddress;	
	
	assign jumpAddress ={PC4Out[31:28],Instruction[25:0],2'b00};	
	
	//IM_Address 16 bit
	assign IM_Address = PCout[17:2];	
	
	//sh Mux and shsignExtendOut
	wire  [data_size-1:0] shsignExtendOut;
	wire  [data_size-1:0] shMuxOut;	
	
	//DM logic not in top ,so we should output some wire	
	assign DM_Address = ALUOutput[17:2];//DM_Address 16bit
	assign DM_Write_Data = shMuxOut ;
	assign DM_enable = MemWrite ; 	
	
	//lh Mux and lhsignExtendOut
	wire  [data_size-1:0] lhsignExtendOut;
	wire  [data_size-1:0] lhMuxOut;	
	
	//MemToReg
	wire  [data_size-1:0] MemToRegMuxOut;
	
	//JalMuxOut 
	wire  [data_size-1:0] JalMuxOut;

	
	
	//Debug message
	always @* begin
		if (clk == 1'b1)begin
			$monitor("PCOut=%b ,PC4Out=%b ,PC8Out=%b,JalMuxOut=%b,JalRegMuxOut=%d,IM =%2d ,Ins = %h \n",PCout,PC4Out,PC8Out,JalMuxOut,JalRegMuxOut,IM_Address,Instruction);			
		end		
	$display("JumpCtrl=%b ,BranchNeq=%b ,BranchEq=%b,Zero=%b ",JumpCtrl,BranchNeq,BranchEq,Zero);
	end 
	
	
	//------------module declaration--------------
	
	//Program Counter
	PC   PC1( 
			.clk(clk), 
			.rst(rst),
			.PCin(PCin), 
			.PCout(PCout)
			);
 	
	//PC + 4
	adder PC_4(
			.A(PCout),
			.B(4),
			.C(PC4Out)		
			);			
			
	// branch logic
	adder branchAdd(
			.A(PC4Out),
			.B(branchOffset),
			.C(branchAddress)			
			);	
		
	//Jump Mux
	Jmux_32bit JumpMux( 
			.PC4Out(PC4Out),
			.BranchTarget(branchAddress), 
			.JumpJal(jumpAddress), 
			.JrJalr(Read_data_1), //Rs
			.Branch(Branch),			
			.JumpCtrl(JumpCtrl),
			.Out(PCin)
			);	
	
	//Control unit
	Controller ControlUnit( 
	        .opcode(Instruction[31:26]),
			.funct(Instruction[5:0]),
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
	
	//PC+8  PC4Out+4 for jal instruction
	adder PC_8(
			.A(PC4Out),
			.B(4),
			.C(PC8Out)		
			);		
			
	//JalCtrl Mux	return address PC+8 or MemToRegOutput store in Write_data	
	mux_32bit JalCtrlMux(
			.A(MemToRegMuxOut),//0
			.B(PC8Out),//1
			.Ctrl(JalCtrl),
			.Out(JalMuxOut)
			);			
	
	//mux_5bit select Rt or Rs to be WriteReg ,
	//RegDst = 1  output=>Rd 
	//RegDst = 0  output=>Rt
	mux_5bit RegDstMux(
			.A(Instruction[20:16]), //0
			.B(Instruction[15:11]),  //1
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
	
	//Regfile 
	Regfile Register( 
			.clk(clk), 
			.rst(rst),						
			.Read_addr_1(Instruction[25:21]),//Rs
			.Read_addr_2(Instruction[20:16]),//Rt
			.Read_data_1(Read_data_1), //Out
            .Read_data_2(Read_data_2), //Out
			.RegWrite(RegWrite),
			.Write_addr(JalRegMuxOut), //RegDstMuxOut(Rt or Rs) or R[31]=> $ra 
			.Write_data(JalMuxOut) 
			 );
	
	//signExtend 16 => 32 bit for J-type instruction
	sign_Extend32 signExtend(
			.In16(Instruction[15:0]),
			.Out32(signExtendOut)
			);
	
	//ALUSrc Mux select Rt or signExtendOut 	
	mux_32bit ALUSrcMux(
			.A(Read_data_2),//0
			.B(signExtendOut),//1
			.Ctrl(ALUSrc),
			.Out(ALUSrcMuxOut)
			);
			
	//ALUControl
	ALUControl ALUCtrl( 
			.ALUOp(ALUOp),
			.OpCode(Instruction[31:26]),
			.Funct(Instruction[5:0]),
			.ALUControl(ALUCtrlOut)
			);
	
	//ALU		
	ALU ALUunit(
			.ALUControl(ALUCtrlOut),
			.src1(Read_data_1),
			.src2(ALUSrcMuxOut),
			.shamt(Instruction[10:6]),//shamt for srl ,sll 
			.ALUOut(ALUOutput),
			.Zero(Zero)
			);	
			
	//Extract Read_data_2 left most 16bits and
	//signExtend 16 -> 32 bit for SH instruction
	sign_Extend32 SHsignExtend(
			.In16(Read_data_2[15:0]),
			.Out32(shsignExtendOut)
			);
	
	//sh mux output Read_data_2 or shsignExtendOut 
	mux_32bit shMux(
			.A(Read_data_2),//0
			.B(shsignExtendOut),//1
			.Ctrl(ShCtrl),
			.Out(shMuxOut)
			);	
	
	//Extract DM_Read_Data left most 16bits and
	//signExtend 16 -> 32 bit for LH instruction
	sign_Extend32 LHsignExtend(
			.In16(DM_Read_Data[15:0]),
			.Out32(lhsignExtendOut)
			);	

	//lh mux output DM_Read_Data or lhsignExtendOut
	mux_32bit lhMux(
			.A(DM_Read_Data),//0
			.B(lhsignExtendOut),//1
			.Ctrl(LhCtrl),
			.Out(lhMuxOut)
			);	
			
	
	// MemToRegMux		
	mux_32bit MemToRegMux(
			.A(ALUOutput),//0
			.B(lhMuxOut),//1 
			.Ctrl(MemToReg),
			.Out(MemToRegMuxOut)
			);		
			
	
endmodule


























