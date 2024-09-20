module b12(clock, reset, start, k, nloss, nl, speaker);

input clock;
input reset;
input start;
input [3:0] k;
output reg nloss;
output reg [3:0] nl;
output reg speaker;


reg [4:0] gamma;

parameter RED = 0;
parameter GREEN = 1;
parameter YELLOW = 2;
parameter BLUE = 3;

parameter LED_ON = 1'b1;
parameter LED_OFF = 1'b0;

parameter PLAY_ON = 1'b1;
parameter PLAY_OFF = 1'b0;

parameter KEY_ON = 1'b1;

parameter NUM_KEY = 4;
parameter COD_COLOR = 2;
parameter COD_SOUND = 3;

parameter S_WIN = 2 ** COD_COLOR;
parameter S_LOSS = S_WIN + 1;

parameter SIZE_ADDRESS = 5;
parameter SIZE_MEM = 2 ** SIZE_ADDRESS;

parameter COUNT_KEY = 33;
parameter COUNT_SEQ = 33;
parameter DEC_SEQ = 1;
parameter COUNT_FIN = 8;

parameter ERROR_TONE = 1;
parameter RED_TONE = 2;
parameter GREEN_TONE = 3;
parameter YELLOW_TONE = 4;
parameter BLUE_TONE = 5;
parameter WIN_TONE = 6;

parameter G0 = 0;
parameter G1 = 1;
parameter G2 = 2;
parameter G3 = 3;
parameter G4 = 4;
parameter G5 = 5;
parameter G6 = 6;
parameter G7 = 7;
parameter G8 = 8;
parameter G9 = 9;
parameter G10 = 10;
parameter G10a = 11;
parameter G11 = 12;
parameter G12 = 13;
parameter Ea = 14;
parameter E0 = 15;
parameter E1 = 16;
parameter K0 = 17;
parameter K1 = 18;
parameter K2 = 19;
parameter K3 = 20;
parameter K4 = 21;
parameter K5 = 22;
parameter K6 = 23;
parameter W0 = 24;
parameter W1 = 25;

reg wr;
reg [31:0] address;
reg [3:0] data_in;
reg [3:0] data_out;
reg [3:0] num;
reg [3:0] sound;
reg play;
reg s;
reg [3:0] counterP4;
reg [(2**COD_COLOR)-1:0] count_P3;
reg [3:0] memory [0:31];
reg signed [31:0] mar;

reg [2:0] ind;
reg [31:0] scan;
reg [31:0] max;
reg [5:0] timebase;
reg [5:0] countP1;
parameter zero = 0;
parameter one = 1;
parameter two = 2;
parameter three = 3;
always @(posedge clock, posedge reset) begin //: P4
   
   
    if((reset == 1'b1)) begin
      s = 1'b0;
      speaker <= 1'b0;
      counterP4 <= 0;
      end else begin
      if(play == 1'b1) begin
         case(sound)
            zero : begin
               if(counterP4 > RED_TONE) begin
                  s =  ~s;//blocking so the value is assigned correctly
                  speaker <= s;
                  counterP4 <= 0;
               end
               else begin
                  counterP4 <= counterP4 + 1;
               end
            end
            one : begin
               if(counterP4 > GREEN_TONE) begin
                  s =  ~s;
                  speaker <= s;
                  counterP4 <= 0;
               end
               else begin
                  counterP4 <= counterP4 + 1;
               end
            end
            two : begin
               if(counterP4 > YELLOW_TONE) begin
                  s =  ~s;
                  speaker <= s;
                  counterP4 <= 0;
               end
               else begin
                  counterP4 <= counterP4 + 1;
               end
            end
            three : begin
               if(counterP4 > BLUE_TONE) begin
                  s =  ~s;
                  speaker <= s;
                  counterP4 <= 0;
               end
               else begin
                  counterP4 <= counterP4 + 1;
               end
            end
            S_WIN : begin
               if(counterP4 > WIN_TONE) begin
                  s =  ~s;
                  speaker <= s;
                  counterP4 <= 0;
               end
               else begin
                  counterP4 <= counterP4 + 1;
               end
            end
            S_LOSS : begin
               if(counterP4 > ERROR_TONE) begin
                  s =  ~s;
                  speaker <= s;
                  counterP4 <= 0;
               end
               else begin
                  counterP4 <= counterP4 + 1;
               end
            end
            default : begin
               counterP4 <= 0;
            end
         endcase
      end
      else begin
         counterP4 <= 0;
         speaker <= 1'b0;
      end
   end
end

always @(posedge clock, posedge reset) begin// : P3
   
   
    if((reset == 1'b1)) begin
      count_P3 <= 0;
      num <= 0;
      end else begin
      count_P3 = (count_P3 + 1) % (2 ** COD_COLOR);//blocking so the value is assigned correctly
      // count := count + 1;
      // removed(!)fs030699
      num <= count_P3;
   end
end


always @(posedge clock, posedge reset) begin //: P2
   
   
    if(reset == 1'b1) begin
      data_out <= 0;
      for (mar=0; mar <= SIZE_MEM - 1; mar = mar + 1) begin
         memory[mar] <= 0;
      end
      end else begin
      data_out <= memory[address];
      if(wr == 1'b1) begin
         memory[address] <= data_in;
      end
   end
end

always @(posedge clock, posedge reset) begin// : P1
   
   
    if((reset == 1'b1)) begin
      nloss <= LED_OFF;
      nl <= {4{LED_OFF}};
      play <= PLAY_OFF;
      wr <= 1'b0;
      scan <= 0;
      max <= 0;
      ind <= 0;
      timebase <= 0;
      countP1 <= 0;
      sound <= 0;
      address <= 0;
      data_in <= 0;
      gamma <= G0;
      end 
	
      else begin
	if(start == 1'b1) begin //replaced the commented statement with the contents of G1 to match the functionality of the original VHDL circuit
         //gamma <= G1;
		   nloss <= LED_OFF;
            nl <= {4{LED_OFF}};
            play <= PLAY_OFF;
            wr <= 1'b0;
            max <= 0;
            timebase <= COUNT_SEQ;
            gamma <= G2;
	end else
	
		
      case(gamma)
         G0 : begin
            gamma <= G0;
         end
		 G1 : begin //state has been left here to keep the circuit looking original 
            nloss <= LED_OFF;
            nl <= {4{LED_OFF}};
            play <= PLAY_OFF;
            wr <= 1'b0;
            max <= 0;
            timebase <= COUNT_SEQ;
            gamma <= G2;
         end
         G2 : begin
            scan <= 0;
            wr <= 1'b1;
            address <= max;
            data_in <= num;
            gamma <= G3;
         end
         G3 : begin
            wr <= 1'b0;
            address <= scan;
            gamma <= G4;
         end
         G4 : begin
            gamma <= G5;
         end
         G5 : begin
            nl[data_out] <= LED_ON;
            countP1 <= timebase;
            play <= PLAY_ON;
            sound <= data_out;
            gamma <= G6;
         end
         G6 : begin
            if(countP1 == 0) begin
               nl <= {4{LED_OFF}};
               play <= PLAY_OFF;
               countP1 <= timebase;
               gamma <= G7;
            end
            else begin
               countP1 <= countP1 - 1;
               gamma <= G6;
            end
         end
         G7 : begin
            if(countP1 == 0) begin
               if(scan != max) begin
                  scan <= scan + 1;
                  gamma <= G3;
               end
               else begin
                  scan <= 0;
                  gamma <= G8;
               end
            end
            else begin
               countP1 <= countP1 - 1;
               gamma <= G7;
            end
         end
         G8 : begin
            countP1 <= COUNT_KEY;
            address <= scan;
            gamma <= G9;
         end
         G9 : begin
            gamma <= G10;
         end
         G10 : begin
            if(countP1 == 0) begin
               nloss <= LED_ON;
               max <= 0;
               gamma <= K0;
            end
            else begin
               countP1 <= countP1 - 1;
               if(k[0] == KEY_ON) begin
                  ind <= 0;
                  sound <= 0;
                  play <= PLAY_ON;
                  countP1 <= timebase;
                  if((data_out == 0)) begin
                     gamma <= G10a;
                  end
                  else begin
                     nloss <= LED_ON;
                     gamma <= Ea;
                  end
               end
               else if(k[1] == KEY_ON) begin
                  ind <= 1;
                  sound <= 1;
                  play <= PLAY_ON;
                  countP1 <= timebase;
                  if((data_out == 1)) begin
                     gamma <= G10a;
                  end
                  else begin
                     nloss <= LED_ON;
                     gamma <= Ea;
                  end
               end
               else if(k[2] == KEY_ON) begin
                  ind <= 2;
                  sound <= 2;
                  play <= PLAY_ON;
                  countP1 <= timebase;
                  if((data_out == 2)) begin
                     gamma <= G10a;
                  end
                  else begin
                     nloss <= LED_ON;
                     gamma <= Ea;
                  end
               end
               else if(k[3] == KEY_ON) begin
                  ind <= 3;
                  sound <= 3;
                  play <= PLAY_ON;
                  countP1 <= timebase;
                  if((data_out == 3)) begin
                     gamma <= G10a;
                  end
                  else begin
                     nloss <= LED_ON;
                     gamma <= Ea;
                  end
               end
               else begin
                  gamma <= G10;
               end
            end
         end
         G10a : begin
            nl[ind] <= LED_ON;
            gamma <= G11;
         end
         G11 : begin
            if(countP1 == 0) begin
               nl <= {4{LED_OFF}};
               play <= PLAY_OFF;
               countP1 <= timebase;
               // attiva contatore LED spento
               gamma <= G12;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= G11;
               // stato FSM
            end
         end
         G12 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               if(scan != max) begin
                  // controlla se sequenza non finita
                  scan <= scan + 1;
                  // incrementa indirizzo
                  gamma <= G8;
                  // stato FSM
               end
               else if(max != (SIZE_MEM - 1)) begin
                  // controlla se memoria non e' esaurita
                  max <= max + 1;
                  // incrementa registro massima sequenza
                  timebase <= timebase - DEC_SEQ;
                  // decremento prossima sequenza
                  gamma <= G2;
                  // stato FSM
               end
               else begin
                  play <= PLAY_ON;
                  // attiva il suono
                  sound <= S_WIN;
                  // comunica il codice del suono
                  countP1 <= COUNT_FIN;
                  // attiva contatore fine suono
                  gamma <= W0;
                  // stato FSM
               end
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= G12;
               // stato FSM
            end
         end
         Ea : begin
            nl[ind] <= LED_ON;
            // attiva LED tasto
            gamma <= E0;
            // stato FSM
         end
         E0 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               nl <= {4{LED_OFF}};
               // spegne LED tasti
               play <= PLAY_OFF;
               // disattiva il suono
               countP1 <= timebase;
               // attiva contatore LED spento
               gamma <= E1;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= E0;
               // stato FSM
            end
         end
         E1 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               max <= 0;
               // azzera registro massima sequenza
               gamma <= K0;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= E1;
               // stato FSM
            end
         end
         K0 : begin
            address <= max;
            // indirizza ultimo integer range 3 downto 0e
            gamma <= K1;
            // stato FSM
         end
         K1 : begin
            // serve per dare tempo per leggere la memoria
            gamma <= K2;
            // stato FSM
         end
         K2 : begin
            nl[data_out] <= LED_ON;
            // attiva LED tasto
            play <= PLAY_ON;
            // attiva suono
            sound <= data_out;
            // comunica il codice del suono
            countP1 <= timebase;
            // attiva contatore LED acceso
            gamma <= K3;
            // stato FSM
         end
         K3 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               nl <= {4{LED_OFF}};
               // spegne LED tasti
               play <= PLAY_OFF;
               // disattiva il suono
               countP1 <= timebase;
               // attiva contatore LED spento
               gamma <= K4;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= K3;
               // stato FSM
            end
         end
         K4 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               if(max != scan) begin
                  // controlla se fine lista
                  max <= max + 1;
                  // incrementa indirizzo
                  gamma <= K0;
                  // stato FSM
               end
               else begin
                  nl[data_out] <= LED_ON;
                  // attiva LED tasto
                  play <= PLAY_ON;
                  // attiva suono
                  sound <= S_LOSS;
                  // codice suono perdita
                  countP1 <= COUNT_FIN;
                  // attiva contatore LED acceso
                  gamma <= K5;
                  // stato FSM
               end
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= K4;
               // stato FSM
            end
         end
         K5 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               nl <= {4{LED_OFF}};
               // spegne LED tasti
               play <= PLAY_OFF;
               // disattiva il suono
               countP1 <= COUNT_FIN;
               // attiva contatore LED spento
               gamma <= K6;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= K5;
               // stato FSM
            end
         end
         K6 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               nl[data_out] <= LED_ON;
               // attiva LED tasto
               play <= PLAY_ON;
               // attiva suono
               sound <= S_LOSS;
               // codice suono perdita
               countP1 <= COUNT_FIN;
               // attiva contatore LED acceso
               gamma <= K5;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= K6;
               // stato FSM
            end
         end
         W0 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               nl <= {4{LED_ON}};
               // attiva tutti i LED
               play <= PLAY_OFF;
               // disattiva il suono
               countP1 <= COUNT_FIN;
               // attiva contatore LED acceso
               gamma <= W1;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= W0;
               // stato FSM
            end
         end
         W1 : begin
            if(countP1 == 0) begin
               // controlla se fine conteggio
               nl <= {4{LED_OFF}};
               // disattiva tutti i LED
               play <= PLAY_ON;
               // attiva il suono
               sound <= S_WIN;
               // comunica il codice del suono
               countP1 <= COUNT_FIN;
               // attiva contatore LED spento
               gamma <= W0;
               // stato FSM
            end
            else begin
               countP1 <= countP1 - 1;
               // decrementa contatore
               gamma <= W1;
               // stato FSM
            end
         end
      endcase
   end
end


endmodule


