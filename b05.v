module b05(CLOCK, RESET, START, SIGN, DISPMAX1, DISPMAX2, DISPMAX3, DISPNUM1, DISPNUM2);
//converted registers to signed regsters when the value was used for a comparison.

input CLOCK;
input RESET;
input START;
output reg SIGN;
output reg [6:0] DISPMAX1;
output reg [6:0] DISPMAX2;
output reg [6:0] DISPMAX3;
output reg [6:0] DISPNUM1;
output reg [6:0] DISPNUM2;



parameter st0 = 0;
parameter st1 = 1;
parameter st2 = 2;
parameter st3 = 3;
parameter st4 = 4;  //subtype memdim is integer range 31 downto 0;
//subtype num9bits is integer range 255 downto -256;

reg signed [31:0] NUM;
reg signed [31:0] MAR;
reg signed [31:0] TEMP;
reg signed [31:0] MAX;
reg FLAG; reg MAG1; reg MAG2; reg MIN1;
reg EN_DISP; reg RES_DISP;  // constant MEM: rom := 
//                      ( 50,40,0,                   
   //                        229,10,75,
   //                        229,181,186,
   //                        229,186,181,
   //                        0,40,50,
   //                        229,186,229,
   //                        229,151,229,
   //                        100,125,10,
   //                        75,50,0,
   //                        229,0,40,
//                        50,50 );
reg signed[31:0] MEM [31:0];  //,40,0,                   
//                        229,-10,75,
   //                        229,181,186,
   //                        229,186,-11,
   //                        0,40,50,
   //                        -29,-18,229,
   //                        229,151,229,
   //                        100,125,10,
   //                        75,-50,0,
   //                        -22,0,40,
//                        50,50 );

reg signed [31:0] AC1, AC2;

reg signed [31:0] TM, TN;

reg [2:0] STATO;
reg [5:0] TMN;

/*
initial
begin
   MEM[31] = 50;
   MEM[30] = 50;
   MEM[29] = 40;
   MEM[28] = 0;
   MEM[27] = 229;
   MEM[26] = 0;
   MEM[25] = 50;
   MEM[24] = 75;
   MEM[23] = 10;
   MEM[22] = 125;
   MEM[21] = 100;
   MEM[20] = 229;
   MEM[19] = 151;
   MEM[18] = 229;
   MEM[17] = 229;
   MEM[16] = 186;
   MEM[15] = 229;
   MEM[14] = 50;
   MEM[13] = 40;
   MEM[12] = 0;
   MEM[11] = 181;
   MEM[10] = 186;
   MEM[9] = 229;
   MEM[8] = 186;
   MEM[7] = 181;
   MEM[6] = 229;
   MEM[5] = 75;
   MEM[4] = 10;
   MEM[3] = 229;
   MEM[2] = 0;
   MEM[1] = 40;
   MEM[0] = 50;
   
end
*/
initial
begin
   MEM[31] = 50;
   MEM[30] = 50;
   MEM[29] = 40;
   MEM[28] = 0;
   MEM[27] = -22;
   MEM[26] = 0;
   MEM[25] = -50;
   MEM[24] = 75;
   MEM[23] = 10;
   MEM[22] = 125;
   MEM[21] = 100;
   MEM[20] = 229;
   MEM[19] = 151;
   MEM[18] = 229;
   MEM[17] = 229;
   MEM[16] = -18;
   MEM[15] = -29;
   MEM[14] = 50;
   MEM[13] = 40;
   MEM[12] = 0;
   MEM[11] = -11;
   MEM[10] = 186;
   MEM[9] = 229;
   MEM[8] = 186;
   MEM[7] = 181;
   MEM[6] = 229;
   MEM[5] = 75;
   MEM[4] = -10;
   MEM[3] = 229;
   MEM[2] = 0;
   MEM[1] = 40;
   MEM[0] = 50;
   NUM = 31;
   MAR = 31;
   TEMP = 255;
   MAX = 255;
   FLAG = 0;
   TM = 255;
   TN = 255;
   TMN = 0;
   AC1 = -205;
   AC2 = -205;
   STATO = 1;
   EN_DISP = 0;
   RES_DISP = 0;
   
end

always @(MAR, TEMP, MAX) begin //: P3
    
   
    AC1 = MEM[MAR] - TEMP;
    if(AC1 < 0) begin
      MIN1 <= 1'b1;
      MAG1 <= 1'b0;
   end
    else begin
      if(AC1 == 0) begin
         MIN1 <= 1'b0;
         MAG1 <= 1'b0;
      end
      else begin
         MIN1 <= 1'b0;
         MAG1 <= 1'b1;
      end
   end
    AC2 = MEM[MAR] - MAX;
    if((AC2 < 0)) begin
      MAG2 <= 1'b1;
   end
    else begin
      MAG2 <= 1'b0;
   end
end

always @(EN_DISP, RES_DISP, NUM, MAX) begin //: P2
    
   
    if(EN_DISP == 1'b1) begin
      DISPMAX1 <= 7'b0000000;
      DISPMAX2 <= 7'b0000000;
      DISPMAX3 <= 7'b0000000;
      DISPNUM1 <= 7'b0000000;
      DISPNUM2 <= 7'b0000000;
      SIGN <= 1'b0;
   end
    else if(RES_DISP == 1'b0) begin
      DISPMAX1 <= 7'b1000000;
      DISPMAX2 <= 7'b1000000;
      DISPMAX3 <= 7'b1000000;
      DISPNUM1 <= 7'b1000000;
      DISPNUM2 <= 7'b1000000;
      SIGN <= 1'b1;
   end
    else begin
      TN = NUM;
      if(MAX < 0) begin
         SIGN <= 1'b1;
         //TM <= -MAX % 2 ** 5; altered to match the function of the "mod" operator in vhdl
		 TM = -MAX[4:0];

      end
      else begin
         SIGN <= 1'b0;
         TM = MAX % 2 ** 5;
      end
      if(TM > 99) begin
         DISPMAX1 <= 7'b0011000;
         TM = TM - 100;
      end
      else begin
         DISPMAX1 <= 7'b0111111;
      end
      if(TM > 89) begin
         DISPMAX2 <= 7'b1111110;
         TM = TM - 90;
      end
      else begin
         if(TM > 79) begin
            DISPMAX2 <= 7'b1111111;
            TM = TM - 80;
         end
         else begin
            if(TM > 69) begin
               DISPMAX2 <= 7'b0011100;
               TM = TM - 70;
            end
            else begin
               if(TM > 59) begin
                  DISPMAX2 <= 7'b1110111;
                  TM = TM - 60;
               end
               else begin
                  if(TM > 49) begin
                     DISPMAX2 <= 7'b1110110;
                     TM = TM - 50;
                  end
                  else begin
                     if(TM > 39) begin
                        DISPMAX2 <= 7'b1011010;
                        TM = TM - 40;
                     end
                     else begin
                        if(TM > 29) begin
                           DISPMAX2 <= 7'b1111001;
                           TM = TM - 30;
                        end
                        else begin
                           if(TM > 19) begin
                              DISPMAX2 <= 7'b1101100;
                              TM = TM - 20;
                           end
                           else begin
                              if(TM > 9) begin
                                 DISPMAX2 <= 7'b0011000;
                                 TM = TM - 10;
                              end
                              else begin
                                 DISPMAX2 <= 7'b0111111;
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
      end
      if(TM > 8) begin
         DISPMAX3 <= 7'b1111110;
      end
      else begin
         if(TM > 7) begin
            DISPMAX3 <= 7'b1111111;
         end
         else begin
            if(TM > 6) begin
               DISPMAX3 <= 7'b0011100;
            end
            else begin
               if(TM > 5) begin
                  DISPMAX3 <= 7'b1110111;
               end
               else begin
                  if(TM > 4) begin
                     DISPMAX3 <= 7'b1110110;
                  end
                  else begin
                     if(TM > 3) begin
                        DISPMAX3 <= 7'b1011010;
                     end
                     else begin
                        if(TM > 2) begin
                           DISPMAX3 <= 7'b1111001;
                        end
                        else begin
                           if(TM > 1) begin
                              DISPMAX3 <= 7'b1101100;
                           end
                           else begin
                              if(TM > 0) begin
                                 DISPMAX3 <= 7'b0011000;
                              end
                              else begin
                                 DISPMAX3 <= 7'b0111111;
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
      end
      if(TN > 9) begin
         DISPNUM1 <= 7'b0011000;
         TN = TN - 10;
      end
      else begin
         DISPNUM1 <= 7'b0111111;
      end
      if(TN > 8) begin
         DISPNUM2 <= 7'b1111110;
      end
      else begin
         if(TN > 7) begin
            DISPNUM2 <= 7'b1111111;
         end
         else begin
            if(TN > 6) begin
               DISPNUM2 <= 7'b0011100;
            end
            else begin
               if(TN > 5) begin
                  DISPNUM2 <= 7'b1110111;
               end
               else begin
                  if(TN > 4) begin
                     DISPNUM2 <= 7'b1110110;
                  end
                  else begin
                     if(TN > 3) begin
                        DISPNUM2 <= 7'b1011010;
                     end
                     else begin
                        if(TN > 2) begin
                           DISPNUM2 <= 7'b1111001;
                        end
                        else begin
                           if(TN > 1) begin
                              DISPNUM2 <= 7'b1101100;
                           end
                           else begin
                              if(TN > 0) begin
                                 DISPNUM2 <= 7'b0011000;
                              end
                              else begin
                                 DISPNUM2 <= 7'b0111111;
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end
end

always @(posedge CLOCK, posedge RESET) begin //: P1
    
   
    if(RESET == 1'b1) begin
      STATO = st0;
      RES_DISP <= 1'b0;
      EN_DISP <= 1'b0;
      NUM <= 0;
      MAR <= 0;
      TEMP <= 0;
      MAX <= 0;
      FLAG <= 1'b0;
      end else begin
      case(STATO)
         st0 : begin
            RES_DISP <= 1'b0;
            EN_DISP <= 1'b0;
            STATO = st1;
         end
         st1 : begin
            if(START == 1'b1) begin
               NUM <= 0;
               MAR <= 0;
               FLAG <= 1'b0;
               EN_DISP <= 1'b1;
               RES_DISP <= 1'b1;
               STATO = st2;
            end
            else begin
               STATO = st1;
            end
         end
         st2 : begin
            MAX <= MEM[MAR];
            TEMP <= MEM[MAR];
            STATO = st3;
         end
         st3 : begin
            if(MIN1 == 1'b1) begin
               if(FLAG == 1'b1) begin
                  FLAG <= 1'b0;
                  NUM <= NUM + 1;
               end
            end
            else begin
               if(MAG1 == 1'b1) begin
                  if(MAG2 == 1'b1) begin
                     MAX <= MEM[MAR];
                  end
                  FLAG <= 1'b1;
               end
            end
            TEMP <= MEM[MAR];
            STATO = st4;
         end
         st4 : begin
            if(MAR == 31) begin
               if(START == 1'b1) begin
                  STATO = st4;
               end
               else begin
                  STATO = st1;
               end
               EN_DISP <= 1'b0;
            end
            else begin
               MAR <= MAR + 1;
               STATO = st3;
            end
         end
      endcase
   end
end


endmodule
