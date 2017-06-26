// Program Counter

module PC ( clk, 
			rst,
			stall,
			PCWrite,
			PCin, 
			PCout
			);
	
	parameter bit_size = 32;
	
	input  clk, rst,stall;
	input  PCWrite;
	input      [bit_size-1:0] PCin;
	output reg [bit_size-1:0] PCout;
	
	
	always @(negedge clk ) begin
		if(rst) begin
			PCout <= 32'd0;
		end			
		else if(PCWrite==0 || stall) begin
			PCout <= PCout ;	
		end
		else begin
			PCout <= PCin  ;// PCout => the previous instruction address + 4 
		end
	end
endmodule

