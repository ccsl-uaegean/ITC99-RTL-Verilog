module b08(CLOCK, RESET, START, I, O);

input CLOCK;
input RESET;
input START;
input [7:0] I;

output reg [3:0] O;



reg [19:0] ROM [0:7];


parameter start_st = 0;
parameter init = 1;
parameter loop_st = 2;
parameter the_end = 3;
reg [7:0] IN_R;
reg [3:0] OUT_R;
reg [7:0] MAR;
reg [2:0] STATO;
reg [7:0] ROM_1;
reg [7:0] ROM_2;
reg [3:0] ROM_OR;
initial begin
	ROM[0] = 20'b01111111100101111010;
	ROM[1] = 20'b00111001110101100010;
	ROM[2] = 20'b10101000111111111111;
	ROM[3] = 20'b11111111011010111010;
	ROM[4] = 20'b11111111111101101110;
	ROM[5] = 20'b11111111101110101000;
	ROM[6] = 20'b11001010011101011011;
	ROM[7] = 20'b00101111111111110100;
end

always @(posedge CLOCK, posedge RESET) begin //: P1
	
	
	if(RESET == 1'b1) begin
		STATO <= start_st;
		ROM_1 <= 8'b00000000;
		ROM_2 <= 8'b00000000;
		ROM_OR <= 4'b0000;
		MAR <= 0;
		IN_R <= 8'b00000000;
		OUT_R <= 4'b0000;
		O <= 4'b0000;
		end else begin
		case(STATO)
			start_st : begin
				if((START == 1'b1)) begin
					STATO <= init;
				end
				end
				init : begin
					IN_R <= I;
					OUT_R <= 4'b0000;
					MAR <= 0;
					STATO <= loop_st;
				end
				loop_st : begin
					ROM_1 = ROM[MAR][19:12];//converted to blocking assignments since their values are used in the same state
					ROM_2 = ROM[MAR][11:4];

					if(((ROM_2 &  ~IN_R) | (ROM_1 & IN_R) | (ROM_2 & ROM_1)) == 8'b11111111) begin
						ROM_OR = ROM[MAR][3:0];//converted to blocking assignments since their values are used in the same state
						OUT_R = OUT_R | ROM_OR;
					end
					STATO <= the_end;
				end
				the_end : begin
					if((MAR != 7)) begin
						MAR <= MAR + 1;
						STATO <= loop_st;
					end
					else if((START == 1'b0)) begin
						O <= OUT_R;
						STATO <= start_st;
					end
				end
			endcase
		end
	end
	
	
	endmodule
		
