module b13(reset, eoc, soc, load_dato, add_mpx2, canale, mux_en, clock, data_in, dsr, errorr, data_out);

input clock;
input reset;
input eoc;
input dsr;
input [7:0] data_in;

output reg soc;
output reg load_dato;
output reg add_mpx2;
output reg mux_en;
output reg errorr;
output reg data_out;
output reg [3:0] canale;


parameter GP001 = 0;
parameter GP010 = 1;
parameter GP011 = 2;
parameter GP100 = 3;
parameter GP100w = 4;
parameter GP101 = 5;
parameter GP110 = 6;
parameter GP111 = 7;

parameter GP01 = 0;
parameter GP10 = 1;
parameter GP11 = 2;
parameter GP11w = 3;

parameter START_BIT = 0;
parameter STOP_BIT = 1;
parameter BIT0 = 2;
parameter BIT1 = 3;
parameter BIT2 = 4;
parameter BIT3 = 5;
parameter BIT4 = 6;
parameter BIT5 = 7;
parameter BIT6 = 8;
parameter BIT7 = 9;

parameter G_IDLE = 0;
parameter G_LOAD = 1;
parameter G_SEND = 2;
parameter G_WAIT_END = 3;

parameter DelayTime = 104;  //moved from 243
reg [3:0] S1;
reg [3:0] S2;
reg mpx; 
reg rdy;
reg send_data;

reg confirm;
reg shot;

reg send_en;
reg tre;
reg [7:0] out_reg;
reg [3:0] next_bit;
reg tx_end;
reg [1:0] itfc_state;
reg send; reg load;
reg [31:0] tx_conta;
reg [7:0] conta_tmp;
always @(posedge reset, posedge clock) begin //: P1
	
	
    if(reset == 1'b1) begin
		S1 <= GP001;
		soc <= 1'b0;
		canale <= 0;
		conta_tmp <= 0;
		send_data <= 1'b0;
		load_dato <= 1'b0;
		mux_en <= 1'b0;
		end else begin
		case(S1)
			GP001 : begin
				mux_en <= 1'b1;
				S1 <= GP010;
			end
			GP010 : begin
				S1 <= GP011;
			end
			GP011 : begin
				soc <= 1'b1;
				S1 <= GP101;
			end
			GP101 : begin
				if(eoc == 1'b1) begin
					S1 <= GP101;
				end
				else begin
					load_dato <= 1'b1;
					S1 <= GP110;
					mux_en <= 1'b0;
				end
			end
			GP110 : begin
				load_dato <= 1'b0;
				soc <= 1'b0;
				conta_tmp = conta_tmp + 1;//blocking because values is checked in the same state
				if(conta_tmp == 8) begin
					conta_tmp = 0;
				end
				canale <= conta_tmp;
				S1 <= GP111;
			end
			GP111 : begin
				send_data <= 1'b1;
				S1 <= GP100w;
			end
			GP100w : begin
				S1 <= GP100;
			end
			GP100 : begin
				if(rdy == 1'b0) begin
					S1 <= GP100;
				end
				else begin
					S1 <= GP001;
					send_data <= 1'b0;
				end
			end
			default : begin
			end
		endcase
	end
end

always @(posedge reset, posedge clock) begin
    if(reset == 1'b1) begin
		S2 <= GP01;
		rdy <= 1'b0;
		add_mpx2 <= 1'b0;
		mpx <= 1'b0;
		shot <= 1'b0;
		end else begin
		case(S2)
			GP01 : begin
				if(send_data == 1'b1) begin
					rdy <= 1'b1;
					S2 <= GP10;
				end
				else begin
					S2 <= GP01;
				end
			end
			GP10 : begin
				shot <= 1'b1;
				S2 <= GP11;
			end
			GP11 : begin
				if(confirm == 1'b0) begin
					shot <= 1'b0;
					S2 <= GP11;
				end
				else begin
					if(mpx == 1'b0) begin
						add_mpx2 <= 1'b1;
						mpx <= 1'b1;
						S2 <= GP10;
					end
					else begin
						mpx <= 1'b0;
						rdy <= 1'b0;
						S2 <= GP11w;
					end
				end
			end
			GP11w : begin
				S2 <= GP01;
			end
			default : begin
			end
		endcase
	end
end

always @(posedge clock, posedge reset) begin
    if(reset == 1'b1) begin
		load <= 1'b0;
		send <= 1'b0;
		confirm <= 1'b0;
		itfc_state <= G_IDLE;
		end else begin
		case(itfc_state)
			G_IDLE : begin
				if(shot == 1'b1) begin
					load <= 1'b1;
					confirm <= 1'b0;
					itfc_state <= G_LOAD;
				end
				else begin
					confirm <= 1'b0;
					itfc_state <= G_IDLE;
				end
			end
			G_LOAD : begin
				load <= 1'b0;
				send <= 1'b1;
				itfc_state <= G_SEND;
			end
			G_SEND : begin
				send <= 1'b0;
				itfc_state <= G_WAIT_END;
			end
			G_WAIT_END : begin
				if(tx_end == 1'b1) begin
					confirm <= 1'b1;
					itfc_state <= G_IDLE;
				end
			end
			default : begin
			end
		endcase
	end
end

always @(posedge clock, posedge reset) begin
    if(reset == 1'b1) begin
		send_en <= 1'b0;
		out_reg <= 8'b00000000;
		tre <= 1'b0;
		errorr <= 1'b0;
		end else begin
		if(tx_end == 1'b1) begin
			send_en <= 1'b0;
			tre <= 1'b1;
		end
		if(load == 1'b1) begin
			if(tre == 1'b0) begin
				out_reg <= data_in;
				tre <= 1'b1;
				errorr <= 1'b0;
			end
			else begin
				errorr <= 1'b1;
			end
		end
		if(send == 1'b1) begin
			if(tre == 1'b0 || dsr == 1'b0) begin
				errorr <= 1'b1;
			end
			else begin
				errorr <= 1'b0;
				send_en <= 1'b1;
			end
		end
	end
end

always @(posedge clock, posedge reset) begin
    if(reset == 1'b1) begin
		tx_end <= 1'b0;
		data_out <= 1'b0;
		next_bit <= START_BIT;
		tx_conta <= 0;
		end else begin
		tx_end <= 1'b0;
		data_out <= 1'b1;
		if(send_en == 1'b1) begin
			if(tx_conta > DelayTime) begin
				case(next_bit)
					START_BIT : begin
						data_out <= 1'b0;
						next_bit <= BIT0;
					end
					BIT0 : begin
						data_out <= out_reg[7];
						next_bit <= BIT1;
					end
					BIT1 : begin
						data_out <= out_reg[6];
						next_bit <= BIT2;
					end
					BIT2 : begin
						data_out <= out_reg[5];
						next_bit <= BIT3;
					end
					BIT3 : begin
						data_out <= out_reg[4];
						next_bit <= BIT4;
					end
					BIT4 : begin
						data_out <= out_reg[3];
						next_bit <= BIT5;
					end
					BIT5 : begin
						data_out <= out_reg[2];
						next_bit <= BIT6;
					end
					BIT6 : begin
						data_out <= out_reg[1];
						next_bit <= BIT7;
					end
					BIT7 : begin
						data_out <= out_reg[0];
						next_bit <= STOP_BIT;
					end
					STOP_BIT : begin
						data_out <= 1'b1;
						next_bit <= START_BIT;
						tx_end <= 1'b1;
					end
				endcase
				tx_conta <= 0;
			end
			else begin
				tx_conta <= tx_conta + 1;
			end
		end
	end
end


endmodule

