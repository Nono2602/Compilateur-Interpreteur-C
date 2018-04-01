----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:23:07 03/28/2017 
-- Design Name: 
-- Module Name:    UAL - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UAL is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (3 downto 0);
           S : out  STD_LOGIC_VECTOR (15 downto 0);
           Flags : out  STD_LOGIC_VECTOR (3 downto 0)); -- N O Z C
end UAL;

architecture Behavioral of UAL is
	signal temp_s : STD_LOGIC_VECTOR (31 downto 0);
	
begin
	
	temp_s <= (x"0000" & A) + (x"0000" & B) when Ctrl_Alu = "0000"									-- add
		else (x"0000" & A) - (x"0000" & B) when Ctrl_Alu = "0001"									-- sub
		else ((not A) + x"00000001") when Ctrl_Alu = "0010"											-- neg
		else x"00000001" when Ctrl_Alu = "0011" and A < B												-- inf true
		else x"00000000" when Ctrl_Alu = "0011" and A >= B												-- inf false
		else x"00000001" when Ctrl_Alu = "0100" and A <= B												-- infe true
		else x"00000000" when Ctrl_Alu = "0100" and A > B												-- infe false
		else x"00000001" when Ctrl_Alu = "0101" and A > B												-- sup true
		else x"00000000" when Ctrl_Alu = "0101" and A <= B												-- sup false
		else x"00000001" when Ctrl_Alu = "0110" and A >= B												-- supe true
		else x"00000000" when Ctrl_Alu = "0110" and A < B												-- supe false
		else x"00000001" when Ctrl_Alu = "0111" and A = B												-- ==
		else x"00000000" when Ctrl_Alu = "0111" and A /= B												-- !=
		else x"00000001" when Ctrl_Alu = "1000" and A = x"00000001" and B = x"00000001"		-- &&
		else x"00000000" when Ctrl_Alu = "1000" and (A /= x"00000001" or B /= x"00000001")	-- !&&
		else x"00000001" when Ctrl_Alu = "1001" and (A = x"00000001" or B = x"00000001")		-- ||
		else x"00000000" when Ctrl_Alu = "1001" and A = x"00000000" and B = x"00000000"		-- !||
		else x"ffffffff"; -- error
	
	--vrai = 0 et faux = 1
	Flags(0) <= '0' when temp_s(31) = '1' else '1'; -- N
	Flags(1) <= '0' when temp_s(30 downto 16) /= x"0000" and temp_s(31) = '0' else '1'; -- O
	Flags(2) <= '0' when temp_s = x"00000000" else '1'; -- Z
	Flags(3) <= '0' when temp_s(16) /= '0' and temp_s(31) = '0' else '1'; -- C
	
	S <= temp_s(15 downto 0);
	
end Behavioral;