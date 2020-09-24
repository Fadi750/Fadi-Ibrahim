library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


    entity pwm is
      port( clk    : in std_logic;
            rst  : in std_logic;
            d_cycle: in std_logic_vector(3 downto 0);
            pulse  : out std_logic);
          end pwm;
          
          
        architecture behavior of pwm is 
           signal p_w : std_logic_vector(3 downto 0);
           signal counter : std_logic_vector(3 downto 0);
           type state_type is (a,b);
           signal state : state_type;
           
           begin 
             process(rst,clk)
               begin 
                 if(rst='1') then 
                     state<=a;
                     
                     
                 elsif(clk'event and clk='1') then
                     
                     case state is 
                      when a=>
                        p_w<=d_cycle;
                        counter<="0000";
                        state<=b;
                        
                      when b=>
                        counter<=counter + 1;
                        if(counter="1111") then 
                          state<=a;
                        else
                           state<=b;
                        end if;
                        
                        if(counter<=p_w) then 
                           pulse<='1';
                        else
                           pulse<='0';
                        end if;
                           
                         end case;
                       end if;
                     end process;
                   end behavior;
                        
                        
                         
                           
                         
                        
                        