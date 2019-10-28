module digital_clock(clk, rst,month,day, hr,min,sec,clkdiv,counter,enable);
  input clk;
  input rst;
  output reg enable;
  reg [4:0] count_min; 
  output reg [4:0] day;
  output reg [3:0] month;
  output reg [4:0] hr;
  output reg [5:0] min;  
  output reg [5:0] sec;
  output reg clkdiv;
  output reg [14:0] counter;
  always@(posedge clk or posedge rst)
  begin
    if(rst) begin 
      counter<=15'b0;
      sec<=6'b0;
      min<=6'b0;
      hr<=5'b0;
      month<=4'b1;
      day<=5'b1;
      count_min<=5'b0;
    end 
  else if(!rst) begin 
    counter=counter+1;
   if(counter==15'd9)
  begin
    clkdiv<=1;
    counter<=0;
    sec=sec+1;
  end
  else if(sec==6'd4)
    begin 
     min=min+1;
     count_min<=count_min+1;
     sec<=0;
     end
     else if(min==6'b111011)
     begin 
     hr=hr+1;
     min<=0;
     end 
     else if ((hr==5'd23)&&(min==6'd59)&&(sec==6'd59))
       begin 
         day=day+1;
         hr<=0;
         end
      else if ((day==5'd30)&&(hr==5'd23)&&(min==6'd59)&&(sec==6'd59))
           begin
           month=month+1;
           day<=1;
            end 
else begin 
      clkdiv=0;
  end
   if((count_min==5'd1)&&(counter==15'd9)&&(sec==6'd4)) begin 
      count_min<=0;
      enable<=1;
      end 
      else
      enable<=0;
      end 
      end 
      endmodule


