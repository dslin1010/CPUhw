// Forwarding Unit

module FU ( // input 
			EX_Rs,
            EX_Rt,
			M_RegWrite,
			M_WR_out,
			WB_RegWrite,
			WB_WR_out,
			// output
			ForwardA,
			ForwardB			
			);

	input [4:0] EX_Rs;
    input [4:0] EX_Rt;
    input M_RegWrite;
    input [4:0] M_WR_out;//Mem.RegisterRd
    input WB_RegWrite;
    input [4:0] WB_WR_out;//WB.RegisterRd
	
	output reg [1:0] ForwardA;
	output reg [1:0] ForwardB; 
	
	initial begin 
		ForwardA=0;
		ForwardB=0; 
	end
	
	//ForwardA ,check if Rs==Rd
	always @(*) begin	
		if(M_RegWrite&&(M_WR_out!=0)&&(M_WR_out == EX_Rs))begin
			ForwardA <=2'b10;//Forward from MEM stage
		end
		else if(WB_RegWrite && (WB_WR_out!=0) && !(M_RegWrite&&(M_WR_out!=0)&&(M_WR_out==EX_Rs)) && (WB_WR_out == EX_Rs))begin
			ForwardA <=2'b01;//Forward from WB stage
		end
		else begin
			ForwardA <=2'b00;//No Forward
		end		
	end
	
	//ForwardB,,check if Rt==Rd 
	always @(*) begin	
		if(M_RegWrite&&(M_WR_out!=0)&&(M_WR_out == EX_Rt))begin
			ForwardB <=2'b10;//Forward from MEM stage
		end
		else if(WB_RegWrite&&(WB_WR_out!=0)&& !(M_RegWrite&&(M_WR_out!=0)&&(M_WR_out == EX_Rt)) && (WB_WR_out == EX_Rt))begin
			ForwardB <=2'b01;//Forward from WB stage
		end
		else begin
			ForwardB <=2'b00;//No Forward
		end		
	end
	
endmodule




























