module Tx(start,data_in_tx,bd_rate_tx,d_num,par,reset,enable);
  output reg start;
  input [7:0] data_in_tx; 
  input [1:0] par; 
  input bd_rate_tx,d_num,enable; 
  input reset;
  reg [7:0] data;
  reg [4:0] count_tx; 
  reg par_bit;
  reg [1:0] state;
  reg start_count; 
  parameter s0=2'b00;
  parameter s1=2'b01;
  parameter s2=2'b10;
  parameter s3=3'b11;
  always@(posedge bd_rate_tx) begin 
      if(start_count) 
        count_tx=count_tx+1;
      else if(!start_count) 
        count_tx=4'b0; 
         if(reset) begin 
         state<=2'b0; 
         start<=1'b1;
         count_tx<=4'b0;
         start_count<=1'b0;
         par_bit<=2'b0;
         end 
     if(!reset) begin 
     case(state) 
     s0: begin
      if(enable) 
     state<=2'b01;
   else if(!enable)
       state<=2'b00;  
     end  
     s1: begin 
       start<=0; 
       if(d_num) begin 
          data [0]<= data_in_tx[0];  
          data [1]<= data_in_tx[1];
          data [2]<= data_in_tx[2];
          data [3]<= data_in_tx[3]; 
          data [4]<= data_in_tx[4]; 
          data [5]<= data_in_tx[5]; 
          data [6]<= data_in_tx[6]; 
          data [7]<= data_in_tx[7];
          state<=2'b10;
        end 
     else if(!d_num) begin 
          data [0]<= data_in_tx[0];  
          data [1]<= data_in_tx[1];
          data [2]<= data_in_tx[2];
          data [3]<= data_in_tx[3]; 
          data [4]<= data_in_tx[4]; 
          data [5]<= data_in_tx[5]; 
          data [6]<= data_in_tx[6];
          state<=2'b10;
       end  
     end 
   s2:  begin 
       start_count=1'b1;  
       if(d_num) begin 
          if(count_tx==4'd0) 
           start<=data[0];
          if(count_tx==4'd1) 
           start<=data[1];
          if(count_tx==4'd2)
           start<=data[2];
          if(count_tx==4'd3)
           start<=data[3];
          if(count_tx==4'd4)
           start<=data[4];
          if(count_tx==4'd5) 
           start<=data[5];
          if(count_tx==4'd6)
            start<=data[6];
          if(count_tx==4'd7) begin 
            count_tx<=4'b0;
            start_count<=0;
            start<=data[7];
            state<=2'b11; 
          end 
         case(par) 
            2'b00: par_bit=1'bx; 
            2'b01: par_bit=((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6])^(data[7]));
            2'b10: par_bit=~((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6])^(data[7]));
          endcase   
        end   
      else if(!d_num)  begin 
        if(count_tx==4'd0) 
           start<=data[0];
          if(count_tx==4'd1) 
           start<=data[1];
          if(count_tx==4'd2)
           start<=data[2];
          if(count_tx==4'd3)
           start<=data[3];
          if(count_tx==4'd4)
           start<=data[4];
          if(count_tx==4'd5) 
           start<=data[5];
          if(count_tx==4'd6) begin 
            count_tx<=4'b0;
            start_count<=0;
            start<=data[6];
            state<=2'b11;
          end 
        case(par) 
            2'b00: par_bit=1'bx; 
            2'b01: par_bit=((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6]));
            2'b10: par_bit=~((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6]));
          endcase  
        end 
      end
      s3: begin 
        start<=par_bit; 
        state<=2'b00;
        end 
    endcase
  end 
end 
endmodule 