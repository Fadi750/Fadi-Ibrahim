module Enc_hardware(clk,rst1,data_enc,encr);
   input clk,rst1;
   reg fin;
   output reg [127:0] data_enc;
   output reg encr;
   reg [127:0] key [10:0];
   integer i;
   wire [127:0] shift_d,s_box,mix_d;
   reg [127:0] add_d;
   reg [127:0] text;
   reg en_m;
   reg [1:0] state;
 
    
    
     
     sbox sbox1(add_d[7:0],s_box[7:0]);
     sbox sbox2(add_d[15:8],s_box[15:8]);
     sbox sbox3(add_d[23:16],s_box[23:16]);
     sbox sbox4(add_d[31:24],s_box[31:24]);
     sbox sbox5(add_d[39:32],s_box[39:32]);
     sbox sbox6(add_d[47:40],s_box[47:40]);
     sbox sbox7(add_d[55:48],s_box[55:48]);
     sbox sbox8(add_d[63:56],s_box[63:56]);
     sbox sbox9(add_d[71:64],s_box[71:64]);
     sbox sbox10(add_d[79:72],s_box[79:72]);
     sbox sbox11(add_d[87:80],s_box[87:80]);
     sbox sbox12(add_d[95:88],s_box[95:88]);
     sbox sbox13(add_d[103:96],s_box[103:96]);
     sbox sbox14(add_d[111:104],s_box[111:104]);
     sbox sbox15(add_d[119:112],s_box[119:112]);
     sbox sbox16(add_d[127:120],s_box[127:120]);
     Shiftrows shift1(s_box,shift_d);
     mixcolumn mix1(clk,en_m,shift_d,mix_d); 
     
       always@(posedge clk) begin 
          
           if(i==9) begin
           en_m<=1'b0; end
         else if(i!=9) begin
            en_m<=1'b1; end 
        if(rst1) begin 
           data_enc<=128'b0;
           state<=2'b00;
           i=0;
           text<=128'h00112233445566778899aabbccddeeff;
           encr<=1'b0;
		   key[0]<=128'h000102030405060708090a0b0c0d0e0f;
           key[1]<=128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
           key[2]<=128'hb692cf0b643dbdf1be9bc5006830b3fe;
           key[3]<=128'hb6ff744ed2c2c9bf6c590cbf0469bf41;
           key[4]<=128'h47f7f7bc95353e03f96c32bcfd058dfd;
           key[5]<=128'h3caaa3e8a99f9deb50f3af57adf622aa;
           key[6]<=128'h5e390f7df7a69296a7553dc10aa31f6b;
           key[7]<=128'h14f9701ae35fe28c440adf4d4ea9c026;
           key[8]<=128'h47438735a41c65b9e016baf4aebf7ad2;
           key[9]<=128'h549932d1f08557681093ed9cbe2c974e;
           key[10]<=128'h13111d7fe3944a17f307a78b4d2b30c5;
       end
         else if(!rst1) begin 
           case(state)
             2'b00:begin 
                   state<=2'b01;
                   add_d<=text^key[i]; 
                 end
             2'b01:begin 
                 if(fin) begin 
                   i=i+1;
                   state<=2'b10;
                 end 
                else if(!fin) begin 
                  state<=2'b01; end
             end
             2'b10:begin
               add_d<=key[i]^mix_d;
                  fin<=1'b0;
                if(i!=10) begin  
                  state<=2'b01; end
                else if(i==10) begin 
                  state<=2'b11; end 
                end
              2'b11:begin 
                  data_enc<=add_d;
                  encr<=1'b1;
                  i=0;
                  state<=2'b00;
                 end
               endcase
             end
           end
                  always@(mix_d) begin 
                    fin<=1'b1;
                  end
                
                endmodule
     
     
     