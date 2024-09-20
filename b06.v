module b06(cc_mux, eql, uscite, clock, enable_count, ackout, reset, cont_eql);

input clock;
input reset;
input eql;
input cont_eql;

output reg [2:1] cc_mux;
output reg [2:1] uscite;
output reg enable_count;
output reg ackout;


parameter s_init = 0;
parameter s_wait = 1;
parameter s_enin = 2;
parameter s_enin_w = 3;
parameter s_intr = 4;
parameter s_intr_1 = 5;
parameter s_intr_w = 6;
//parameter cc_nop = 2'b01;
parameter cc_enin = 2'b01;
parameter cc_intr = 2'b10;
parameter cc_ackin = 2'b11;
parameter out_norm = 2'b01;
reg [2:0] state;
always @(posedge reset, posedge clock) begin //: P1
	
	
    if(reset == 1'b1) begin
		state <= s_init;
		cc_mux <= 2'b00;
		enable_count <= 1'b0;
		ackout <= 1'b0;
		uscite <= 2'b00;
		end else begin
		if(cont_eql == 1'b1) begin
			ackout <= 1'b0;
			enable_count <= 1'b0;
		end
		else begin
			ackout <= 1'b1;
			enable_count <= 1'b1;
		end
		case(state)
			s_init : begin
				cc_mux <= cc_enin;
				uscite <= out_norm;
				state <= s_wait;
			end
			s_wait : begin
				if(eql == 1'b1) begin
					uscite <= 2'b00;
					cc_mux <= cc_ackin;
					state <= s_enin;
				end
				else begin
					uscite <= out_norm;
					cc_mux <= cc_intr;
					state <= s_intr_1;
				end
			end
			s_intr_1 : begin
				if(eql == 1'b1) begin
					uscite <= 2'b00;
					cc_mux <= cc_ackin;
					state <= s_intr;
				end
				else begin
					uscite <= out_norm;
					cc_mux <= cc_enin;
					state <= s_wait;
				end
			end
			s_enin : begin
				if(eql == 1'b1) begin
					uscite <= 2'b00;
					cc_mux <= cc_ackin;
					state <= s_enin;
				end
				else begin
					uscite <= 2'b01;
					ackout <= 1'b1;
					enable_count <= 1'b1;
					cc_mux <= cc_enin;
					state <= s_enin_w;
				end
			end
			s_enin_w : begin
				if(eql == 1'b1) begin
					uscite <= 2'b01;
					cc_mux <= cc_enin;
					state <= s_enin_w;
				end
				else begin
					uscite <= out_norm;
					cc_mux <= cc_enin;
					state <= s_wait;
				end
			end
			s_intr : begin
				if(eql == 1'b1) begin
					uscite <= 2'b00;
					cc_mux <= cc_ackin;
					state <= s_intr;
				end
				else begin
					uscite <= 2'b11;
					cc_mux <= cc_intr;
					state <= s_intr_w;
				end
			end
			s_intr_w : begin
				if(eql == 1'b1) begin
					uscite <= 2'b11;
					cc_mux <= cc_intr;
					state <= s_intr_w;
				end
				else begin
					uscite <= out_norm;
					cc_mux <= cc_enin;
					state <= s_wait;
				end
			end
		endcase
	end
end


endmodule
