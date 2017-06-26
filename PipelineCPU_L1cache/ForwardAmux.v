module ForwardA( //input
				  ForwardA, 
				  EX_Rs_data, 
				  WB_out, 
				  MEM_ALUout,
				 //output
				  FAout	
				  );

    parameter data_size = 32;
	
	input  [1:0]ForwardA;
	input  [data_size-1:0] EX_Rs_data,WB_out,MEM_ALUout;	
	
	output reg [data_size-1:0] FAout;
	
	initial begin
		FAout=0;
	end		
	
	always @ (*) begin

		     if(ForwardA==2'b00)begin
		         FAout<=EX_Rs_data;
		end		
		else if (ForwardA==2'b01)begin			
				FAout<=WB_out;
		end
		else if (ForwardA==2'b10)begin		
				FAout<=MEM_ALUout;				
		end	
		else begin 				
			$display("ForwardA=%b ",ForwardA);
		end
	end
	
endmodule