----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 09:16:15 PM
-- Design Name: 
-- Module Name: top_transmit - trans_arch
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_transmit is
Port (TXD, clk : in std_logic;
      btn : in std_logic_vector(1 downto 0);
      RXD, CTS, RTS : out std_logic);
end top_transmit;

architecture trans_arch of top_transmit is
signal dbnc1, dbnc2, div_sig, ready, send, outrxd  : std_logic;
signal char : std_logic_vector(7 downto 0);

 component debouncer
     port ( btn, clk : in std_logic;
           dbnc     : out std_logic);
    end component;


   component clock_div
   port(
        clk  : in std_logic;      
        div : out std_logic);
    end component;
   component sender
       Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           send : out STD_LOGIC;
           ready : in std_logic;
           btn : in std_logic;
           char : out STD_LOGIC_VECTOR (7 downto 0));
 end component;
      component  uart
    port (

    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)
);
end component;
      
            
begin 
RTS<='0';
CTS<='0';
    u1 : debouncer
        port map (btn => btn(0),
                  clk => clk,
                  dbnc => dbnc1);
    
    u2 : debouncer
        port map (btn => btn(1),
                  clk => clk,
                  dbnc => dbnc2); 
    u3 : clock_div  
        port map (clk => clk,
                  div=> div_sig);

    u4 : sender
        port map ( clk => clk,
                 ce=> div_sig, 
                 ready => ready,
                 send=>send,
                   char=> char,
                   reset =>dbnc1,
                   btn=>dbnc2);
     u5 : uart
     port map(send => send,
                rst=>dbnc1,
                clk => clk,
                en=> div_sig,
                rx=>TXD,
                charsend=>char,
                tx=> outrxd);
                            
RXD<=outrxd;
end trans_arch;
