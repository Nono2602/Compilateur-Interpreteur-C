--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:22:25 04/18/2017
-- Design Name:   
-- Module Name:   /home/artigouh/Documents/Syst info/archi/Archi/Test_BancReg.vhd
-- Project Name:  Archi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BancReg
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Test_BancReg IS
END Test_BancReg;
 
ARCHITECTURE behavior OF Test_BancReg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BancReg
    PORT(
         A : IN  std_logic_vector(0 to 7);
         B : IN  std_logic_vector(0 to 7);
         WAddr : IN  std_logic_vector(0 to 7);
         W : IN  std_logic;
         Data : IN  std_logic_vector(0 to 15);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(0 to 15);
         QB : OUT  std_logic_vector(0 to 15)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(0 to 7) := (others => '0');
   signal B : std_logic_vector(0 to 7) := (others => '0');
   signal WAddr : std_logic_vector(0 to 7) := (others => '0');
   signal W : std_logic := '0';
   signal Data : std_logic_vector(0 to 15) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(0 to 15);
   signal QB : std_logic_vector(0 to 15);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BancReg PORT MAP (
          A => A,
          B => B,
          WAddr => WAddr,
          W => W,
          Data => Data,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
        );

	CLK <= not CLK after 5 ns;
	RST <= '1' after 20 ns, '0' after 70 ns, '1' after 80 ns;
	WAddr <= "00000010" after 40 ns, "00000011" after 50 ns, "00000010" after 90 ns, "00000011" after 110 ns ;
	Data <= x"00f0";
	W <= '1' after 30 ns, '0' after 60 ns, '1' after 100 ns, '0' after 120 ns;
	A <= "00000010" after 35 ns;
	B <= "00000011" after 35 ns;
	
END;
