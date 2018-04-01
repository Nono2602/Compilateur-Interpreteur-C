----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:29:32 04/25/2017 
-- Design Name: 
-- Module Name:    Pipeline2 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline2 is
    Port ( OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Ain : in  STD_LOGIC_VECTOR (15 downto 0);
           Bin : in  STD_LOGIC_VECTOR (15 downto 0);
           Cin : in  STD_LOGIC_VECTOR (15 downto 0);
			  CLK : in STD_LOGIC;
			  alea : in STD_LOGIC;
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (15 downto 0);
           Bout : out  STD_LOGIC_VECTOR (15 downto 0);
           Cout : out  STD_LOGIC_VECTOR (15 downto 0));
end Pipeline2;

architecture Behavioral of Pipeline2 is
	signal flagJmp1 : std_logic := '0';
	signal flagJmp2 : std_logic := '0';
begin
	process
	
	begin
	wait until CLK'event and CLK='1';
		if alea = '0' and flagJmp1 = '0' and flagJmp2 = '0' then
			OPout <= OPin;
			Aout <= Ain;
			Bout <= Bin;
			Cout <= Cin;
			if OPin = x"06" or OPin = x"08" or (OPin = x"07" and Bin = x"0001") then -- on vient de faire passer un jump
				flagJmp1 <= '1';
			end if;
		else
			OPout <= x"00";
			Aout <= x"0000";
			Bout <= x"0000";
			Cout <= x"0000";
		end if;
		
		if flagJmp1 = '1' then
			flagJmp1 <= '0';
			flagJmp2 <= '1';
		else
			flagJmp2 <= '0';
		end if;
	end process;

end Behavioral;

