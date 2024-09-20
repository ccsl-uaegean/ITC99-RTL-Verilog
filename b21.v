module b14(clock, reset, addr, datai, datao, rd, wr);

input clock;
input reset;
input [31:0] datai;

output reg [19:0] addr;
output reg [31:0] datao;
output reg rd;
output reg wr;



parameter FETCH = 0;
parameter EXEC = 1;
parameter ZERO = 0;  //added to alter the WHEN cases so the converter won't complain
parameter ONE = 1;
parameter TWO = 2;
parameter THREE = 3;
parameter FOUR = 4;
parameter FIVE = 5;
parameter SIX = 6;
parameter SEVEN = 7;
parameter EIGHT = 8;
parameter NINE = 9;
parameter TEN = 10;
parameter ELEVEN = 11;
parameter TWELVE = 12;
parameter THIRTEEN = 13;
parameter FOURTEEN = 14;
parameter FIFTEEN = 15;

reg  [31:0] reg0;
reg  [31:0] reg1;
reg  [31:0] reg2;
reg  [31:0] reg3;

reg B;

reg [31:0] MAR;
reg [31:0] MBR;

reg [31:0] mf;
reg [31:0] df;
reg [31:0] cf;

reg [31:0] ff;
reg [31:0] tail;
reg signed [31:0] IR;

reg state;


reg signed [31:0] r,m;
reg [31:0] d,t;
reg [31:0] temp;
reg [31:0] s;
//reg [8*31:1] string_value;  

wire signed [31:0] tsign = t;
always @(posedge clock, posedge reset) begin //: P1
    
    if(reset == 1'b1) begin
		MAR = 0;
		MBR = 0;
		IR = 0;
		d = 0;
		r = 0;
		m = 0;
		s = 0;
		t = 0;//added
		temp = 0;
		mf = 0;
		df = 0;
		ff = 0;
		cf = 0;
		tail = 0;
		B = 1'b0;
		reg0 = 0;
		reg1 = 0;
		reg2 = 0;
		reg3 = 0;
		addr <= 0;
		rd <= 1'b0;
		wr <= 1'b0;
		datao <= 0;
		state = FETCH;
		end else begin
		rd <= 1'b0;
		wr <= 1'b0;
		case(state)
			FETCH : begin
				MAR = reg3 % 2 ** 20;
				MBR = datai;
				addr <= MAR;
				rd <= 1'b1;
				
				IR <= MBR;
				state = EXEC;
			end
			EXEC : begin
				if(IR < 0) begin
					IR =  -IR;
				end
				mf = (IR / 2 ** 27) % 4;
				df = (IR / 2 ** 24) % 2 ** 3;
				ff = (IR / 2 ** 19) % 2 ** 4;
				cf = (IR / 2 ** 23) % 2;
				tail = IR % 2 ** 20;
				reg3 = (reg3 % 2 ** 29) + 8;
				s = (IR / 2 ** 29) % 4;
				case(s)
					ZERO : begin
						r = reg0;
					end
					ONE : begin
						r = reg1;
					end
					TWO : begin
						r = reg2;
					end
					THREE : begin
						r = reg3;
					end
				endcase
				case(cf)
					ONE : begin
						case(mf)
							ZERO : begin
								m = tail;
							end
							ONE : begin
								m = datai;
								addr <= tail;
								rd <= 1'b1;
							end
							TWO : begin
								addr <= (tail + reg1) % 2 ** 20;
								rd <= 1'b1;
								m = datai;
							end
							THREE : begin
								addr <= (tail + reg2) % 2 ** 20;
								rd <= 1'b1;
								m = datai;
							end
						endcase
						case(ff)
							ZERO : begin
								if(r < m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							ONE : begin
								if(!(r < m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							TWO : begin
								if(r == m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							THREE : begin
								if(!(r == m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FOUR : begin
								if(!(r > m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FIVE : begin
								if(r > m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							SIX : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if(r < m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							SEVEN : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if(!(r < m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							EIGHT : begin
								if((r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							NINE : begin
								if(!(r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							TEN : begin
								if((r == m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							ELEVEN : begin
								if(!(r == m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							TWELVE : begin
								if(!(r > m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							THIRTEEN : begin
								if((r > m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FOURTEEN : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if((r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FIFTEEN : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if(!(r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
						endcase
					end
					ZERO : begin
						if(!(df == 7)) begin
							if(df == 5) begin
								if(( ~(B)) == 1'b1) begin
									d = 3;
								end
							end
							else if(df == 4) begin
								if(B == 1'b1) begin
									d = 3;
								end
							end
							else if(df == 3) begin
								d = 3;
							end
							else if(df == 2) begin
								d = 2;
							end
							else if(df == 1) begin
								d = 1;
							end
							else if(df == 0) begin
								d = 0;
							end
							case(ff)
								ZERO : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									t = 0;//edited
									case(d)
										ZERO : begin
											reg0 = t - m;
										end
										ONE : begin
											reg1 = t - m;
										end
										TWO : begin
											reg2 = t - m;
										end
										THREE : begin
											reg3 = t - m;
										end
										default : begin
										end
									endcase
								end
								ONE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									reg2 = reg3;
									reg3 = m;
								end
								TWO : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											reg0 = m;
										end
										ONE : begin
											reg1 = m;
										end
										TWO : begin
											reg2 = m;
										end
										THREE : begin
											reg3 = m;
										end
										default : begin
										end
									endcase
								end
								THREE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											reg0 = m;
										end
										ONE : begin
											reg1 = m;
										end
										TWO : begin
											reg2 = m;
										end
										THREE : begin
											reg3 = m;
										end
										default : begin
										end
									endcase
								end
								FOUR : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								FIVE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								SIX : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r - m;
											reg0 = temp[29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = r - m;
											reg1 = temp[29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = r - m;
											reg2 = temp[29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = r - m;
											reg3 = temp[29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								SEVEN : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r - m;
											reg0 = temp [29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = r - m;
											reg1 = temp [29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = r - m;
											reg2 = temp [29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = r - m;
											reg3 = temp [29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								EIGHT : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								NINE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = (r - m);
											reg0 = temp [29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = (r - m);
											reg1 = temp [29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = (r - m);
											reg2 = temp [29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = (r - m);
											reg3 = temp [29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								TEN : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								ELEVEN : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = (r - m);
											reg0 = temp [29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = (r - m);
											reg1 = temp [29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = (r - m);
											reg2 = temp [29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = (r - m);
											reg3 = temp [29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								TWELVE : begin
									case(mf)
										ZERO : begin
											t = r / 2;
										end
										ONE : begin
											t = r / 2;
											if(B == 1'b1) begin
												t = t [28:0];
											end
										end
										TWO : begin
											t = (r[28:0]) * 2;
										end
										THREE : begin
											t = (r[28:0]) * 2;
											if(tsign > (2 ** 30 - 1)) begin
												B = 1'b1;
											end
											else begin
												B = 1'b0;
											end
										end
										default : begin
										end
									endcase
									case(d)
										ZERO : begin
											reg0 = t;
										end
										ONE : begin
											reg1 = t;
										end
										TWO : begin
											reg2 = t;
										end
										THREE : begin
											reg3 = t;
										end
										default : begin
										end
									endcase
								end
								THIRTEEN,FOURTEEN,FIFTEEN : begin
								end
							endcase
						end
						else if(df == 7) begin
							case(mf)
								ZERO : begin
									m = tail;
								end
								ONE : begin
									m = tail;
								end
								TWO : begin
									m = (reg1 % 2 ** 20) + (tail % 2 ** 20);
								end
								THREE : begin
									m = (reg2 % 2 ** 20) + (tail % 2 ** 20);
								end
							endcase
							// addr <= m;
							addr <= m % 2 * 20;
							// removed (!)fs020699
							wr <= 1'b1;
							datao <= r;
						end
					end
				endcase
				state <= FETCH;
			end
		endcase
	end
end


endmodule

module b14_1(clock, reset, addr, datai, datao, rd, wr);

input clock;
input reset;
input [31:0] datai;

output reg [19:0] addr;
output reg [31:0] datao;
output reg rd;
output reg wr;



parameter FETCH = 0;
parameter EXEC = 1;
parameter ZERO = 0;  //added to alter the WHEN cases so the converter won't complain
parameter ONE = 1;
parameter TWO = 2;
parameter THREE = 3;
parameter FOUR = 4;
parameter FIVE = 5;
parameter SIX = 6;
parameter SEVEN = 7;
parameter EIGHT = 8;
parameter NINE = 9;
parameter TEN = 10;
parameter ELEVEN = 11;
parameter TWELVE = 12;
parameter THIRTEEN = 13;
parameter FOURTEEN = 14;
parameter FIFTEEN = 15;

reg  [31:0] reg0;
reg  [31:0] reg1;
reg  [31:0] reg2;
reg  [31:0] reg3;

reg B;

reg [31:0] MAR;
reg [31:0] MBR;

reg [31:0] mf;
reg [31:0] df;
reg [31:0] cf;

reg [31:0] ff;
reg [31:0] tail;
reg signed [31:0] IR;

reg state;


reg signed [31:0] r,m;
reg [31:0] d,t;
reg [31:0] temp;
reg [31:0] s;
//reg [8*31:1] string_value;  

wire signed [31:0] tsign = t;
always @(posedge clock, posedge reset) begin //: P1
    
    if(reset == 1'b1) begin
		MAR = 0;
		MBR = 0;
		IR = 0;
		d = 0;
		r = 0;
		m = 0;
		s = 0;
		t = 0;//added
		temp = 0;
		mf = 0;
		df = 0;
		ff = 0;
		cf = 0;
		tail = 0;
		B = 1'b0;
		reg0 = 0;
		reg1 = 0;
		reg2 = 0;
		reg3 = 0;
		addr <= 0;
		rd <= 1'b0;
		wr <= 1'b0;
		datao <= 0;
		state = FETCH;
		end else begin
		rd <= 1'b0;
		wr <= 1'b0;
		case(state)
			FETCH : begin
				MAR = reg3 [19:0];
				//MAR = reg3 % 2 ** 20;
				
				MBR = datai;
				addr <= MAR;
				rd <= 1'b1;
				
				IR <= MBR;
				state = EXEC;
			end
			EXEC : begin
				if(IR < 0) begin
					IR =  -IR;
				end
				mf = (IR / 2 ** 27) % 4;
				df = (IR / 2 ** 24) % 2 ** 3;
				ff = (IR / 2 ** 19) % 2 ** 4;
				cf = (IR / 2 ** 23) % 2;
				tail = IR % 2 ** 20;
				reg3 = (reg3 % 2 ** 29) + 8;
				s = (IR / 2 ** 29) % 4;
				case(s)
					ZERO : begin
						r = reg0;
					end
					ONE : begin
						r = reg1;
					end
					TWO : begin
						r = reg2;
					end
					THREE : begin
						r = reg3;
					end
				endcase
				case(cf)
					ONE : begin
						case(mf)
							ZERO : begin
								m = tail;
							end
							ONE : begin
								m = datai;
								addr <= tail;
								rd <= 1'b1;
							end
							TWO : begin
								addr <= (tail + reg1) % 2 ** 20;
								rd <= 1'b1;
								m = datai;
							end
							THREE : begin
								addr <= (tail + reg2) % 2 ** 20;
								rd <= 1'b1;
								m = datai;
							end
						endcase
						case(ff)
							ZERO : begin
								if(r < m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							ONE : begin
								if(!(r < m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							TWO : begin
								if(r == m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							THREE : begin
								if(!(r == m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FOUR : begin
								if(!(r > m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FIVE : begin
								if(r > m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							SIX : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if(r < m) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							SEVEN : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if(!(r < m)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							EIGHT : begin
								if((r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							NINE : begin
								if(!(r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							TEN : begin
								if((r == m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							ELEVEN : begin
								if(!(r == m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							TWELVE : begin
								if(!(r > m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							THIRTEEN : begin
								if((r > m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FOURTEEN : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if((r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
							FIFTEEN : begin
								if(r > (2 ** 30 - 1)) begin
									r = r - 2 ** 30;
								end
								if(!(r < m) || (B == 1'b1)) begin
									B = 1'b1;
								end
								else begin
									B = 1'b0;
								end
							end
						endcase
					end
					ZERO : begin
						if(!(df == 7)) begin
							if(df == 5) begin
								if(( ~(B)) == 1'b1) begin
									d = 3;
								end
							end
							else if(df == 4) begin
								if(B == 1'b1) begin
									d = 3;
								end
							end
							else if(df == 3) begin
								d = 3;
							end
							else if(df == 2) begin
								d = 2;
							end
							else if(df == 1) begin
								d = 1;
							end
							else if(df == 0) begin
								d = 0;
							end
							case(ff)
								ZERO : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									t = 0;//edited
									case(d)
										ZERO : begin
											reg0 = t - m;
										end
										ONE : begin
											reg1 = t - m;
										end
										TWO : begin
											reg2 = t - m;
										end
										THREE : begin
											reg3 = t - m;
										end
										default : begin
										end
									endcase
								end
								ONE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									reg2 = reg3;
									reg3 = m;
								end
								TWO : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											reg0 = m;
										end
										ONE : begin
											reg1 = m;
										end
										TWO : begin
											reg2 = m;
										end
										THREE : begin
											reg3 = m;
										end
										default : begin
										end
									endcase
								end
								THREE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											reg0 = m;
										end
										ONE : begin
											reg1 = m;
										end
										TWO : begin
											reg2 = m;
										end
										THREE : begin
											reg3 = m;
										end
										default : begin
										end
									endcase
								end
								FOUR : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								FIVE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								SIX : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r - m;
											reg0 = temp[29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = r - m;
											reg1 = temp[29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = r - m;
											reg2 = temp[29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = r - m;
											reg3 = temp[29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								SEVEN : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r - m;
											reg0 = temp [29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = r - m;
											reg1 = temp [29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = r - m;
											reg2 = temp [29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = r - m;
											reg3 = temp [29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								EIGHT : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								NINE : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = (r - m);
											reg0 = temp [29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = (r - m);
											reg1 = temp [29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = (r - m);
											reg2 = temp [29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = (r - m);
											reg3 = temp [29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								TEN : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = r + m;
											reg0 = temp [29:0];
											//reg0 = (r + m) % 2 ** 30;
										end
										ONE : begin
											temp = r + m;
											reg1 = temp [29:0];
											//reg1 = (r + m) % 2 ** 30;
										end
										TWO : begin
											temp = r + m;
											reg2 = temp [29:0];
											//reg2 = (r + m) % 2 ** 30;
										end
										THREE : begin
											temp = r + m;
											reg3 = temp [29:0];
											//reg3 = (r + m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								ELEVEN : begin
									case(mf)
										ZERO : begin
											m = tail;
										end
										ONE : begin
											m = datai;
											addr <= tail;
											rd <= 1'b1;
										end
										TWO : begin
											addr <= (tail + reg1) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
										THREE : begin
											addr <= (tail + reg2) % 2 ** 20;
											rd <= 1'b1;
											m = datai;
										end
									endcase
									case(d)
										ZERO : begin
											temp = (r - m);
											reg0 = temp [29:0];
											//reg0 = (r - m) % 2 ** 30;
										end
										ONE : begin
											temp = (r - m);
											reg1 = temp [29:0];
											//reg1 = (r - m) % 2 ** 30;
										end
										TWO : begin
											temp = (r - m);
											reg2 = temp [29:0];
											//reg2 = (r - m) % 2 ** 30;
										end
										THREE : begin
											temp = (r - m);
											reg3 = temp [29:0];
											//reg3 = (r - m) % 2 ** 30;
										end
										default : begin
										end
									endcase
								end
								TWELVE : begin
									case(mf)
										ZERO : begin
											t = r / 2;
										end
										ONE : begin
											t = r / 2;
											if(B == 1'b1) begin
												t = t [28:0];
											end
										end
										TWO : begin
											t = (r[28:0]) * 2;
										end
										THREE : begin
											t = (r[28:0]) * 2;
											if(tsign > (2 ** 30 - 1)) begin
												B = 1'b1;
											end
											else begin
												B = 1'b0;
											end
										end
										default : begin
										end
									endcase
									case(d)
										ZERO : begin
											reg0 = t;
										end
										ONE : begin
											reg1 = t;
										end
										TWO : begin
											reg2 = t;
										end
										THREE : begin
											reg3 = t;
										end
										default : begin
										end
									endcase
								end
								THIRTEEN,FOURTEEN,FIFTEEN : begin
								end
							endcase
						end
						else if(df == 7) begin
							case(mf)
								ZERO : begin
									m = tail;
								end
								ONE : begin
									m = tail;
								end
								TWO : begin
									m = (reg1 % 2 ** 20) + (tail % 2 ** 20);
								end
								THREE : begin
									m = (reg2 % 2 ** 20) + (tail % 2 ** 20);
								end
							endcase
							// addr <= m;
							addr <= m % 2 ** 20;
							// removed (!)fs020699
							wr <= 1'b1;
							datao <= r;
						end
					end
				endcase
				state <= FETCH;
			end
		endcase
	end
end


endmodule


module b21(clock, reset, si, so, rd, wr);
//module b14(clock, reset, addr, datai, datao, rd, wr);
//module b14_1(clock, reset, addr, datai, datao, rd, wr);

input clock;
input reset;
input [31:0] si;
output reg [19:0] so;
output reg rd;
output reg wr;


wire [19:0] ad1;
wire [19:0] ad2;
reg [31:0] di1;
reg [31:0] di2;
wire [31:0] do1;
wire [31:0] do2;
wire r1;
wire r2;
wire w1;
wire w2;


b14 P1(clock, reset, ad1, di1, do1, r1, w1);

b14_1 P2(clock, reset, ad2, di2, do2, r2, w2);

always @(ad1, ad2, r1, r2, w1, w2, do1, do2, si) begin
    // so <= ad1 + ad2;
    so <= (ad1 + ad2) % 2 ** 20;
    // removed (!)fs020699
    rd <= r1 ^  ~r2;
    wr <= w1 ^  ~w2;
    // if (ad1(19) = '0' and ad2(19) = '0' and r1 = '0') or
	//	(ad1(19) = '1' and ad2(19) = '1' and r2 = '0') then
    if((ad1 < (2 ** 19) && ad2 < (2 ** 19) && r1 == 1'b0) || (ad1 > (2 ** 19 - 1) && ad2 > (2 ** 19 - 1) && r2 == 1'b0)) begin
		di1 <= do2 + si;
		di2 <= do1;
	end
    else begin
		di1 <= do2;
		di2 <= do1 + si;
	end
end


endmodule
