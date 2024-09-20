module b07(punti_retta, start, reset, clock);

input clock;
input reset;
input start;

output reg [7:0] punti_retta;

parameter lung_mem = 15;  

parameter S_RESET = 0;
parameter S_START = 1;
parameter S_LOAD_X = 2;
parameter S_UPDATE_MAR = 3;
parameter S_LOAD_Y = 4;
parameter S_CALC_RETTA = 5;
parameter S_INCREMENTA = 6;


reg [7:0] mem [0:15];
reg [2:0] stato;
reg [7:0] cont, x, y, t;
reg [4:0] mar;

initial
begin
	
	mem[0] = 1;
	mem[1] = 255;
	mem[2] = 0;
	mem[3] = 0;
	mem[4] = 0;
	mem[5] = 2;
	mem[6] = 0;
	mem[7] = 0;
	mem[8] = 0;
	mem[9] = 2;
	mem[10] = 255;
	mem[11] = 5;
	mem[12] = 0;
	mem[13] = 2;
	mem[14] = 0;
	mem[15] = 2;
end


always @(posedge reset, posedge clock) begin //: P1
    
	
    if(reset == 1'b1) begin
		stato <= S_RESET;
		punti_retta <= 0;
		cont <= 0;
		mar <= 0;
		x <= 0;
		y <= 0;
		t <= 0;
		end else begin
		case(stato)
			S_RESET : begin
				stato <= S_START;
			end
			S_START : begin
				if(start == 1'b1) begin
					cont <= 0;
					mar <= 0;
					stato <= S_LOAD_X;
				end
				else begin
					stato <= S_START;
					punti_retta <= 0;
				end
			end
			S_LOAD_X : begin
				x <= mem[mar];
				stato <= S_UPDATE_MAR;
			end
			S_UPDATE_MAR : begin
				mar <= (mar + 1) % 16;
				t <= (x % 128) + (x % 128);
				stato <= S_LOAD_Y;
			end
			S_LOAD_Y : begin
				y <= mem[mar];
				x <= (x % 128) + (t % 128);
				stato <= S_CALC_RETTA;
			end
			S_CALC_RETTA : begin
				x <= (x % 128) + (y % 128);
				stato <= S_INCREMENTA;
			end
			S_INCREMENTA : begin
				if(mar != lung_mem) begin
					if((x == 2)) begin
						cont <= (cont + 1) % 256;
						mar <= (mar + 1) % 16;
						stato <= S_LOAD_X;
					end
					else begin
						mar <= (mar + 1) % 16;
						stato <= S_LOAD_X;
					end
				end
				else begin
					if(start == 1'b0) begin
						if((x == 2)) begin
							punti_retta <= (cont % 2 ** 8) + 1;
							stato <= S_START;
						end
						else begin
							punti_retta <= cont;
							stato <= S_START;
						end
					end
					else begin
						stato <= S_INCREMENTA;
					end
				end
			end
		endcase
	end
end


endmodule
