// Regfile

module Regfile ( clk, 
				 rst,				 
				 Read_addr_1,
				 Read_addr_2,
				 Read_data_1,
                 Read_data_2,
				 RegWrite,
				 Write_addr,
				 Write_data
				 );
	
	parameter bit_size = 32;
	
	input  clk, rst;
	input  [4:0] Read_addr_1;
	input  [4:0] Read_addr_2;	
	
	output  [bit_size-1:0] Read_data_1;
	output  [bit_size-1:0] Read_data_2;
	
	input  RegWrite;
	input  [4:0] Write_addr;
	input  [bit_size-1:0] Write_data;
	
	reg  [bit_size-1:0] Register[31:0]; //declare 32 registers to store data
	
	//Read register data 
	assign Read_data_1 = (Read_addr_1 == 0 ) ? 0 : Register[Read_addr_1];
	assign Read_data_2 = (Read_addr_2 == 0 ) ? 0 : Register[Read_addr_2];
	
	integer i;	
	        
	initial begin
		 for (i=0;i<32;i=i+1)
				Register[i] <= 0;
	end	
	
	//if RegWrite ==1 write the data to register
	always @(posedge clk ) begin   		
		if (RegWrite && (Write_addr!=0)) begin   
		    Register[Write_addr] <= Write_data ;
			//$display("Register[%d]=%h",Write_addr,Write_data);
		end		
	end		
	
endmodule






