// EX_M

module EX_M ( clk,
			  rst,
			  stall,
			  // input
			  EX_Ins,
			  EX_MemtoReg,
			  EX_RegWrite,
			  // M
			  EX_MemRead,
			  EX_MemWrite,
			  EX_ALU_result,
			  EX_Rt_data,
			  EX_PCplus8,
			  EX_WR_out,
			  EX_JalCtrl,
			  EX_LhCtrl,
			  EX_ShCtrl,
			  // output	
			  M_Ins,			  
			  M_MemtoReg,
			  M_RegWrite,
			  M_MemRead,
			  M_MemWrite,
			  M_ALU_result,
			  M_Rt_data,
			  M_PCplus8,
			  M_WR_out,
			  M_JalCtrl,
			  M_LhCtrl,
			  M_ShCtrl
			  );
	
	parameter pc_size = 32;	
	parameter data_size = 32;
	
	input clk, rst,stall;		  
			  
	// WB		  
	input EX_MemtoReg;
    input EX_RegWrite;
    // M
    input EX_MemWrite,EX_MemRead;	
	// pipe		  
	input [data_size-1:0] EX_ALU_result,EX_Ins;
    input [data_size-1:0] EX_Rt_data;
    input [pc_size-1:0] EX_PCplus8;
    input [4:0] EX_WR_out;
	input EX_JalCtrl,EX_LhCtrl,EX_ShCtrl;
	
	// WB
	output reg M_MemtoReg;	
	output reg M_RegWrite;	
	// M	
	output reg M_MemWrite,M_MemRead;		
	// pipe		  
	output reg [data_size-1:0] M_ALU_result,M_Ins;
	output reg [data_size-1:0] M_Rt_data;
	output reg [pc_size-1:0] M_PCplus8;
	output reg [4:0] M_WR_out;
	output reg M_JalCtrl,M_LhCtrl,M_ShCtrl;
	
	initial begin 
		M_JalCtrl = 0;
		M_LhCtrl = 0;
		M_ShCtrl = 0;
		M_RegWrite = 0 ;
		M_MemtoReg = 0 ;
		M_MemRead =0 ;
		M_MemWrite = 0 ;
        M_ALU_result = 32'b0; 
        M_Rt_data = 32'b0; 
		M_PCplus8 = 32'b0;
		M_WR_out = 5'b0;
		M_Ins = 0 ;
    end 
	
	always @(negedge clk ) begin	
		if(rst)begin
			M_JalCtrl <= 0;
			M_LhCtrl <= 0;
			M_ShCtrl <= 0;
			M_RegWrite <= 0 ;
			M_MemtoReg <= 0 ;
			M_MemRead <=0 ;
			M_MemWrite <= 0 ;
			M_ALU_result <= 32'b0; 
			M_Rt_data <= 32'b0; 
			M_PCplus8 <= 32'b0;
			M_WR_out <= 5'b0;
			M_Ins <= 0 ;
		end
		else if(stall) begin
			M_JalCtrl <= M_JalCtrl;
			M_LhCtrl <= M_LhCtrl;
			M_ShCtrl <= M_ShCtrl;
			M_RegWrite <= M_RegWrite ;
			M_MemtoReg <= M_MemtoReg ;
			M_MemRead <= M_MemRead;
			M_MemWrite <= M_MemWrite ;
			M_ALU_result <= M_ALU_result; 
			M_Rt_data <= M_Rt_data; 
			M_PCplus8 <= M_PCplus8;
			M_WR_out <= M_WR_out;
			M_Ins <= M_Ins;
		end	
		else begin
			M_JalCtrl <=EX_JalCtrl;
			M_LhCtrl <= EX_LhCtrl;
			M_ShCtrl <= EX_ShCtrl;
			M_RegWrite <= EX_RegWrite ;
			M_MemtoReg <= EX_MemtoReg ;
			M_MemRead <= EX_MemRead;
			M_MemWrite <= EX_MemWrite ;
			M_ALU_result <= EX_ALU_result; 
			M_Rt_data <= EX_Rt_data; 
			M_PCplus8 <= EX_PCplus8;
			M_WR_out <= EX_WR_out;
			M_Ins <= EX_Ins;
		end	
	end	
endmodule


























