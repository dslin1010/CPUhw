module ALUControl( ALUOp,
				   OpCode,
				   Funct,
				   ALUControl
				   );

 
 input  [5:0]  OpCode, Funct;
 input  [1:0]  ALUOp;
 output [3:0] ALUControl;
 
//ALUOp code
 parameter   LW_SW = 2'b00; //lw,sw,lh,sh instruction
 parameter     IMM = 2'b11;// addi,slti,andi
 parameter   RTYPE = 2'b10;

 //RTYPE function code should match the Table
 parameter F_SLL = 6'b000000;//0
 parameter F_SRL = 6'b000010;//2
 parameter F_AND = 6'b100100;//36
 parameter F_OR  = 6'b100101;//37
 parameter F_NOR = 6'b100111;//39
 parameter F_XOR = 6'b100110;//38
 parameter F_ADD = 6'b100000;//32
 parameter F_SUB = 6'b100010;//34
 parameter F_SLT = 6'b101010;//42 
 

 // OpCodes should match the Table
 parameter  ADDI = 6'b001000 ; //8
 parameter  ANDI = 6'b001100; // 12
 parameter  SLTI = 6'b001010; // 10

 reg [3:0] ALUControl;

 /*
 parameter AND = 4'b0000 ; //  0
 parameter  OR = 4'b0001 ; //  1
 parameter NOR = 4'b1100 ; //  12
 parameter XOR = 4'b1101 ; //  13
 parameter ADD = 4'b0010 ; //  2
 parameter SUB = 4'b0110 ; //  6
 parameter SLT = 4'b0111 ; //  7 
 parameter SLL = 4'b0011 ; //  3 
 parameter SRL = 4'b0100 ; //  4
 */

 always @ (*) begin
   case (ALUOp)
	LW_SW: ALUControl = 4'b0010;// 
      IMM: begin
        case (OpCode)
			ADDI: ALUControl = 4'b0010;//
            ANDI: ALUControl = 4'b0000;//
            SLTI: ALUControl = 4'b0111;//
        endcase
       end       
    RTYPE: begin
        case (Funct)
           F_AND: ALUControl = 4'b0000;//
            F_OR: ALUControl = 4'b0001;//
		   F_NOR: ALUControl = 4'b1100;//
		   F_XOR: ALUControl = 4'b1101;//
           F_ADD: ALUControl = 4'b0010;//
           F_SUB: ALUControl = 4'b0110;//
           F_SLT: ALUControl = 4'b0111;//        
           F_SLL: ALUControl = 4'b0011;//
           F_SRL: ALUControl = 4'b0100;//
        endcase
       end
   endcase
  end
endmodule