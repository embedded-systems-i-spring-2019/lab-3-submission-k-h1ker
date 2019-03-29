----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 02:10:07 PM
-- Design Name: 
-- Module Name: uart_tx - uart_tx_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           send : in STD_LOGIC;
           rst : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           tx : out STD_LOGIC);
end uart_tx;

architecture uart_tx_arch of uart_tx is
signal char_reg : std_logic_vector(7 downto 0);
type state_type is (idle, start, d1, d2, d3, d4, d5, d6, d7);
signal ps : state_type := idle;
--signal ns : state_type;
begin

process(clk)
    begin
    if clk'event and clk = '1' then
       --ps <= ns;
        if rst = '1' then
            char_reg<= (others=> '0');
            ps <= idle;
            tx<='1';
            ready<='1';
            --char_reg<= (others=> '0');
         
       elsif en ='1' then 
         if send = '1' then
            char_reg <= char;
         end if;
    
    case ps is 
        when idle =>
        
       -- ready <= '1';
       -- tx <= '1';
        if send = '1' then
            char_reg <= char;
            tx<= '0';
            ready <='0';
            ps <= start;
            
        else 
            tx <= '1';    
            ready <= '1';
       
       end if;
        
        when start =>
      
               tx <=char_reg(0);
               ready <= '0';
               ps <= d1;
    
        when d1 =>
      --   if send = '1' then 
           tx <= char_reg(1);
           ready <= '0';
           
           --if en = '1' then 
                ps <= d2 ;
       
        when d2 =>
       --  if send = '1' then
            tx <= char_reg(2);                    
            ready <= '0';
            --if en = '1' then 
                ps <= d3;
                
                
     
                 
        when d3 =>
         --if send = '1' then
            tx <= char_reg(3);                    
            ready <= '0';
            --if en = '1' then 
                ps <=d4 ;
     
        when d4 =>
        -- if send = '1' then
            tx <= char_reg(4);                    
            ready <= '0';
            --if en = '1' then 
                ps <=d5 ;
      
        when d5 =>
        -- if send = '1' then
            tx <= char_reg(5);                    
            ready <= '0';
            --if en = '1' then 
                ps <=d6 ;
        
         when d6 =>
       --   if send = '1' then
            tx <= char_reg(6);                    
            ready <= '0';
           -- if en = '1' then 
                ps <=d7 ;
                     
                    
        when d7 =>
       --  if send = '1' then
            tx <= char_reg(7);                    
            ready <= '0';
            --if en = '1' then 
               ps <=idle;
       
                        
                    
    end case;
end if;
end if;
   --end if;
end process;

                    
end uart_tx_arch;
