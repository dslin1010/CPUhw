// Instruction Memory

module IM (	clk,
			rst,
			IM_Address,
			IM_en_Read,
			Instruction
			//ack
			);

	parameter bit_size = 32;
	parameter mem_size = 16;

	input  clk, rst;
	input  [mem_size-1:0] IM_Address;
	input  IM_en_Read;
	
	output [bit_size-1:0] Instruction;
	//output reg ack;
	
	reg [bit_size-1:0] IM_data [0:( 2**mem_size-1 )];	
	
	// state
	parameter Idle		 = 0,
			  Read_data  = 1;
	
	reg nxt_state;
	reg cur_state;
	reg [mem_size-1:0] r_IM_Addr;
	
	assign Instruction = IM_data[r_IM_Addr];
	
	// FSM
	always @ (*) begin
		case (cur_state)
		Idle		 : nxt_state = IM_en_Read ?
								   Read_data : Idle;
		Read_data	 : nxt_state = Idle;
		endcase
	end	
	
	// reg
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			r_IM_Addr <= 0;
			cur_state <= Idle;					
		end
		else begin
			// read
			if (cur_state==Read_data)
				r_IM_Addr <= IM_Address;
			cur_state <= nxt_state;
		end
		
	end
	
	/* always @ (posedge clk or posedge rst) begin
		if (rst) begin
			r_IM_Addr <= 0;			
			cur_state <= Idle;					
		end
		else begin
			case(cur_state)
				Idle:begin
					if(IM_en_Read)begin
						r_IM_Addr <= IM_Address;						
						cur_state <= Read_data;
					end
					else begin										
						cur_state <= Idle;
					end
				end
				Read_data:begin
					if(IM_en_Read)begin
						r_IM_Addr <= IM_Address;						
						cur_state <= Read_data;
					end
					else begin											
						cur_state <= Idle;
					end
				end
			endcase
		end		
	end*/
	
/*  //output logic
	always @ (*) begin
		case(cur_state)
			Idle   :begin
				    r_IM_Addr <= 0;
					ack <=0;
				   end
	   Read_data   :begin
				    //r_IM_Addr <= IM_Address;
					Instruction <= IM_data[IM_Address];
					ack <=1;
				   end
		endcase
	end
	
	// reg
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			r_IM_Addr <= 0;
			ack <=0;
			cur_state <= Idle;					
		end
		else begin
			case(cur_state)
				Idle:begin
					if(IM_en_Read)begin
						cur_state <= Read_data;
					end
					else begin
						cur_state <= Idle;
					end
				end
				Read_data:begin
						cur_state <= Idle;
				end
			endcase
		end		
	end
	
	//output logic
	always @ (*) begin
		case(cur_state)
			Idle   :begin
				    r_IM_Addr <= 0;
					ack <=0;
				   end
	   Read_data   :begin
				    //r_IM_Addr <= IM_Address;
					Instruction <= IM_data[IM_Address];
					ack <=1;
				   end
		endcase
	end*/
	
endmodule





