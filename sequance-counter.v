module  sequance_counter(pcount , in , out ,  rst ,clk);
        input in , out ,clk , rst ;
        output reg [2:0] pcount;
        reg [1:0] upstate=0;
        reg [1:0] dstate=0;
        
        always @(posedge clk , posedge rst)
        begin
            if(rst)
            begin
              pcount <= 3'b000;
              upstate <= 2'b00;
            end
            else
              case(upstate)
              2'b00: 
              begin
                if(in == 0) upstate <= 2'b01;
              end
              
              2'b01: 
              begin
                if(in == 1) upstate <= 2'b10;
              end
              
              2'b10:
              begin              
                if(in == 0) upstate <= 2'b01 ;
                else upstate <= 2'b00 ;
              end
              
              default:
                upstate <= 2'b00 ;
                
            endcase
          end
            
            always @(posedge clk , posedge rst)
            begin
              if(rst)
              begin
                pcount = 3'b000;
                dstate = 2'b00;
              end
              else
              case(dstate)
                2'b00: 
                begin
                  if(out == 0) dstate <= 2'b01;
                end
              
                2'b01: 
                begin
                  if(out == 1) dstate <= 2'b10;
                end
              
                2'b10:
                begin                
                if(out == 0) dstate <= 2'b01 ;
                else dstate <= 2'b00 ;                                
                end
                
                default:
                  dstate <= 2'b00 ;  
                
            endcase
            end
            
            always @(posedge clk)
             begin
             
                if(upstate == 2'b10 && dstate == 2'b10) pcount <= pcount;
                                
                else if (upstate == 2'b10) pcount <= pcount + 1;
                
                else if (dstate == 2'b10) pcount <= pcount - 1;
                                
             end
            
endmodule
        