----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:09:31 04/25/2017 
-- Design Name: 
-- Module Name:    Pipeline1 - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline1 is
    Port ( InstrIn : in  STD_LOGIC_VECTOR (31 downto 0);
			  CLK : in STD_LOGIC;
			  alea : in STD_LOGIC;
           OP : out  STD_LOGIC_VECTOR (7 downto 0);
           A : out  STD_LOGIC_VECTOR (15 downto 0);
           B : out  STD_LOGIC_VECTOR (15 downto 0);
           C : out  STD_LOGIC_VECTOR (15 downto 0));
end Pipeline1;

architecture Behavioral of Pipeline1 is
	
begin
	process
	
	begin
	wait until CLK'event and CLK='1';
		if alea = '0' then
			OP <= InstrIn(31 downto 24);
			
			if InstrIn(31 downto 24) = x"02" or InstrIn(31 downto 24) = x"06" or InstrIn(31 downto 24) = x"07" then -- si STORE, JMP ou JMPC
				A <= InstrIn(23 downto 8); -- A fait 4o
			else
				A <= x"00" & InstrIn(23 downto 16); -- A fait 2o
			end if;
			
			if InstrIn(31 downto 24) = x"01" or InstrIn(31 downto 24) = x"05" then -- si LOAD, AFC 
				B <= InstrIn(15 downto 0); -- B fait 4o
			else
				-- copie A si ADD, SUB, NEG, JMPI, OR, AND, INF, INFE, SUP, SUPE, EQU
				if (InstrIn(31 downto 24) /= x"01" and InstrIn(31 downto 24) /= x"02" and InstrIn(31 downto 24) /= x"06" and InstrIn(31 downto 24) /= x"07" and InstrIn(31 downto 24) /= x"12") then-- copie pas A si LOAD, AFC, JMP, JMPC, MOV
					B <= x"00" & InstrIn(23 downto 16); -- B = A
				else
					if InstrIn(31 downto 24) = x"02" or InstrIn(31 downto 24) = x"07" -- si STORE ou JMPC
					then
						B <= x"00" & InstrIn(7 downto 0); -- B = C !!
					else
						B <= x"00" & InstrIn(15 downto 8); -- B fait 2o
					end if;
				end if;
			end if;
			
			-- copie B si ADD, SUB, NEG, JMPI, OR, AND, INF, INFE, SUP, SUPE, EQU
			if (InstrIn(31 downto 24) = x"03" or InstrIn(31 downto 24) = x"04" or InstrIn(31 downto 24) = x"10" or InstrIn(31 downto 24) = x"09" or InstrIn(31 downto 24) = x"0a" or InstrIn(31 downto 24) = x"0b" or InstrIn(31 downto 24) = x"0c" or InstrIn(31 downto 24) = x"0d" or InstrIn(31 downto 24) = x"0e" or InstrIn(31 downto 24) = x"0f")
			then
				C <= x"00" & InstrIn(15 downto 8); -- C = B
			elsif (InstrIn(31 downto 24) = x"02" or InstrIn(31 downto 24) = x"07") then -- si STORE ou JMPC
				C <= x"00" & InstrIn(7 downto 0); -- C = C
			else
				C <= x"0000"; -- C = 0
			end if;
		end if;
	end process;

end Behavioral;
