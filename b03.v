module b03(clock, reset, request1, request2, request3, request4, grant_o);


input clock;
input reset;
input request1;
input request2;
input request3;
input request4;
output reg [3:0] grant_o;


parameter INIT = 0;
parameter ANALISI_REQ = 1;
parameter ASSIGN = 2;
parameter U1 = 3'b100;
parameter U2 = 3'b010;
parameter U3 = 3'b001;
parameter U4 = 3'b111;


reg [2:0] coda0;
reg [2:0] coda1;
reg [2:0] coda2;
reg [2:0] coda3;
reg [1:0] stato;
reg ru1, ru2, ru3, ru4;
reg fu1, fu2, fu3, fu4;
reg [3:0] grant;

always @(posedge clock, posedge reset) begin //: P1
	
	
    if(reset == 1'b1) begin
		stato <= INIT;
		coda0 <= 3'b000;
		coda1 <= 3'b000;
		coda2 <= 3'b000;
		coda3 <= 3'b000;
		ru1 <= 1'b0;
		fu1 <= 1'b0;
		ru2 <= 1'b0;
		fu2 <= 1'b0;
		ru3 <= 1'b0;
		fu3 <= 1'b0;
		ru4 <= 1'b0;
		fu4 <= 1'b0;
		grant <= 4'b0000;
		grant_o <= 4'b0000;
		end else begin
		case(stato)
			INIT : begin
				ru1 <= request1;
				ru2 <= request2;
				ru3 <= request3;
				ru4 <= request4;
				stato <= ANALISI_REQ;
			end
			ANALISI_REQ : begin
				grant_o <= grant;
				if((ru1 == 1'b1)) begin
					if((fu1 == 1'b0)) begin
						coda3 <= coda2;
						coda2 <= coda1;
						coda1 <= coda0;
						coda0 <= U1;
					end
				end
				else if((ru2 == 1'b1)) begin
					if((fu2 == 1'b0)) begin
						coda3 <= coda2;
						coda2 <= coda1;
						coda1 <= coda0;
						coda0 <= U2;
					end
				end
				else if((ru3 == 1'b1)) begin
					if((fu3 == 1'b0)) begin
						coda3 <= coda2;
						coda2 <= coda1;
						coda1 <= coda0;
						coda0 <= U3;
					end
				end
				else if((ru4 == 1'b1)) begin
					if((fu4 == 1'b0)) begin
						coda3 <= coda2;
						coda2 <= coda1;
						coda1 <= coda0;
						coda0 <= U4;
					end
				end
				fu1 <= ru1;
				fu2 <= ru2;
				fu3 <= ru3;
				fu4 <= ru4;
				stato <= ASSIGN;
			end
			ASSIGN : begin
				if(((fu1 | fu2 | fu3 | fu4) == 1'b1)) begin
					case(coda0)
						U1 : begin
							grant <= 4'b1000;
						end
						U2 : begin
							grant <= 4'b0100;
						end
						U3 : begin
							grant <= 4'b0010;
						end
						U4 : begin
							grant <= 4'b0001;
						end
						default : begin
							grant <= 4'b0000;
						end
					endcase
					coda0 <= coda1;
					coda1 <= coda2;
					coda2 <= coda3;
					coda3 <= 3'b000;
				end
				ru1 <= request1;
				ru2 <= request2;
				ru3 <= request3;
				ru4 <= request4;
				stato <= ANALISI_REQ;
			end
		endcase
	end
end

endmodule
