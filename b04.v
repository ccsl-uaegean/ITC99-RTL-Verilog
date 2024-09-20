module b04(RESTART,AVERAGE,ENABLE,DATA_IN,DATA_OUT,RESET,CLOCK);

input CLOCK;
input RESET;
input RESTART;
input AVERAGE;
input ENABLE;
input signed [7:0] DATA_IN;

output [7:0] DATA_OUT;

reg signed [7:0] DATA_OUT;


parameter sA = 0;
parameter sB = 1;
parameter sC = 2;

reg [1:0] stato;
reg signed [31:0] RMAX, RMIN, RLAST, REG1, REG2, REG3, REG4, REGD,test;
reg signed [31:0] temp;//reg [7:0] temp;
reg RES, AVE, ENA;

always @(posedge CLOCK, posedge RESET) begin //: P1
    
	
    if(RESET == 1'b1) begin
		stato = sA;
		RMAX = 0;
		RMIN = 0;
		RLAST = 0;
		REG1 = 0;
		REG2 = 0;
		REG3 = 0;
		REG4 = 0;
		REGD = 127;
		temp = 0;
		DATA_OUT <= 0;
		RES = 0;
		ENA = 0;
		AVE = 0;
		end else begin
		RES = RESTART;
		ENA = ENABLE;
		AVE = AVERAGE;
		case(stato)
			sA : begin
				stato = sB;
			end
			sB : begin
				RMAX <= DATA_IN;
				RMIN <= DATA_IN;
				REG1 = 0;
				REG2 = 0;
				REG3 = 0;
				REG4 = 0;
				RLAST = 0;
				DATA_OUT <= 0;
				stato = sC;
			end
			sC : begin
				if((ENA == 1'b1)) begin
					RLAST = DATA_IN;
				end
				if((RES == 1'b1)) begin
					test = (RMAX + RMIN);
					REGD = test[6:0];// % 128;
					temp = RMAX + RMIN;
					if((temp >= 0)) begin
						DATA_OUT <= REGD / 2;
					end
					else begin
						DATA_OUT <=  -(( -REGD) / 2);
					end
				end
				else if((ENA == 1'b1)) begin
					if((AVE == 1'b1)) begin
						DATA_OUT <= REG4;
					end
					else begin
						test =(DATA_IN + REG4);
						REGD = test[6:0];// % 128;
						temp = DATA_IN + REG4;
						if((temp >= 0)) begin
							DATA_OUT <= REGD / 2;
						end
						else begin
							DATA_OUT <=  -(( -REGD) / 2);
						end
					end
				end
				else begin
					DATA_OUT <= RLAST;
				end
				if(DATA_IN > RMAX) begin
					RMAX <= DATA_IN;
				end
				else if(DATA_IN < RMIN) begin
					RMIN <= DATA_IN;
				end
				REG4 = REG3;
				REG3 = REG2;
				REG2 = REG1;
				REG1 = DATA_IN;
				stato = sC;
			end
		endcase
	end
end


endmodule

