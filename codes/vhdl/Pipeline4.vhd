----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:33:21 04/25/2017 
-- Design Name: 
-- Module Name:    Pipeline4 - Behavioral 
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

entity Pipeline4 is
    Port ( OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Ain : in  STD_LOGIC_VECTOR (15 downto 0);
           Bin : in  STD_LOGIC_VECTOR (15 downto 0);
			  CLK : in STD_LOGIC;
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (15 downto 0);
           Bout : out  STD_LOGIC_VECTOR (15 downto 0));
end Pipeline4;

architecture Behavioral of Pipeline4 is

begin
	process
	
	begin
	wait until CLK'event and CLK='1';
		OPout <= OPin;
		Aout <= Ain;
		Bout <= Bin;
	end process;

end Behavioral;

