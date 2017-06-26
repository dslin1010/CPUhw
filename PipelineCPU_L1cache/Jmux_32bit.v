module Jmux_32bit(PC4Out, 
				  BranchTarget, 
				  JumpJal, 
				  JrJalr,
				  Branch,				  
				  JumpCtrl, 
				  Out);

    parameter bit_size = 32;

	input  [bit_size-1:0] PC4Out,BranchTarget,JumpJal,JrJalr;
	input  [1:0]JumpCtrl;	
	input  Branch;
	
	output reg[bit_size-1:0] Out;
	
	
	 always @ (*) begin

		      if(JumpCtrl==2'b00)begin
		         Out<=PC4Out;
		end		
		else if (JumpCtrl==2'b01)begin			
				Out<=JumpJal;
			//$display("Jal=%h ",Out);	
		end
		else if (JumpCtrl==2'b10)begin		
				Out<=JrJalr;
			//$display("Jr=%h ",Out);				
		end
		else if (JumpCtrl==2'b11 && Branch )begin //beq or Bne 成立,跳到Target 
				Out<=BranchTarget;
		end		
		else begin 
				Out<=PC4Out;//表示beq 或是 bne 不成立,則執行下一個指令
			//$display("JumpCtrl=%b ,Branch=%b ",JumpCtrl,Branch);
		end
	end
	
endmodule