// Cache Control

module Cache_Control ( 
					   clk,
					   rst,
					   // input
					   en_R,
					   en_W,
					   hit,
					   // ack,//from mem 
					   // output
					   Read_mem,
					   Write_mem,
					   Valid_enable,
					   Tag_enable,
					   Data_enable,
					   sel_mem_core,
					   stall
					   );
	
	input clk, rst;
	input en_R;  
	input en_W;  
    input hit;
	//input ack;
	
	output reg Read_mem; //mem_en_R
	output reg Write_mem; //mem_en_W
	output reg Valid_enable;
	output reg Tag_enable;
	output reg Data_enable;
	output reg sel_mem_core;		// 0 data from mem, 1 data from core
	output reg stall; //stall cpu	
	
	reg [1:0] cur_state,next_state ;
	
	
	parameter R_idle=2'd0,
			  R_wait=2'd1,
			  R_Read_data=2'd2;
			  
	
	wire Read_miss,Write_miss,Write_hit,Read_hit;		  
			  
	assign Read_miss=(en_R && !hit);
	assign Read_hit=(en_R && hit);
	assign Write_miss=(en_W && !hit);
	assign Write_hit=(en_W && hit);		
	
	
	/* 2 always
	// state reg
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			cur_state <=R_idle;	
		end
		else begin		
			case(cur_state)
				R_idle:begin
					if(Read_miss)begin      //Read_miss					   
						cur_state <=R_wait;	//next state
					end
					else begin               
						cur_state <=R_idle;  // Read hit	
					end
				end
				R_wait:begin					
						cur_state <=R_Read_data;										
				end	
				R_Read_data:begin				
					cur_state <=R_idle; 					
				end				
			endcase	
		end
	end	//end always
	
	//output logic
	always @ (*) begin
		if (rst) begin
			Read_mem <=0; //mem_en_R
			Write_mem <=0; //mem_en_W
			Valid_enable <=0;
			Tag_enable <=0;
			Data_enable <=0;
			sel_mem_core <=0;		// 0 data from mem, 1 data from core
			stall <=0; //stall cpu  //next state R_idle
		end	
		else if(Write_miss)begin//write miss
			Read_mem <=0; //mem_en_R
			Write_mem <=1; //mem_en_W
			Valid_enable <=0;
			Tag_enable <=0;
			Data_enable <=0;
			sel_mem_core <=0;		// 0 data from mem, 1 data from core
			stall <=0; //stall cpu
		end
		else if(Write_hit)begin //write hit
			Read_mem <=0; //mem_en_R
			Write_mem <=1; //mem_en_W
			Valid_enable <=1;
			Tag_enable <=1;
			Data_enable <=1;
			sel_mem_core <=1;		// 0 data from mem, 1 data from core
			stall <=0; //stall cpu
		end
	   else begin
			case (cur_state)
			R_idle	: begin
						if(Read_miss)begin //check if Read_miss
							Read_mem <=1; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=0;
							Tag_enable <=0;
							Data_enable <=0;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=1; //stall cpu  //next state R_wait
						end
						else begin //Read_hit
							Read_mem <=0; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=0;
							Tag_enable <=0;
							Data_enable <=0;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=0; //stall cpu  //next state R_Read_data
						end						
					end			
			R_wait	 : begin
							Read_mem <=0; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=0;
							Tag_enable <=0;
							Data_enable <=0;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=1; //stall cpu  //next state R_Read_data
						end
		 R_Read_data : begin
							Read_mem <=0; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=1;
							Tag_enable <=1;
							Data_enable <=1;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=1; //stall cpu  //next state Idle
						end
			endcase
	    end
	end	*/
	
	//3 always way 
	// state reg
   always@(posedge clk or negedge rst)
     if (rst)  cur_state <= R_idle;
   else        cur_state <= next_state;
	
	// next state reg
	always @ (*) begin				
			case(cur_state)
				R_idle:begin
					if(Read_miss)begin      //Read_miss					   
						next_state <=R_wait;	//next state
					end
					else begin               
						next_state <=R_idle;  // Read hit	
					end
				end
				R_wait:begin					
						next_state <=R_Read_data;										
				end	
				R_Read_data:begin				
						next_state <=R_idle; 					
				end				
			endcase	
		
	end	//end always
	
	//output logic
	always @ (*) begin
		if (rst) begin
			Read_mem <=0; //mem_en_R
			Write_mem <=0; //mem_en_W
			Valid_enable <=0;
			Tag_enable <=0;
			Data_enable <=0;
			sel_mem_core <=0;		// 0 data from mem, 1 data from core
			stall <=0; //stall cpu  //next state R_idle
		end	
		else if(Write_miss)begin//write miss
			Read_mem <=0; //mem_en_R
			Write_mem <=1; //mem_en_W
			Valid_enable <=0;
			Tag_enable <=0;
			Data_enable <=0;
			sel_mem_core <=0;		// 0 data from mem, 1 data from core
			stall <=0; //stall cpu
		end
		else if(Write_hit)begin //write hit
			Read_mem <=0; //mem_en_R
			Write_mem <=1; //mem_en_W
			Valid_enable <=1;
			Tag_enable <=1;
			Data_enable <=1;
			sel_mem_core <=1;		// 0 data from mem, 1 data from core
			stall <=0; //stall cpu
		end
	   else begin
			case (cur_state)
			R_idle	: begin
						if(Read_miss)begin //check if Read_miss
							Read_mem <=1; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=0;
							Tag_enable <=0;
							Data_enable <=0;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=1; //stall cpu  //next state R_wait
						end
						else begin //Read_hit
							Read_mem <=0; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=0;
							Tag_enable <=0;
							Data_enable <=0;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=0; //stall cpu  //next state R_Read_data
						end						
					end			
			R_wait	 : begin
							Read_mem <=0; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=0;
							Tag_enable <=0;
							Data_enable <=0;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=1; //stall cpu  //next state R_Read_data
						end
		 R_Read_data : begin
							Read_mem <=0; //mem_en_R
							Write_mem <=0; //mem_en_W
							Valid_enable <=1;
							Tag_enable <=1;
							Data_enable <=1;
							sel_mem_core <=0;		// 0 data from mem, 1 data from core
							stall <=1; //stall cpu  //next state Idle
						end
			endcase
	    end
	end		
	
endmodule
