--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:10:20 05/09/2017
-- Design Name:   
-- Module Name:   /home/artigouh/Documents/Syst info/archi/Archi/Test_Pipeline1.vhd
-- Project Name:  Archi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Pipeline1
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
 
ENTITY Test_Pipeline1 IS
END Test_Pipeline1;
 
ARCHITECTURE behavior OF Test_Pipeline1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Pipeline1
    PORT(
         InstrIn : IN  std_logic_vector(31 downto 0);
			alea : IN std_logic;
         OP : OUT  std_logic_vector(7 downto 0);
         A : OUT  std_logic_vector(15 downto 0);
         B : OUT  std_logic_vector(15 downto 0);
         C : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal InstrIn : std_logic_vector(31 downto 0) := (others => '0');
	signal alea : std_logic := '0';

 	--Outputs
   signal OP : std_logic_vector(7 downto 0);
   signal A : std_logic_vector(15 downto 0);
   signal B : std_logic_vector(15 downto 0);
   signal C : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   pipe1: Pipeline1 PORT MAP (
          InstrIn => InstrIn,
			 alea => alea,
          OP => OP,
          A => A,
          B => B,
          C => C
        );
	
	InstrIn <= x"05010001", x"05010002" after 10 ns, x"05010003" after 20 ns, x"08010100" after 30 ns;

END;
