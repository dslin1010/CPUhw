module ForwardB( //input
				  ForwardB, 
				  EX_Rt_data, 
				  WB_out, 
				  MEM_ALUout,
				 //output
				  FBout	
				  );

    parameter data_size = 32;
	
	input  [1:0]ForwardB;
	input  [data_size-1:0] EX_Rt_data,WB_out,MEM_ALUout;	
	
	output reg [data_size-1:0] FBout;
	
	initial begin
		FBout=0;
	end		
	
	always @ (*) begin

		     if(ForwardB==2'b00)begin
		         FBout<=EX_Rt_data;
		end		
		else if (ForwardB==2'b01)begin			
				FBout<=WB_out;
		end
		else if (ForwardB==2'b10)begin		
				FBout<=MEM_ALUout;				
		end	
		else begin 				
			$display("ForwardB=%b ",ForwardB);
		end
	end
	
endmodule