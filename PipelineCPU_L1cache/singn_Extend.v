//sign_Extend 16bit to 32bit

module sign_Extend32(In16 ,Out32);

    parameter in_size = 16;
	parameter out_size = 32;
	
	input  [in_size-1:0] In16;	
	output [out_size-1:0] Out32;

	assign Out32 = {{in_size{In16[in_size-1]}}, In16} ;
	
endmodule