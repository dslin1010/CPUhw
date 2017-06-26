module adder(
			 A,
			 B,
			 C);

parameter bit_size = 32;

input    [bit_size-1:0] A,B ;
output   [bit_size-1:0] C ;

   reg   [bit_size-1:0] C;

  always @(A or B) begin  
	 C = A + B ;
  end

 endmodule
