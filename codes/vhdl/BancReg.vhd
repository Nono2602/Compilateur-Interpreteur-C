----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:04:29 04/18/2017 
-- Design Name: 
-- Module Name:    BancReg - Behavioral 
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

entity BancReg is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           WAddr : in  STD_LOGIC_VECTOR (7 downto 0);
           W : in  STD_LOGIC; -- actif à 1
           Data : in  STD_LOGIC_VECTOR (15 downto 0);
           RST : in  STD_LOGIC; -- actif à 0
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (15 downto 0);
           QB : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end BancReg;

architecture Behavioral of BancReg is
	type REG is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0); 
	signal regs : REG;
begin
	process
		variable index : Integer;
	begin
		wait until CLK'event and CLK='1';
		if RST='0' then -- reset
			loop1: FOR i IN 0 TO 15 LOOP
				regs(i) <= x"0000";
			END LOOP loop1;
		elsif W='1' then -- écriture
			regs(to_integer(unsigned(WAddr(3 downto 0)))) <= Data;
		end if;
	end process;
	
	-- lecture
	QA <= regs(to_integer(unsigned(A(3 downto 0)))) when W = '0' or Waddr /= A else Data;
	QB <= regs(to_integer(unsigned(B(3 downto 0)))) when W = '0' or Waddr /= B else Data;
	
end Behavioral;

