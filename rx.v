module Rx(stop_bit,data_out,par_bit_out,err,bd_rate_gen,par,s_num,d_num,start,reset);
  output reg [7:0] data_out; 
  output reg stop_bit,par_bit_out,err;
  input bd_rate_gen,d_num,start,s_num,reset;
  input [1:0] par; 
  reg [7:0] count_rx;
  reg [7:0] data;
  reg [2:0] state;
  reg par_bit_check;
  reg start_count;
  reg [1:0] stop_bit_counter;
  parameter s0=3'b000;
  parameter s1=3'b001; 
  parameter s2=3'b010;
  parameter s3=3'b011;
  parameter s4=3'b100;
  parameter s5=3'b101;
  parameter s6=3'b110;
  parameter s7=2'b00;
  parameter s8=2'b01;
  parameter s9=2'b10;
   
  always @(posedge bd_rate_gen)begin 
     if(start_count) 
    count_rx=count_rx+1; 
  else if(!start_count) 
      count_rx=8'b0; 
    if(reset) begin 
      state=3'b000;
      stop_bit_counter=2'b00;
      data=8'b0;
      count_rx=8'b0;
      data_out=8'b0;
      stop_bit=1'b0;
      par_bit_out=1'b0;
      err=1'b0;
      par_bit_check=1'b0;
          end 
  else if(!reset) begin 
    case(state) 
      s0: begin 
        if(start) begin 
          state<=3'b000;
          start_count<=1'b0; end 
        else if(!start) begin  
        state<=3'b001;
        start_count<=1'b1; end  
       end  
     s1: begin if ((count_rx==8'd8)&&(start==0)) 
     state<=3'b010; 
     else if((count_rx==8'd8)&&(start==1)) 
       state<=3'b000;
     end 
       s2: begin 
   if(count_rx==8'd24) 
    data[0]<=start; 
  else if(count_rx==8'd40) 
  data[1]<=start; 
else if (count_rx==8'd56) 
   data[2]<=start; 
  else if(count_rx==8'd72) 
    data[3]<=start; 
  else if(count_rx==8'd88) 
    data[4]<=start; 
  else if(count_rx==8'd104) begin 
    data[5]<=start; state<=3'b011;
  end  
  end 
  s3: begin 
    if(!d_num) begin 
        if(count_rx==8'd120) begin 
        data[6]<=start;
        state<=3'b100; end 
      end 
    else if(d_num) begin 
         if(count_rx==8'd120)
       data[6]<=start; 
     else if(count_rx==8'd136) begin 
       count_rx<=8'd0;
     data[7]<=start;
     state<=3'b100; 
   end    
 end 
  end 
  s4: begin 
    par_bit_check=start;
    if(d_num) begin 
    case (par) 
    s7: par_bit_out<=1'bx; 
    s8: par_bit_out<=((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6])^(data[7]));
    s9: par_bit_out<=~((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6])^(data[7])); 
    endcase
    err<=(par_bit_out)^(par_bit_check);
    state<=3'b101;  
  end 
else if(!d_num) begin 
 case (par) 
    s7: par_bit_out<=1'bx; 
    s8: par_bit_out<=((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6]));
    s9: par_bit_out<=~((data[0])^(data[1])^(data[2])^(data[3])^(data[4])^(data[5])^(data[6])); 
    endcase 
    err<=(par_bit_out)^(par_bit_check);
    state<=3'b101;
  end 
end 
s5: begin
 stop_bit<=1; 
  stop_bit_counter=stop_bit_counter+1; 
  if(!s_num) begin  
      if(stop_bit_counter==2'b10) begin 
    stop_bit_counter<=2'b00;
    stop_bit<=0;
    state<=3'b110;
  end 
end 
 else if(s_num)  begin 
  if(stop_bit_counter==2'b11) begin 
    stop_bit_counter<=2'b00;
    stop_bit<=0;
    state<=3'b110; 
  end 
end 
end
s6: begin 
if(!d_num) begin 
      data_out[0]<=data[0];
      data_out[1]<=data[1];
      data_out[2]<=data[2]; 
      data_out[3]<=data[3]; 
      data_out[4]<=data[4];
      data_out[5]<=data[5];
      data_out[6]<=data[6];
      state<=3'b000;
    end 
  else if(d_num) begin 
      data_out[0]<=data[0];
      data_out[1]<=data[1];
      data_out[2]<=data[2];
      data_out[3]<=data[3];
      data_out[4]<=data[4];
      data_out[5]<=data[5];
      data_out[6]<=data[6];
      data_out[7]<=data[7];
      state<=3'b000;
    end
  end  
endcase
end 
end 
endmodule 