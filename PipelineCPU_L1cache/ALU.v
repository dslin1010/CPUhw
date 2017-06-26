// ALU

module ALU ( ALUControl,
			 src1,
			 src2,
			 shamt,
			 ALUOut,
			 Zero);
	
	parameter bit_size = 32;
	
	input [3:0] ALUControl;
	input [bit_size-1:0] src1;
	input [bit_size-1:0] src2;
	input [4:0] shamt;
	
	output [bit_size-1:0] ALUOut;
	output Zero;
	
	   reg [bit_size-1:0] ALUOut;
	   reg Zero;
			
 parameter AND = 4'b0000 ; //  0
 parameter  OR = 4'b0001 ; //  1
 parameter NOR = 4'b1100 ; //  12
 parameter XOR = 4'b1101 ; //  13
 parameter ADD = 4'b0010 ; //  2
 parameter SUB = 4'b0110 ; //  6
 parameter SLT = 4'b0111 ; //  7 
 parameter SLL = 4'b0011 ; //  3 
 parameter SRL = 4'b0100 ; //  4
 
	
	always @ (*) begin
     case (ALUControl)
         AND: ALUOut = src1 & src2;
          OR: ALUOut = src1 | src2;
		 NOR: ALUOut = ~(src1 | src2); 
         XOR: ALUOut = src1 ^ src2; 
		 ADD: ALUOut = src1 + src2;
         SUB: ALUOut = src1 - src2;
         SLT: ALUOut = (src1 < src2) ? 32'd1 : 32'd0;  //becareful 32'd1 is decimal      
         SLL: ALUOut = src2 << shamt;
         SRL: ALUOut = src2 >> shamt; 	
		default: ALUOut = 32'd0 ;
      endcase	         
	  Zero = ( (src1 - src2) == 0 ) ? 1 : 0; // Eq=1;Neq=0
    end	
	

endmodule





