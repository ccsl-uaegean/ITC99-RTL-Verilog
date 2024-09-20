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

module b15(BE_n, Address, W_R_n, D_C_n, M_IO_n, ADS_n, Datai, Datao, CLOCK, NA_n, BS16_n, READY_n, HOLD, RESET);

input CLOCK;
input RESET;
input NA_n;
input BS16_n;
input READY_n;
input HOLD;
input [31:0] Datai;

output reg [3:0] BE_n;
output reg [31:0] Address;
output reg W_R_n;
output reg D_C_n;
output reg M_IO_n;
output reg ADS_n;
output reg [31:0] Datao;
	
	
	
	
wire signed [31:0] sDatai = Datai;	


reg StateNA;
reg StateBS16;
reg RequestPending;
parameter Pending = 1'b1;
parameter NotPending = 1'b0;
reg NonAligned;
reg ReadRequest;
reg MemoryFetch;
reg CodeFetch;
reg [3:0] ByteEnable;
reg [31:0] DataWidth;
parameter WidthByte = 0;
parameter WidthWord = 1;
parameter WidthDword = 2;

reg [3:0] State;

parameter StateInit = 0;
parameter StateTi = 1;
parameter StateT1 = 2;
parameter StateT2 = 3;
parameter StateT1P = 4;
parameter StateTh = 5;
parameter StateT2P = 6;
parameter StateT2I = 7;

parameter ZERO = 0;
parameter ONE = 1;
parameter TWO = 2;
parameter THREE = 3;

reg signed[31:0] EAX;
reg signed[31:0] EBX;
reg signed[31:0] rEIP;

parameter REP = 'HF3;
parameter REPNE = 'HF2;
parameter LOCK = 'HF0;

parameter CSsop = 'H2E;
parameter SSsop = 'H36;
parameter DSsop = 'H3E;
parameter ESsop = 'H26;
parameter FSsop = 'H64;
parameter GSsop = 'H65;
parameter OPsop = 'H66;
parameter ADsop = 'H67;

parameter MOV_al_b = 'HB0;
parameter MOV_eax_dw = 'HB8;
parameter MOV_ebx_dw = 'HBB;
parameter MOV_ebx_eax = 'H89;
parameter MOV_eax_ebx = 'H8B;
parameter IN_al = 'HE4;
parameter OUT_al = 'HE6;
parameter ADD_al_b = 'H04;
parameter ADD_ax_w = 'H05;
parameter ROL_eax_b = 'HD1;
parameter ROL_al_1 = 'HD0;
parameter ROL_al_n = 'HC0;
parameter INC_eax = 'H40;
parameter INC_ebx = 'H43;
parameter JMP_rel_short = 'HEB;
parameter JMP_rel_near = 'HE9;
parameter JMP_intseg_immed = 'HEA;
parameter HLT = 'HF4;
parameter WAITx = 'H9B;
parameter NOP = 'H90;
parameter queue_size = 16;
parameter InstQueueLimit = queue_size-1;
parameter Si = 0;
parameter S1 = 1;
parameter S2 = 2;
parameter S3 = 3;
parameter S4 = 4;
parameter S5 = 5;
parameter S6 = 6;
parameter S7 = 7;
parameter S8 = 8;
parameter S9 = 9;
//moved from 234

parameter FALSE = 1'b0;//check where they are used
parameter TRUE = 1'b1;

reg [31:0]InstQueue [0:queue_size-1];
reg [31:0] InstQueueRd_Addr;
reg [31:0] InstQueueWr_Addr;
reg signed [31:0] InstAddrPointer;
reg signed[31:0] PhyAddrPointer;
reg signed[31:0] TEMPORARY;//added my me 
reg Extended;
reg More;
reg Flush;
reg [31:0] lWord;
reg [31:0] uWord;
reg signed[31:0] fWord;
reg [3:0] State2;


reg [8*31:1] string_value; 

always @(posedge CLOCK, posedge RESET) begin//added reset
    if(RESET == 1'b1) begin
		BE_n <= 4'b0000;
		Address <= 0;
		W_R_n <= 1'b0;
		D_C_n <= 1'b0;
		M_IO_n <= 1'b0;
		ADS_n <= 1'b0;
		State <= StateInit;
		StateNA <= 1'b0;
		StateBS16 <= 1'b0;
		DataWidth <= 0;
		end else begin
		case(State)
			StateInit : begin
				D_C_n <= 1'b1;
				ADS_n <= 1'b1;
				State <= StateTi;
				StateNA <= 1'b1;
				StateBS16 <= 1'b1;
				DataWidth <= 2;
				State <= StateTi;
			end
			StateTi : begin
				if(RequestPending == Pending) begin
					State <= StateT1;
				end
				else if(HOLD == 1'b1) begin
					State <= StateTh;
				end
				else begin
					State <= StateTi;
				end
			end
			StateT1 : begin
				// Address <= rEIP/4;
				// fs 062299
				TEMPORARY = rEIP / 4;
				Address = TEMPORARY [29:0];
				//Address <= (rEIP / 4) % (2 ** 30);
				BE_n <= ByteEnable;
				M_IO_n <= MemoryFetch;
				if(ReadRequest == Pending) begin
					W_R_n <= 1'b0;
				end
				else begin
					W_R_n <= 1'b1;
				end
				if(CodeFetch == Pending) begin
					D_C_n <= 1'b0;
				end
				else begin
					D_C_n <= 1'b1;
				end
				ADS_n <= 1'b0;
				State <= StateT2;
			end
			StateT2 : begin
				if(READY_n == 1'b0 && HOLD == 1'b0 && RequestPending == Pending) begin
					State <= StateT1;
				end
				else if(READY_n == 1'b1 && NA_n == 1'b1) begin
				end
				else if((RequestPending == Pending || HOLD == 1'b1) && (READY_n == 1'b1 && NA_n == 1'b0)) begin
					State <= StateT2I;
				end
				else if(RequestPending == Pending && HOLD == 1'b0 && READY_n == 1'b1 && NA_n == 1'b0) begin
					State <= StateT2P;
				end
				else if(RequestPending == NotPending && HOLD == 1'b0 && READY_n == 1'b0) begin
					State <= StateTi;
				end
				else if(HOLD == 1'b1 && READY_n == 1'b1) begin
					State <= StateTh;
				end
				else begin
					State <= StateT2;
				end
				StateBS16 <= BS16_n;
				if(BS16_n == 1'b0) begin
					DataWidth <= WidthWord;
				end
				else begin
					DataWidth <= WidthDword;
				end
				StateNA <= NA_n;
				ADS_n <= 1'b1;
			end
			StateT1P : begin
				if(NA_n == 1'b0 && HOLD == 1'b0 && RequestPending == Pending) begin
					State <= StateT2P;
				end
				else if(NA_n == 1'b0 && (HOLD == 1'b1 || RequestPending == NotPending)) begin
					State <= StateT2I;
				end
				else if(NA_n == 1'b1) begin
					State <= StateT2;
				end
				else begin
					State <= StateT1P;
				end
				StateBS16 <= BS16_n;
				if(BS16_n == 1'b0) begin
					DataWidth <= WidthWord;
				end
				else begin
					DataWidth <= WidthDword;
				end
				StateNA <= NA_n;
				ADS_n <= 1'b1;
			end
			StateTh : begin
				if(HOLD == 1'b0 && RequestPending == Pending) begin
					State <= StateT1;
				end
				else if(HOLD == 1'b0 && RequestPending == NotPending) begin
					State <= StateTi;
				end
				else begin
					State <= StateTh;
				end
			end
			StateT2P : begin
				// Address <= rEIP/2;
				// fs 990629
				TEMPORARY = rEIP / 2;
				Address = TEMPORARY [29:0];
				//Address <= (rEIP / 2) % 2 ** 30; 
				BE_n <= ByteEnable;
				M_IO_n <= MemoryFetch;
				if(ReadRequest == Pending) begin
				W_R_n <= 1'b0;
				end
				else begin
					W_R_n <= 1'b1;
				end
				if(CodeFetch == Pending) begin
					D_C_n <= 1'b0;
				end
				else begin
					D_C_n <= 1'b1;
				end
				ADS_n <= 1'b0;
				if(READY_n == 1'b0) begin
					State <= StateT1P;
				end
				else begin
					State <= StateT2P;
				end
			end
			StateT2I : begin
				if(READY_n == 1'b1 && RequestPending == Pending && HOLD == 1'b0) begin
					State <= StateT2P;
				end
				else if(READY_n == 1'b0 && HOLD == 1'b1) begin
					State <= StateTh;
				end
				else if(READY_n == 1'b0 && HOLD == 1'b0 && RequestPending == Pending) begin
					State <= StateT1;
				end
				else if(READY_n == 1'b0 && HOLD == 1'b0 && RequestPending == NotPending) begin
					State <= StateTi;
				end
				else begin
					State <= StateT2I;
				end
			end
		endcase
	end
end
integer i;
always @(posedge CLOCK, posedge RESET) begin //: P1
	
	
    if(RESET == 1'b1) begin
		State2 = Si;
		//InstQueue := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		for(i = 0; i<queue_size; i =i +1) begin
			InstQueue[i] = 0;
		end
		InstQueueRd_Addr = 0;
		InstQueueWr_Addr = 0;
		InstAddrPointer = 0;
		PhyAddrPointer = 0;
		Extended = FALSE;
		More = FALSE;
		Flush = FALSE;
		lWord = 0;
		uWord = 0;
		fWord = 0;
		CodeFetch <= 1'b0;
		Datao <= 0;
		EAX <= 0;
		EBX <= 0;
		rEIP <= 0;
		ReadRequest <= 1'b0;
		MemoryFetch <= 1'b0;
		RequestPending <= 1'b0;
		end else begin
		case(State2)
			Si : begin
				PhyAddrPointer = rEIP;
				InstAddrPointer = PhyAddrPointer;
				State2 = S1;
				rEIP <= 'HFFFF0;
				ReadRequest <= 1'b1;
				MemoryFetch <= 1'b1;
				RequestPending <= 1'b1;
			end
			S1 : begin
				RequestPending <= Pending;
				ReadRequest <= Pending;
				MemoryFetch <= Pending;
				CodeFetch <= Pending;
				if(READY_n == 1'b0) begin
					State2 = S2;
				end
				else begin
					State2 = S1;
				end
			end
			S2 : begin
				RequestPending <= NotPending;
				InstQueue[InstQueueWr_Addr] = Datai % (2 ** 8);
				InstQueueWr_Addr = (InstQueueWr_Addr + 1) % queue_size;
				//            InstQueue(InstQueueWr_Addr) := (Datai / (2**8)) mod (2**8);
				InstQueue[InstQueueWr_Addr] = Datai % 2 ** 8;
				InstQueueWr_Addr = (InstQueueWr_Addr + 1) % queue_size;
				if(StateBS16 == 1'b1) begin
					TEMPORARY =  (sDatai / (2 ** 16));
					InstQueue[InstQueueWr_Addr] = TEMPORARY [7:0];
					InstQueueWr_Addr = (InstQueueWr_Addr + 1) % queue_size;
					TEMPORARY =  (sDatai / (2 ** 24));
					InstQueue[InstQueueWr_Addr] = TEMPORARY [7:0];
					InstQueueWr_Addr = (InstQueueWr_Addr + 1) % queue_size;
					PhyAddrPointer = PhyAddrPointer + 4;
					State2 = S5;
				end
				else begin
					PhyAddrPointer = PhyAddrPointer + 2;
					if((PhyAddrPointer < 0)) begin
						rEIP <=  -PhyAddrPointer;
					end
					else begin
						rEIP <= PhyAddrPointer;
					end
					State2 = S3;
				end
			end
			S3 : begin
				RequestPending <= Pending;
				if(READY_n == 1'b0) begin
					State2 = S4;
				end
				else begin
					State2 = S3;
				end
			end
			S4 : begin
				RequestPending <= NotPending;
				InstQueue[InstQueueWr_Addr] = Datai % (2 ** 8);
				InstQueueWr_Addr = (InstQueueWr_Addr + 1) % queue_size;
				InstQueue[InstQueueWr_Addr] = Datai % (2 ** 8);
				InstQueueWr_Addr = (InstQueueWr_Addr + 1) % queue_size;
				PhyAddrPointer = PhyAddrPointer + 2;
				State2 = S5;
			end
			S5 : begin
				case(InstQueue[InstQueueRd_Addr])
					NOP : begin
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size;
						Flush = FALSE;
						More = FALSE;
					end
					OPsop : begin
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size;
						Extended = TRUE;
						Flush = FALSE;
						More = FALSE;
					end
					JMP_rel_short : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 3) begin
						//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 3) begin
							if((InstQueue[(InstQueueRd_Addr + 1)% queue_size]) > 127) begin
								//IF InstQueue((InstQueueRd_Addr +1) mod 16) > 127 THEN
							PhyAddrPointer = InstAddrPointer + 1 - ((16'HFF - InstQueue[(InstQueueRd_Addr + 1)%queue_size]));
								//PhyAddrPointer := InstAddrPointer + 1 - (16#FF# - InstQueue((InstQueueRd_Addr +1) mod 16));
								InstAddrPointer = PhyAddrPointer;
							end
							else begin
							PhyAddrPointer = InstAddrPointer + 2 + (InstQueue[(InstQueueRd_Addr + 1)%queue_size]);//edited
								//PhyAddrPointer := InstAddrPointer + 2 + InstQueue((InstQueueRd_Addr +1)mod 16);
								InstAddrPointer = PhyAddrPointer;
							end
							Flush = TRUE;
							More = FALSE;
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					JMP_rel_near : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 5) begin
						//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 5) begin
						PhyAddrPointer = InstAddrPointer + 5 + (InstQueue[(InstQueueRd_Addr + 1)%queue_size]);//edited
							//PhyAddrPointer := InstAddrPointer + 5 + InstQueue((InstQueueRd_Addr +1)mod 16);
							InstAddrPointer = PhyAddrPointer;
							Flush = TRUE;
							More = FALSE;
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					JMP_intseg_immed : begin
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size;
						Flush = FALSE;
						More = FALSE; 
					end
					MOV_al_b : begin
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
					MOV_eax_dw : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 5) begin//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 5) begin
						EAX <= (InstQueue[(InstQueueRd_Addr + 4)%queue_size]) * (2 ** 23) + (InstQueue[(InstQueueRd_Addr + 3)%queue_size]) * (2 ** queue_size) + (InstQueue[(InstQueueRd_Addr + 2)%queue_size]) * (2 ** 8) + (InstQueue[(InstQueueRd_Addr + 1)%queue_size]);//edited
							//EAX <= InstQueue((InstQueueRd_Addr +4)mod 16)*(2**23) + InstQueue((InstQueueRd_Addr +3) mod 16)*(2**16) + InstQueue((InstQueueRd_Addr +2) mod 16)*(2**8) + InstQueue((InstQueueRd_Addr+1)mod 16);
							More = FALSE;
							Flush = FALSE;
							InstAddrPointer = InstAddrPointer + 5;
							InstQueueRd_Addr = (InstQueueRd_Addr + 5) % queue_size;
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					MOV_ebx_dw : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 5) begin
						//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 5) begin
						EBX <= (InstQueue[(InstQueueRd_Addr + 4)% 16]) * (2 ** 23) + (InstQueue[(InstQueueRd_Addr + 3)%16]) * (2 ** queue_size) + (InstQueue[(InstQueueRd_Addr + 2)%queue_size]) * (2 ** 8) + (InstQueue[(InstQueueRd_Addr + 1)%1]);//edited
							//EBX <= InstQueue((InstQueueRd_Addr+4) mod 16)*(2**23) + InstQueue((InstQueueRd_Addr +3) mod 16)*(2**16) + InstQueue((InstQueueRd_Addr +2) mod 16)*(2**8) + InstQueue((InstQueueRd_Addr +1) mod 1);
							More = FALSE;
							Flush = FALSE;
							InstAddrPointer = InstAddrPointer + 5;
							InstQueueRd_Addr = (InstQueueRd_Addr + 5) % queue_size;
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					MOV_eax_ebx : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 2) begin
						//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 2) begin
							if((EBX < 0)) begin
								rEIP <=  -EBX;
							end
							else begin
								rEIP <= EBX;
							end
							RequestPending <= Pending;
							ReadRequest <= Pending;
							MemoryFetch <= Pending;
							CodeFetch <= NotPending;
							if(READY_n == 1'b0) begin
								RequestPending <= NotPending;
								uWord = Datai % (2 ** 15);
								if(StateBS16 == 1'b1) begin
									// lWord := Datai/(2**16);
									// fs 062299
									lWord = Datai % (2 ** 16);
								end
								else begin
									rEIP <= rEIP + 2;
									RequestPending <= Pending;
									if(READY_n == 1'b0) begin
										RequestPending <= NotPending;
										lWord = Datai % (2 ** 16);
									end
								end
								if(READY_n == 1'b0) begin
									EAX <= uWord * (2 ** 16) + lWord;
									More = FALSE;
									Flush = FALSE;
									InstAddrPointer = InstAddrPointer + 2;
									InstQueueRd_Addr = (InstQueueRd_Addr + 2) % queue_size; 
								end
							end
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					MOV_ebx_eax : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 2) begin
						//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 2) begin
							if(EBX < 0) begin
								rEIP <= EBX;
							end
							else begin
								rEIP <= EBX;
							end
							lWord = EAX [15:0];
							//lWord = EAX % (2 ** 16);
							TEMPORARY = EAX / (2 ** 16);
							uWord = TEMPORARY [14:0];
							//uWord = (EAX / (2 ** 16)) % (2 ** 15);
							RequestPending <= Pending;
							ReadRequest <= NotPending;
							MemoryFetch <= Pending;
							CodeFetch <= NotPending;
							if(State == StateT1 || State == StateT1P) begin
								Datao <= uWord * (2 ** 16) + lWord;
								if(READY_n == 1'b0) begin
									RequestPending <= NotPending;
									if(StateBS16 == 1'b0) begin
										rEIP <= rEIP + 2;
										RequestPending <= Pending;
										ReadRequest <= NotPending;
										MemoryFetch <= Pending;
										CodeFetch <= NotPending;
										State2 = S6;
									end
									More = FALSE;
									Flush = FALSE;
									InstAddrPointer = InstAddrPointer + 2; 
									InstQueueRd_Addr = (InstQueueRd_Addr + 2) % queue_size;
								end
							end
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					IN_al : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 2) begin
						//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 2) begin
							rEIP <= InstQueueRd_Addr + 1;
							RequestPending <= Pending;
							ReadRequest <= Pending;
							MemoryFetch <= NotPending;
							CodeFetch <= NotPending;
							if(READY_n == 1'b0) begin
								RequestPending <= NotPending;
								EAX <= Datai;
								InstAddrPointer = InstAddrPointer + 2;
								InstQueueRd_Addr = InstQueueRd_Addr + 2;
								Flush = FALSE;
								More = FALSE;
							end
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					OUT_al : begin
						TEMPORARY = InstQueueWr_Addr - InstQueueRd_Addr;
						if(TEMPORARY >= 2) begin
						//if((InstQueueWr_Addr - InstQueueRd_Addr) >= 2) begin
							rEIP <= InstQueueRd_Addr + 1;
							RequestPending <= Pending;
							ReadRequest <= NotPending;
							MemoryFetch <= NotPending;
							CodeFetch <= NotPending;
							if(State == StateT1 || State == StateT1P) begin
								fWord = EAX [15:0]; 
								Datao <= fWord;
								if(READY_n == 1'b0) begin
									RequestPending <= NotPending;
									InstAddrPointer = InstAddrPointer + 2;
									InstQueueRd_Addr = (InstQueueRd_Addr + 2) % queue_size; 
									Flush = FALSE;
									More = FALSE;
								end
							end
						end
						else begin
							Flush = FALSE;
							More = TRUE;
						end
					end
					ADD_al_b : begin
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
					ADD_ax_w : begin
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
					ROL_al_1 : begin
						InstAddrPointer = InstAddrPointer + 2;
						InstQueueRd_Addr = (InstQueueRd_Addr + 2) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
					ROL_al_n : begin
						InstAddrPointer = InstAddrPointer + 2;
						InstQueueRd_Addr = (InstQueueRd_Addr + 2) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
					INC_eax : begin
						EAX <= EAX + 1;
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
					INC_ebx : begin
						EBX <= EBX + 1;
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
					default : begin
						InstAddrPointer = InstAddrPointer + 1;
						InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size; 
						Flush = FALSE;
						More = FALSE;
					end
				endcase
				if(!(InstQueueRd_Addr < InstQueueWr_Addr) || (((InstQueueLimit - InstQueueRd_Addr) < 4) || Flush || More)) begin
					//if not (InstQueueRd_Addr < InstQueueWr_Addr) or (((InstQueueLimit - InstQueueRd_Addr) < 4) OR Flush OR More) then 
					State2 = S7;
				end
			end
			S6 : begin
				Datao <= uWord * (2 ** 16) + lWord;
				if(READY_n == 1'b0) begin
					RequestPending <= NotPending;
					State2 = S5;
				end
			end
			S7 : begin
				if(Flush) begin
					//if Flush then
					InstQueueRd_Addr = 1;
					InstQueueWr_Addr = 1;
					if((InstAddrPointer < 0)) begin
						fWord =  -InstAddrPointer;
					end
					else begin
						fWord = InstAddrPointer;
					end
					if((fWord % 2) == 1) begin
						InstQueueRd_Addr = (InstQueueRd_Addr + (fWord % 4)) % queue_size; 
					end
				end
				if((InstQueueLimit - InstQueueRd_Addr) < 3) begin
					State2 = S8;
					InstQueueWr_Addr = 0;
				end
				else begin
					State2 = S9;
				end
			end
			S8 : begin
				if(InstQueueRd_Addr </*=*/ InstQueueLimit/*-1*/) begin// was <=
					InstQueue[InstQueueWr_Addr] = InstQueue[InstQueueRd_Addr];
					InstQueueRd_Addr = (InstQueueRd_Addr + 1) % queue_size;
					InstQueueWr_Addr = (InstQueueWr_Addr + 1) % queue_size;
					State2 = S8;
				end
				else begin
					InstQueueRd_Addr = 0; 
					State2 = S9;
				end
			end
			S9 : begin
				rEIP <= PhyAddrPointer;
				State2 = S1;
			end
		endcase
	end
end

always @(posedge CLOCK, posedge RESET) begin
    if(RESET == 1'b1) begin
		ByteEnable <= 4'b0000;
		NonAligned <= 1'b0;
		end else begin
		case(DataWidth)
			WidthByte : begin
				case (rEIP [1:0])
				//case(rEIP % 4)
					//CASE rEIP mod 4 is
					ZERO : begin
						ByteEnable <= 4'b1110;
					end
					ONE : begin
						ByteEnable <= 4'b1101;
					end
					TWO : begin
						ByteEnable <= 4'b1011;
					end
					THREE : begin
						ByteEnable <= 4'b0111;
					end
					default : begin
					end
				endcase
			end
			WidthWord : begin
				case (rEIP [1:0])
				//case(rEIP % 4)
					//CASE rEIP mod 4 is
					ZERO : begin
						ByteEnable <= 4'b1100;
						NonAligned <= NotPending;
					end
					ONE : begin
						ByteEnable <= 4'b1001;
						NonAligned <= NotPending;
					end
					TWO : begin
						ByteEnable <= 4'b0011;
						NonAligned <= NotPending;
					end
					THREE : begin
						ByteEnable <= 4'b0111;
						NonAligned <= Pending;
					end
					default : begin
					end
				endcase
			end
			WidthDword : begin
				case (rEIP [1:0])
				//case(rEIP % 4)
					//CASE rEIP mod 4 is
					ZERO : begin
						ByteEnable <= 4'b0000;
						NonAligned <= NotPending;
					end
					ONE : begin
						ByteEnable <= 4'b0001;
						NonAligned <= Pending;
					end
					TWO : begin
						NonAligned <= Pending;
						ByteEnable <= 4'b0011;
					end
					THREE : begin
						NonAligned <= Pending;
						ByteEnable <= 4'b0111;
					end
					default : begin
					end
				endcase
			end
			default : begin
			end
		endcase
	end
end


endmodule


module b17(clock, reset, datai, datao, hold, na, bs16, address1, address2, wr, dc, mio, ast1,ast2, ready1, ready2);
//module b15(BE_n, Address, W_R_n, D_C_n, M_IO_n, ADS_n, Datai, Datao, CLOCK, NA_n, BS16_n, READY_n, HOLD, RESET);

	input clock;
	input reset;
	input [31:0] datai;
	output reg [31:0] datao;
	input hold;
	input na;
	input bs16;
	output reg [30:0]address1;
	output reg [30:0]address2;
	output reg wr;
	output reg dc;
	output reg mio;
	output reg ast1;
	output reg ast2;
	input ready1;
	input ready2;



reg [31:0] buf1; reg [31:0] buf2;
wire [3:0] be1; wire [3:0] be2; wire [3:0] be3;
wire [31:0] addr1; wire [31:0] addr2; wire [31:0] addr3;
wire wr1; wire wr2; wire wr3;
wire dc1; wire dc2; wire dc3;
wire mio1, mio2, mio3;
wire ads1; wire ads2; wire ads3;
reg [31:0] di1; reg [31:0] di2; reg [31:0] di3;
wire [31:0] do1; wire [31:0] do2; wire [31:0] do3;
reg rdy1; reg rdy2; reg rdy3;
reg ready11; reg ready12; reg ready21; reg ready22;

b15 P1(be1, addr1, wr1, dc1, mio1, ads1, di1, do1, clock, na, bs16, rdy1, hold, reset);

b15 P2(be2, addr2, wr2, dc2, mio2, ads2, di2, do2, clock, na, bs16, rdy2, hold, reset);

b15 P3(be3, addr3, wr3, dc3, mio3, ads3, di3, do3, clock, na, bs16, rdy3, hold, reset);

always @(posedge clock, posedge reset) begin
    if(reset == 1'b1) begin
		buf1 <= 0;
		ready11 <= 1'b0;
		ready12 <= 1'b0;
		end else begin
		if(addr1 > (2 ** 29) && ads1 == 1'b0 && mio1 == 1'b1 && dc1 == 1'b0 && wr1 == 1'b1 && be1 == 4'b0000) begin
			buf1 <= do1;
			ready11 <= 1'b0;
			ready12 <= 1'b1;
		end
		else if(addr2 > (2 ** 29) && ads2 == 1'b0 && mio2 == 1'b1 && dc2 == 1'b0 && wr2 == 1'b1 && be2 == 4'b0000) begin
			buf1 <= do2;
			ready11 <= 1'b1;
			ready12 <= 1'b0;
		end
		else begin
			ready11 <= 1'b1;
			ready12 <= 1'b1;
		end
	end
end

always @(posedge clock, posedge reset) begin
    if(reset == 1'b1) begin
		buf2 <= 0;
		ready21 <= 1'b0;
		ready22 <= 1'b0;
		end else begin
		if(addr2 < (2 ** 29) && ads2 == 1'b0 && mio2 == 1'b1 && dc2 == 1'b0 && wr2 == 1'b1 && be2 == 4'b0000) begin
			buf2 <= do2;
			ready21 <= 1'b0;
			ready22 <= 1'b1;
		end
		else if(ads3 == 1'b0 && mio3 == 1'b1 && dc3 == 1'b0 && wr3 == 1'b0 && be3 == 4'b0000) begin
			ready21 <= 1'b1;
			ready22 <= 1'b0;
		end
		else begin
			ready21 <= 1'b1;
			ready22 <= 1'b1;
		end
	end
end

always @(addr1, buf1, datai) begin
    if(addr1 > (2 ** 29)) begin
		di1 <= buf1;
	end
    else begin
		di1 <= datai;
	end
end

always @(addr2, buf1, buf2) begin
    if(addr2 > (2 ** 29)) begin
		di2 <= buf1;
	end
    else begin
		di2 <= buf2;
	end
end

always @(addr2, addr3, do1, do2, do3) begin
    if((do1 < (2 ** 30)) && (do2 < (2 ** 30)) && (do3 < (2 ** 30))) begin
		address2 <= addr3;
	end
    else begin
		address2 <= addr2;
	end
end

always @(buf2, do3, addr1, wr3, dc3, mio3, ads1, ads3, ready1, ready2, ready11, ready12, ready21, ready22) begin
    di3 <= buf2;
    datao <= do3;
    address1 <= addr1;
    wr <= wr3;
    dc <= dc3;
    mio <= mio3;
    ast1 <= ads1;
    ast2 <= ads3;
    rdy1 <= ready11 & ready1;
    rdy2 <= ready12 & ready21;
    rdy3 <= ready22 & ready2;
end





endmodule


module b18(clock, reset, hold, na, bs, sel, din, dout, aux);
//module b14(clock, reset, addr, datai, datao, rd, wr);
//module b17(clock, reset, datai, datao, hold, na, bs16, address1, address2, wr, dc, mio, ast1,ast2, ready1, ready2);
input clock;
input reset;
input hold;
input na;
input bs;
input sel;
input [31:0] din;

output reg [19:0] dout;
output reg [3:0] aux;



reg [31:0] di1; reg [31:0] di2; wire [31:0] do1; wire [31:0] do2; reg [31:0] td1; reg [31:0] td2;
reg [31:0] di3; reg [31:0] di4; wire [31:0] do3; wire [31:0] do4;
reg [30:0] tad1; reg [30:0] tad2; wire [30:0] ad11; wire [30:0] ad12; wire [30:0] ad21; wire [30:0] ad22;
wire [19:0] ad31; wire [19:0] ad41;
reg [31:0] tad3; reg [31:0] tad4;
wire wr1; wire wr2; wire wr3; wire wr4; wire dc1; wire dc2; wire mio1; wire mio2;
wire as11; wire as12; wire as21; wire as22; reg r11; reg r12; reg r21; reg r22;
wire rd3; wire rd4;  // signal prova : integer range 2**30-1 downto 0;
// removed (!)gs020699

b17 P1(clock, reset, di1, do1, hold, na, bs, ad11, ad12, wr1, dc1, mio1, as11, as12, r11, r12);

b17 P2(clock, reset, di2, do2, hold, na, bs, ad21, ad22, wr2, dc2, mio2, as21, as22, r21, r22);

b14 P3(clock, reset, ad31, di3, do3, rd3, wr3);

b14 P4(clock, reset, ad41, di4, do4, rd4, wr4);

always @(do1, rd3, wr1, mio1, dc1, as12, do2, rd4, wr2, mio2, dc2, as22, as21, as11, wr3, ad31, tad2, wr4, ad41, tad1, do3, do4, ad11, ad12, ad21, ad22, tad3, tad4, sel, din, td1, td2) begin
    // prova <= do1;
	// di3 <= prova mod 2**20;
    di3 <= do1 % 2 ** 20;
    // removed (!)gs020699
    r12 <=  ~(rd3 & wr1 & mio1 & dc1 &  ~as12);
    di4 <= do2;
    r22 <=  ~(rd4 & wr2 & mio2 & dc2 &  ~as22);
    r11 <= as21;
    r21 <= as11;
    if(wr3 == 1'b1) begin
		tad3 <= ad31;
	end
    else begin
		//tad3 <= tad2;
		tad3 <= tad2 % 2 ** 20;
		// removed (!)fs020699
	end
    if(wr4 == 1'b1) begin
		tad4 <= ad41;
	end
    else begin
		//tad4 <= tad1;
		tad4 <= tad1 % 2 ** 20;
		// removed (!)fs020699
	end
    if(do3 > (2 ** 28)) begin
		tad1 <= ad11;
	end
    else begin
		tad1 <= ad12;
	end
    if(do4 > (2 ** 29)) begin
		tad2 <= ad21;
	end
    else begin
		tad2 <= ad22;
	end
    dout <= (tad3 * tad4) % 2 ** 19;
    if(sel == 1'b0) begin
		td1 <= 0;
		td2 <= din;
	end
    else begin
		td1 <= din;
		td2 <= 0;
	end
    di1 <= do4 * td1;
    di2 <= do3 * td2;
    aux <= (tad1 * tad2) % 2 ** 3;
end


endmodule
