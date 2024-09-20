module b10(r_button, g_button, key, start, reset, test, cts, ctr, rts, rtr, clock, v_in, v_out);
input clock;
input reset;
input r_button;
input g_button;
input key;
input start;
input test;
input rts;
input rtr;
input [3:0] v_in;


output reg [3:0] v_out;
reg [3:0] stato;
reg voto0, voto1, voto2, voto3;
reg [3:0] sign;
reg last_g, last_r;
output reg cts;
output reg ctr;


parameter STARTUP = 0;
parameter STANDBY = 1;
parameter GET_IN = 2;
parameter START_TX = 3;
parameter SEND = 4;
parameter TX_2_RX = 5;
parameter RECEIVE = 6;
parameter RX_2_TX = 7;
parameter END_TX = 8;
parameter TEST_1 = 9;
parameter TEST_2 = 10;

always @(posedge reset, posedge clock) begin //: P1
	
	
    if(reset == 1'b1) begin
		stato <= STARTUP;
		voto0 = 1'b0;
		voto1 = 1'b0;
		voto2 = 1'b0;
		voto3 = 1'b0;
		sign <= 4'b0000;
		last_g <= 1'b0;
		last_r <= 1'b0;
		cts <= 1'b0;
		ctr <= 1'b0;
		v_out <= 4'b0000;
		end else begin
		case(stato)
			STARTUP : begin
				voto0 = 1'b0;//Blocking because it is checked in the same state 
				voto1 = 1'b0;
				voto2 = 1'b0;
				voto3 = 1'b0;
				cts <= 1'b0;
				ctr <= 1'b0;
				if((test == 1'b0)) begin
					sign <= 4'b0000;
					stato <= TEST_1;
				end
				else begin
					voto0 = 1'b0;
					voto1 = 1'b0;
					voto2 = 1'b0;
					voto3 = 1'b0;
					stato <= STANDBY;
				end
			end
			STANDBY : begin
				if(start == 1'b1) begin
					voto0 = 1'b0;
					voto1 = 1'b0;
					voto2 = 1'b0;
					voto3 = 1'b0;
					stato <= GET_IN;
				end
				if(rtr == 1'b1) begin
					cts <= 1'b1;
				end
				if(rtr == 1'b0) begin
					cts <= 1'b0;
				end
			end
			GET_IN : begin
				if(start == 1'b0) begin
					stato <= START_TX;
				end
				else if(key == 1'b1) begin
					voto0 <= key;
					if(((g_button ^ last_g) & (g_button)) == 1'b1) begin
						voto1 <=  ~voto1;
					end
					if(((r_button ^ last_r) & (r_button)) == 1'b1) begin
						voto2 <=  ~voto2;
					end
					last_g <= g_button;
					last_r <= r_button;
				end
				else begin
					voto0 = 1'b0;
					voto1 = 1'b0;
					voto2 = 1'b0;
					voto3 = 1'b0;
				end
			end
			START_TX : begin
				voto3 = voto0 ^ (voto1 ^ voto2);
				stato <= SEND;
				voto0 = 1'b0;
			end
			SEND : begin
				if(rtr == 1'b1) begin
					v_out[0] <= voto0;
					v_out[1] <= voto1;
					v_out[2] <= voto2;
					v_out[3] <= voto3;
					cts <= 1'b1;
					if(voto0 == 1'b0 && voto1 == 1'b1 && voto2 == 1'b1 && voto3 == 1'b0) begin
						stato <= END_TX;
					end
					else begin
						stato <= TX_2_RX;
					end
				end
			end
			TX_2_RX : begin
				if(rts == 1'b0) begin
					ctr <= 1'b1;
					stato <= RECEIVE;
				end
			end
			RECEIVE : begin
				if(rts == 1'b1) begin
					voto0 = v_in[0];
					voto1 = v_in[1];
					voto2 = v_in[2];
					voto3 = v_in[3];
					ctr <= 1'b0;
					stato <= RX_2_TX;
				end
			end
			RX_2_TX : begin
				if(rtr == 1'b0) begin
					cts <= 1'b0;
					stato <= SEND;
				end
			end
			END_TX : begin
				if(rtr == 1'b0) begin
					cts <= 1'b0;
					stato <= STANDBY;
				end
			end
			TEST_1 : begin
				voto0 = v_in[0];
				voto1 = v_in[1];
				voto2 = v_in[2];
				voto3 = v_in[3];
				sign <= 4'b1000;
				if(voto0 == 1'b1 && voto1 == 1'b1 && voto2 == 1'b1 && voto3 == 1'b1) begin
					stato <= TEST_2;
				end
			end
			TEST_2 : begin
				voto0 = 1'b1 ^ sign[0];
				voto0 = 1'b0 ^ sign[1];
				voto0 = 1'b0 ^ sign[2];
				voto0 = 1'b1 ^ sign[3];
				stato <= SEND;
			end
		endcase
	end
end


endmodule
