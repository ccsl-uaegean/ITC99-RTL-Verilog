module b11(x_in, stbi, clock, reset, x_out);

input clock;
input reset;
input stbi;
input [5:0] x_in;

output reg[5:0] x_out;


parameter s_reset = 0;
parameter s_datain = 1;
parameter s_spazio = 2;
parameter s_mul = 3;
parameter s_somma = 4;
parameter s_rsum = 5;
parameter s_rsot = 6;
parameter s_compl = 7;
parameter s_dataout = 8;
reg [31:0] r_in;
reg [3:0] stato;
reg [31:0] cont;
reg signed [31:0] cont1;

always @(posedge clock, posedge reset) begin //: P1
	
    if(reset == 1'b1) begin
		stato <= s_reset;
		r_in <= 0;
		cont <= 0;
		cont1 <= 0;
		x_out <= 0;
		end else begin
		case(stato)
			s_reset : begin
				cont <= 0;
				r_in <= x_in;
				x_out <= 0;
				stato <= s_datain;
			end
			s_datain : begin
				r_in <= x_in;
				if(stbi == 1'b1) begin
					stato <= s_datain;
				end
				else begin
					stato <= s_spazio;
				end
			end
			s_spazio : begin
				if(r_in == 0 || r_in == 63) begin
					if(cont < 25) begin
						cont <= cont + 1;
					end
					else begin
						cont <= 0;
					end
					cont1 <= r_in;
					stato <= s_dataout;
				end
				else if(r_in <= 26) begin
					stato <= s_mul;
				end
				else begin
					stato <= s_datain;
				end
			end
			s_mul : begin
				if((r_in % 2) == 1) begin
					cont1 <= cont * 2;
				end
				else begin
					cont1 <= cont;
				end
				stato <= s_somma;
			end
			s_somma : begin
				if(((r_in % 4) / 2) == 1) begin
					cont1 <= r_in + cont1;
					stato <= s_rsum;
				end
				else begin
					cont1 <= r_in - cont1;
					stato <= s_rsot;
				end
			end
			s_rsum : begin
				if(cont1 > 26) begin
					cont1 <= cont1 - 26;
					stato <= s_rsum;
				end
				else begin
					stato <= s_compl;
				end
			end
			s_rsot : begin
				if(cont1 > 63) begin
					cont1 <= cont1 + 26;
					stato <= s_rsot;
				end
				else begin
					stato <= s_compl;
				end
			end
			s_compl : begin
				if(((r_in / 4) % 4) == 0) begin
					cont1 <= cont1 - 21;
				end
				else if(((r_in / 4) % 4) == 1) begin
					cont1 <= cont1 - 42;
				end
				else if(((r_in / 4) % 4) == 2) begin
					cont1 <= cont1 + 7;
				end
				else begin
					cont1 <= cont1 + 28;
				end
				stato <= s_dataout;
			end
			s_dataout : begin
				if(cont1 < 0) begin
					// 	x_out<= -cont1;
					// fs 062299
					x_out <= ( -cont1) % 64;
				end
				else begin
					// 	x_out<=cont1;
					// fs 062299
					x_out <= (cont1) % 64;
				end
				stato <= s_datain;
			end
		endcase
	end
end


endmodule
