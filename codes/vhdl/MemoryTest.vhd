----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:59:39 04/25/2017 
-- Design Name: 
-- Module Name:    MemoryTest - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemoryTest is
    Port ( IP : in  STD_LOGIC_VECTOR (15 downto 0);
           InstrOut : out  STD_LOGIC_VECTOR (31 downto 0));
end MemoryTest;

architecture Behavioral of MemoryTest is
	type MEM is array (0 to 65535) of STD_LOGIC_VECTOR (31 downto 0); -- 2¹⁶ = 65536
	signal memory : MEM;
begin
	InstrOut <= memory(to_integer(unsigned(IP)));
	memory <= (x"00000000",x"11111111",others => x"00000000");
end Behavioral;

