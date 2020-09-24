module dec_pro(clk,rst1,rst2,led);
    input clk,rst1,rst2;
    output reg led;
    reg [127:0] data_dec;
    reg [127:0] key [9:0];
    integer i;
    wire [127:0] shift_d,inv_sbox,mix_d;
    wire [127:0] data_enc;
    wire encr;
    reg [127:0] add_d;
    reg en_i,rnd;
    reg [1:0] state;
    
     Enc_hardware enc(clk,rst1,data_enc,encr);
     inversemix i_mix1(mix_d,add_d,clk,en_i);
     inv_shift i_shift1(mix_d,shift_d); 
     invsbox i_sbox1(shift_d[7:0],inv_sbox[7:0]);
     invsbox i_sbox2(shift_d[15:8],inv_sbox[15:8]);
     invsbox i_sbox3(shift_d[23:16],inv_sbox[23:16]);
     invsbox i_sbox4(shift_d[31:24],inv_sbox[31:24]);
     invsbox i_sbox5(shift_d[39:32],inv_sbox[39:32]);
     invsbox i_sbox6(shift_d[47:40],inv_sbox[47:40]);
     invsbox i_sbox7(shift_d[55:48],inv_sbox[55:48]);
     invsbox i_sbox8(shift_d[63:56],inv_sbox[63:56]);
     invsbox i_sbox9(shift_d[71:64],inv_sbox[71:64]);
     invsbox i_sbox10(shift_d[79:72],inv_sbox[79:72]);
     invsbox i_sbox11(shift_d[87:80],inv_sbox[87:80]);
     invsbox i_sbox12(shift_d[95:88],inv_sbox[95:88]);
     invsbox i_sbox13(shift_d[103:96],inv_sbox[103:96]);
     invsbox i_sbox14(shift_d[111:104],inv_sbox[111:104]);
     invsbox i_sbox15(shift_d[119:112],inv_sbox[119:112]);
     invsbox i_sbox16(shift_d[127:120],inv_sbox[127:120]);
      always@(posedge clk) begin 
           led<=data_dec&128'h00112233445566778899aabbccddeeff;
           
        if(rst2) begin 
           
           en_i<=1'b0;
           i=10;
           data_dec<=128'b0;
           led<=1'b0;
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
           
           
 
         end
       else if(!rst2) begin
            case(encr) 
       1'b1:begin 
          if(i==10) begin
          state<=2'b00;
      end
         else 
           state<=2'b10;
      end
        1'b0:begin
           data_dec<=128'b0;
          end
        endcase
         case(state)
       2'b00:begin 
         
         add_d<=data_enc^128'h13111d7fe3944a17f307a78b4d2b30c5;
          if(rnd) 
            state<=2'b01;
          else 
            state<=2'b00;
          end
       2'b01:begin 
           if(i!=0) begin
             i=i-1;
             en_i<=1'b1;
             add_d<=key[i]^inv_sbox;
             state<=2'b00;
         end
           else begin
            state<=2'b10; 
            en_i<=1'b0; end
           end
        2'b10:begin 
           data_dec<=add_d;
           i=10;
           rnd<=1'b0;
          end
       endcase
     end
  end
         
           
           always@(inv_sbox) begin
                rnd<=1'b1;
            end
          endmodule
                 



