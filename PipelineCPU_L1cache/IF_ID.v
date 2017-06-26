// IF_ID

module IF_ID ( clk,
               rst,
			   stall,
			   // input
			   IF_Write,
			   IF_Flush,
			   IF_PC4,
			   IF_Ins,
			   // output
			   ID_PC4,
			   ID_Ins);
	
	parameter pc_size = 32;
	parameter data_size = 32;
	
	input clk, rst,stall;
	input IF_Write, IF_Flush;
	input [pc_size-1:0]   IF_PC4;
	
	input [data_size-1:0] IF_Ins;
	
	output reg [pc_size-1:0]   ID_PC4;
	output reg [data_size-1:0] ID_Ins;	
     
    initial begin 
        ID_PC4 = 32'b0; 
        ID_Ins = 32'b0; 
    end 
	
	always @(negedge clk ) begin 
	
		if(rst)begin
			 ID_PC4 <= 32'b0; 
             ID_Ins <= 32'b0;
		end
		else if (IF_Write==0 || stall )begin
			 ID_PC4 <= ID_PC4; 
             ID_Ins <= ID_Ins;		
		end
		else if(IF_Flush)begin
			 ID_PC4 <= 32'b0; 
             ID_Ins <= 32'b0;
		end
		else begin
			ID_PC4 <= IF_PC4; 
            ID_Ins <= IF_Ins;
		end
	end

endmodule