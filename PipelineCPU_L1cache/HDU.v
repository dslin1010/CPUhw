// Hazard Detection Unit

module HDU ( // input
			 ID_Rs,
             ID_Rt,
			 EX_WR_out,
			 EX_MemtoReg,
			 EX_JumpCtrl,
			 Branch,
			 // output
			 PCWrite,//stall
			 IF_Write,//stall
			 IF_Flush,
			 ID_Flush
			 );
	
	parameter bit_size = 32;
	
	input [4:0] ID_Rs;
	input [4:0] ID_Rt;
	input [4:0] EX_WR_out;//EX_Rt
	input EX_MemtoReg;
	input [1:0]  EX_JumpCtrl;
	input Branch;
	
	output reg PCWrite,IF_Write,IF_Flush,ID_Flush ;
	
	always @(*) begin
	
		if((EX_JumpCtrl==2'b01)||(EX_JumpCtrl==2'b10)||(EX_JumpCtrl==2'b11 && Branch))begin
			PCWrite<=1;
			IF_Write<=1;
			IF_Flush<=1;
			ID_Flush<=1;
			//$display("IF_Flush=%2b,ID_Flush=%2b ",IF_Flush,ID_Flush);
		end
		//lw use hazard
		else if(EX_MemtoReg && ((EX_WR_out==ID_Rs)||(EX_WR_out==ID_Rt)))begin
			PCWrite<=0; //stall PC
			IF_Write<=0;//stall IF
			IF_Flush<=0;
			ID_Flush<=1;//Flush ID pipe
			
		end
		else begin
			PCWrite<=1;
			IF_Write<=1;
			IF_Flush<=0;
			ID_Flush<=0;
		end		
	end	
	
endmodule