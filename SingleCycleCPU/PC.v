// Program Counter

module PC ( clk, 
			rst,
			PCin, 
			PCout);
	
	parameter bit_size = 32;
	
	input  clk, rst;
	input      [bit_size-1:0] PCin;
	output reg [bit_size-1:0] PCout;
	
	
	always @(posedge clk ) begin
		if(rst) begin
			PCout <= 32'd0;
		end			
		else begin
			PCout <= PCin  ;// PCout => the previous instruction address + 4 
		end
	end
endmodule

