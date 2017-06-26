module mux_5bit( A , B, Ctrl, Out);

    parameter bit_size = 5;

	input  [bit_size-1:0] A , B;
	input  Ctrl;
	output [bit_size-1:0] Out;

	assign Out = (Ctrl) ? B : A; //If Ctrl = 0 Out = A else  Ctrl = 1 Out = B
	
endmodule