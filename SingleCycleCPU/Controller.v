// Controller

module Controller ( opcode,//input
					funct,//input
					RegDst,
					JumpCtrl,
					JalCtrl,
					BranchEq,
					BranchNeq,
					MemRead,
					MemToReg,
					ALUOp,
					MemWrite,
					ALUSrc,
					RegWrite,
					LhCtrl,
					ShCtrl
					);
	 
	 
	 //Instruction Opcode table shoule list all the Instruction we need
     parameter Rtype = 6'b000000;//0
	 parameter    LH = 6'b100001;//33
	 parameter    LW = 6'b100011;//35
	 parameter    SH = 6'b101001;//41
	 parameter    SW = 6'b101011;//43
	 parameter   BEQ = 6'b000100;//4
	 parameter   BNE = 6'b000101;//5
	 parameter  ADDI = 6'b001000;//8
     parameter  ANDI = 6'b001100;//12
     parameter  SLTI = 6'b001010;//10
	 parameter  Jump = 6'b000010;//2
	 parameter  Jal  = 6'b000011;//3
	 
	 
	 //funct code	 
	 parameter   Jr = 6'b001000;//8
	 parameter Jalr = 6'b001001;//9
	 
	parameter F_SLL = 6'b000000;//0
	parameter F_SRL = 6'b000010;//2
	parameter F_AND = 6'b100100;//36
	parameter F_OR  = 6'b100101;//37
	parameter F_NOR = 6'b100111;//39
	parameter F_XOR = 6'b100110;//38
	parameter F_ADD = 6'b100000;//32
	parameter F_SUB = 6'b100010;//34
	parameter F_SLT = 6'b101010;//42 
					

	input [5:0]  opcode;
	input [5:0]	 funct;
	 
	output reg [1:0]  ALUOp;
	output reg [1:0]  JumpCtrl;
	output reg RegDst,BranchEq,BranchNeq,MemRead,MemToReg,MemWrite, ALUSrc ,RegWrite ,JalCtrl,LhCtrl, ShCtrl ; 
    
    initial begin
	   RegDst=0;
	   JumpCtrl=2'b00;
	   JalCtrl=0;
	   BranchEq=0;
	   BranchNeq=0;
	   BranchNeq=0;
	   MemRead=0;
	   MemToReg=0;
	   MemWrite=0;
	   ALUSrc=0;
	   RegWrite=0;
	   LhCtrl=0;
	   ShCtrl=0;
	end
	
	/*always @* begin		
		$display("Opcode1 is %b \n",opcode);		
	end*/	
		
	always @(*) begin
	
		case(opcode) 
			Rtype:begin					
				 case(funct)
					  Jr:begin 
						JumpCtrl=2'b10; //2
						JalCtrl=0;
						end
					Jalr:
						begin
						JumpCtrl=2'b10; //2
						JalCtrl=1;
						RegDst=1;
						MemRead=0;
						MemToReg=0;
						MemWrite=0;
						ALUSrc=0;
						RegWrite=1;
						ALUOp=2'b10;
						LhCtrl=0;
					  end
		F_SLL ,F_SRL ,F_AND ,F_OR ,F_NOR ,F_XOR ,F_ADD ,F_SUB ,F_SLT:
					begin	
						RegDst=1;
						JumpCtrl=2'b00;
						MemRead=0;
						MemToReg=0;
						MemWrite=0;
						ALUSrc=0;
						RegWrite=1;
						ALUOp=2'b10;
						LhCtrl=0;
						JalCtrl=0;
					end
				endcase					 						
			  end
			 LW:
			    begin
					RegDst=0;
					JumpCtrl=2'b00;
					MemRead=1;
					MemToReg=1;
					MemWrite=0;
					ALUSrc=1;
					RegWrite=1;
					ALUOp=2'b00;
					LhCtrl=0;
					JalCtrl=0;
				end	
			 LH:
			    begin
					RegDst=0;
					JumpCtrl=2'b00;
					MemRead=1;
					MemToReg=1;
					MemWrite=0;
					ALUSrc=1;
					RegWrite=1;
					ALUOp=2'b00;
					LhCtrl=1;
					JalCtrl=0;					
				end		
			 SW:
			    begin
					RegDst=0;
					JumpCtrl=2'b00;
					MemRead=0;
					MemToReg=0;
					MemWrite=1;
					ALUSrc=1;
					RegWrite=0;
					ALUOp=2'b00;
					ShCtrl=0;
					JalCtrl=0;
				end
			 SH:
			    begin
					RegDst=0;
					JumpCtrl=2'b00;
					MemRead=0;
					MemToReg=0;
					MemWrite=1;
					ALUSrc=1;
					RegWrite=0;
					ALUOp=2'b00;
					LhCtrl=0;
					ShCtrl=1;
					JalCtrl=0;		
				end			
			BEQ:
			    begin
					RegDst=0;
					JumpCtrl=2'b11;
					MemRead=0;
					MemToReg=0;
					MemWrite=0;
					ALUSrc=0;
					RegWrite=0;
					BranchEq=1;
					BranchNeq=0;
					ALUOp=2'b01;
					JalCtrl=0;					
				end	
			BNE:
			    begin
					RegDst=0;
					JumpCtrl=2'b11;
					MemRead=0;
					MemToReg=0;
					MemWrite=0;
					ALUSrc=0;
					RegWrite=0;
					BranchEq=0;
					BranchNeq=1;
					ALUOp=2'b01;
					JalCtrl=0;	
				end				
  ADDI,ANDI,SLTI:
		        begin
					RegDst=0;
					JumpCtrl=2'b00;
					MemRead=0;
					MemToReg=0;
					MemWrite=0;
					ALUSrc=1;
					RegWrite=1;
					ALUOp=2'b11;
					JalCtrl=0;	
				end		
			Jump:
			     begin
				 JumpCtrl=2'b01;
				 JalCtrl=0;
				 end
			Jal:
				begin
				 JumpCtrl=2'b01;
				 JalCtrl=1;
				 RegDst=1;
				 MemRead=0;
				 MemToReg=0;
				 MemWrite=0;
				 ALUSrc=0;
				 RegWrite=1;
				 ALUOp=2'b10;
				 LhCtrl=0;
				 end	 
		default:
			    begin
				$display("Opcode is %b \n",opcode);
				end
		endcase
		
		
	end
	
endmodule




