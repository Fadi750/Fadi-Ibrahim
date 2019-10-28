module controler(data_in,clkdiv,enable,bd_rate,par_check,s_num_sig,d_num,par,s_num,bd_rate_gen,alarm_sig,shut_down_sig,data_in_tx,enable_tx,reset,
bd_rate_tx);
  input [8:0] data_in;
  input clkdiv,enable,s_num_sig,reset;
  input [1:0] par_check,bd_rate;
  output reg bd_rate_gen,alarm_sig,shut_down_sig;
  output reg [7:0] data_in_tx;
  output reg [1:0] par;
  output reg d_num,s_num,enable_tx,bd_rate_tx;
  reg [11:0] freq_div;
  reg start_count;
  reg[4:0] count;
  parameter s0=2'b00;
  parameter s1=2'b01;
  parameter s2=2'b10;
  parameter s3=2'b11;
   always@(posedge clkdiv) begin 
     if(shut_down_sig) begin 
       bd_rate_gen<=0;
       bd_rate_tx<=0;
       d_num<=1'bx;
       data_in_tx<=8'bx;
       freq_div<=12'b0;
     end 
    if(start_count) 
    freq_div=freq_div+1; 
  else if(!start_count) 
    freq_div=12'b0; 
    if(reset) begin 
      bd_rate_gen=0;
      freq_div=12'b0;
      alarm_sig=0;
      shut_down_sig=0;
      start_count=1;
      d_num=0;
      data_in_tx=8'b0;
      count=5'b0;
    end 
  else if(!reset) begin 
    case(bd_rate) 
      s0:  begin 
      if(freq_div==12'd2604) begin 
        freq_div<=12'b0;
        bd_rate_gen<=1;
        start_count<=0;
      end 
    else  begin
        start_count<=1;
        bd_rate_gen<=0;
      end  
      end
      s1: begin 
        if(freq_div==12'd1302) begin 
         freq_div<=12'b0;
        bd_rate_gen<=1;
        start_count<=0;
      end 
      else  begin start_count<=1;
        bd_rate_gen<=0; end 
      end
    s2: begin 
    if(freq_div==12'd12) begin 
     freq_div<=12'b0;
        bd_rate_gen<=1;
        start_count<=0;
      end 
     else  begin 
        start_count<=1;
        bd_rate_gen<=0;
      end     
   end
    s3: begin 
    if(freq_div==12'd326) begin 
     freq_div<=12'b0;
        bd_rate_gen<=1;
        start_count<=0;
      end 
     else begin 
      start_count<=1;
       bd_rate_gen<=0; end 
    end
  endcase 
  if(enable)  begin 
    if(data_in[7]==0) begin  
    d_num=0;
    data_in_tx[0]=data_in[0];
    data_in_tx[1]=data_in[1];
    data_in_tx[2]=data_in[2];
    data_in_tx[3]=data_in[3];
    data_in_tx[4]=data_in[4];
    data_in_tx[4]=data_in[4];
    data_in_tx[5]=data_in[5];
    data_in_tx[6]=data_in[6];
  end 
 else if(data_in[7]==1) begin 
   d_num=1;
    data_in_tx[0]=data_in[0];
    data_in_tx[1]=data_in[1];
    data_in_tx[2]=data_in[2];
    data_in_tx[3]=data_in[3];
    data_in_tx[4]=data_in[4];
    data_in_tx[4]=data_in[4];
    data_in_tx[5]=data_in[5];
    data_in_tx[6]=data_in[6];
    data_in_tx[7]=data_in[7]; 
 end 
  if(data_in==9'd250) begin 
   d_num=1;
 data_in_tx=data_in; 
 alarm_sig=1;  
  end 
 else if(data_in==9'd300)begin  
   shut_down_sig=1; end 
  else begin 
   d_num=1'bx;
   data_in_tx=8'bx;
 end 
    case(par_check) 
     2'b00: par=2'b00;
     2'b01: par=2'b01;
     2'b10: par=2'b10;
     default:;
   endcase
   case(s_num_sig) 
     1'b0: s_num=0;
     1'b1: s_num=1;
   endcase 
   case(enable) 
     1'b0: enable_tx=0;
     1'b1: enable_tx=1;
   endcase
 end
 end
 end  
 always@(posedge bd_rate_gen) begin 
    count=count+1;
    if(count==5'd16) begin 
      count=5'b0; 
      bd_rate_tx=1; 
    end 
  else bd_rate_tx=0;
  end 
  endmodule 