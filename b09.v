module b09(reset, clock, x ,y);

input clock;
input reset;
input x;
output reg y;


parameter Bit_start = 1'b1;
parameter Bit_stop = 1'b0;
parameter Bit_idle = 1'b0;
parameter Zero_8 = 8'b00000000;
parameter Zero_9 = 9'b000000000;
reg [8:0] d_in;
reg [7:0] d_out;
reg [7:0] old;
parameter INIT = 0;
parameter RECEIVE = 1;
parameter EXECUTE = 2;
parameter LOAD_OLD = 3;
reg [2:0] stato;
always @(posedge clock, posedge reset) begin// : P1
	
	
    if(reset == 1'b1) begin
		stato <= INIT;
		d_in <= Zero_9;
		d_out <= Zero_8;
		old <= Zero_8;
		y <= Bit_idle;
		end else begin
		case(stato)
			INIT : begin
				stato <= RECEIVE;
				d_in <= Zero_9;
				d_out <= Zero_8;
				old <= Zero_8;
				y <= Bit_idle;
			end
			RECEIVE : begin
				if(d_in[0] == Bit_start) begin
					old <= d_in[8:1];
					y <= Bit_start;
					d_out <= d_in[8:1];
					d_in <= {Bit_start,Zero_8};
					stato <= EXECUTE;
				end
				else begin
					d_in <= {x,d_in[8:1]};
					stato <= RECEIVE;
				end
			end
			EXECUTE : begin
				if(d_in[0] == Bit_start) begin
					y <= Bit_stop;
					stato <= LOAD_OLD;
				end
				else begin
					d_out <= {Bit_idle,d_out[7:1]};
					y <= d_out[0];
					stato <= EXECUTE;
				end
				d_in <= {x,d_in[8:1]};
			end
			LOAD_OLD : begin
				if(d_in[0] == Bit_start) begin
					if(d_in[8:1] == old) begin
						d_in <= Zero_9;
						y <= Bit_idle;
						stato <= LOAD_OLD;
					end
					else begin
						y <= Bit_start;
						d_out <= d_in[8:1];
						d_in <= {Bit_start,Zero_8};
						stato <= EXECUTE;
					end
					old <= d_in[8:1];
				end
				else begin
					d_in <= {x,d_in[8:1]};
					y <= Bit_idle;
					stato <= LOAD_OLD;
				end
			end
		endcase
	end
end


endmodule
