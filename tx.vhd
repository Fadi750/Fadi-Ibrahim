library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.all;

    entity tx is
      port(clk : in std_logic;
           rst : in std_logic;
           data: in std_logic_vector (7 downto 0);
           start: out std_logic);
         end tx;
         
         
         architecture behavior of tx is 
             type state_case is (a,b,c,d);
             signal state : state_case;
             signal par   : std_logic;
             signal counter: std_logic_vector(2 downto 0);
             begin 
               process(rst,clk)
                 begin 
                   if(rst='1') then
                     counter<="000";
                     state<=a;
                     start<='1';
                     
                   elsif (clk'event and clk='1') then 
                     case state is 
                       when a=>
                         par<=data(7) xor data(6) xor data(5) xor data(4) xor data(3) xor data(2) xor data(1) xor data(0);
                         start<='0';
                         state<=b;
                         
                       when b=>
                         start<=data(to_integer(unsigned(counter)));
                         if(counter<"111") then 
                             counter<=counter+1;
                             state<=b;
                         else 
                             counter<="000";
                             state<=c;
                         end if;
                         
                         
                        when c=>
                          start<=par;
                          state<=d;
                        
                        when d=>
                          start<='1';
                          state<=a;
                          
                        end case;
                       end if;
                      end process;
                    end behavior;   
