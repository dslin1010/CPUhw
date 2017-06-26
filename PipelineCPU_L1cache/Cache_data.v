// Cache_data

module Cache_data ( 
					clk,
					rst,
					Data_Address,
					Data_enable,
					Data_in,
					Data_out
					);

    parameter bit_size = 32;
	parameter mem_size = 5;

	input  clk, rst;
	input  [mem_size-1:0] Data_Address;
	input  Data_enable;
	input  [bit_size-1:0] Data_in;
	
	output [bit_size-1:0] Data_out;
	
	reg [bit_size-1:0] Data [0:( 2**mem_size-1 )];
	
	assign Data_out = Data[Data_Address];
	
	integer i;
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			for (i=0;i<2**mem_size;i=i+1)
				Data[i] <= 0;
		end
		else if (Data_enable) 
			Data[Data_Address] <= Data_in;           
	end 
/*
	parameter bit_size = 32;
	parameter mem_size = 5;

	input  clk, rst;
	input  [mem_size-1:0] Data_Address;
	input  Data_enable;
	input  [bit_size-1:0] Data_in;
	
	output [bit_size-1:0] Data_out;
	
	reg [bit_size-1:0] Data [0:( 2**mem_size-1 )];
	reg [mem_size-1:0] Data_Addr;
	
	assign Data_out = Data[Data_Addr];
	
	integer i;
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			for (i=0;i<2**mem_size;i=i+1)
				Data[i] <= 0;
		end
		else if (Data_enable) begin
			Data_Addr = Data_Address ;
			Data[Data_Addr] = Data_in;
			end
	end
*/
endmodule












