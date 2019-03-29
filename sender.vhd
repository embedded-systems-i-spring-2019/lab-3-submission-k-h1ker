----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 09:03:16 PM
-- Design Name: 
-- Module Name: sender - sender_arch
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

entity sender is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           send : out STD_LOGIC;
           ready : in std_logic;
           btn : in std_logic;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end sender;

architecture sender_arch of sender is

type state_type is (IDLE,busyA,busyB,busyC);
signal ps: state_type :=idle; 
signal bicounter : std_logic_vector(2 downto 0); 
type netid_arr is array(0 to 5) of std_logic_vector(7 downto 0);
signal NETID : netid_arr  := (x"6b", x"6d", x"68", x"32", x"38", x"39");
begin

process(clk,ce)
begin
    if(clk'event and clk ='1' and ce='1') then
        if(reset='1') then
            ps<=idle; 
            char<=(others => '0');
            bicounter<="000";
            send<='0';
         end if;
        case ps is
           when idle=>
              if(  btn='1'and ready='1' and unsigned(bicounter)<6) then
                    send<='1';
                     bicounter<=std_logic_vector(unsigned(bicounter)+1);
                     ps<=busyA;
                    
                    char<=NETID(to_integer(unsigned(bicounter)));
                 elsif(btn='1' and ready='1' and unsigned(bicounter)=6) then
                    bicounter<="000";
                    ps<=idle;
                  end if;
             When busyA=>
                 ps<=busyB;
             When busyB=>
                 send<='0';
                 ps<=busyC;
             When busyC=> 
                  if(ready='1' and btn='0') then
                      ps<=idle;
                   end if;
       end case;
         end if;
end process;
    
end architecture;