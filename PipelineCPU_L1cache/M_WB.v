// M_WB

module M_WB ( clk,
              rst,
			  stall,
			  // input 
			  // WB
			  M_Ins,
			  M_MemtoReg,
			  M_RegWrite,
			  // pipe
			  M_DM_Read_Data,
			  M_WD_out,
			  M_WR_out,
			  // output
			  // WB
			  WB_Ins,
			  WB_MemtoReg,
			  WB_RegWrite,
			  // pipe
			  WB_DM_Read_Data,
			  WB_WD_out,
              WB_WR_out
			  );
	
	parameter data_size = 32;
	
	input clk, rst,stall;
	
	// WB
    input M_MemtoReg;	
    input M_RegWrite;	
	// pipe	
    input [data_size-1:0] M_DM_Read_Data,M_Ins;
    input [data_size-1:0] M_WD_out;
    input [4:0] M_WR_out;

	// WB
	output reg WB_MemtoReg;
	output reg WB_RegWrite;
	// pipe
    output reg [data_size-1:0] WB_DM_Read_Data,WB_Ins;
    output reg [data_size-1:0] WB_WD_out;
    output reg [4:0] WB_WR_out;	
	
	initial begin 
		WB_MemtoReg = 0;
		WB_RegWrite = 0;
        WB_DM_Read_Data = 32'b0; 
        WB_WD_out = 32'b0; 
		WB_WR_out = 4'b0;
		WB_Ins = 0;
    end 

	always@(negedge clk) begin 
	
		if(rst)begin
			WB_MemtoReg <= 0;
			WB_RegWrite <= 0;
			WB_DM_Read_Data <= 32'b0; 
			WB_WD_out <= 32'b0; 
			WB_WR_out <= 4'b0;
			WB_Ins <= 0;
		end		
		else if(stall) begin		
			WB_MemtoReg <= WB_MemtoReg;
			WB_RegWrite <= WB_RegWrite;
			WB_DM_Read_Data <= WB_DM_Read_Data; 
			WB_WD_out <= WB_WD_out; 
			WB_WR_out <= WB_WR_out;
			WB_Ins <= WB_Ins;
		end	
		else begin		
			WB_MemtoReg <= M_MemtoReg;
			WB_RegWrite <= M_RegWrite;
			WB_DM_Read_Data <= M_DM_Read_Data; 
			WB_WD_out <= M_WD_out; 
			WB_WR_out <= M_WR_out;
			WB_Ins <= M_Ins;
		end	
	end 
endmodule












