--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:50:48 03/28/2017
-- Design Name:   
-- Module Name:   /home/artigouh/Documents/Syst info/archi/Archi/Test_UAL.vhd
-- Project Name:  Archi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UAL
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
 
ENTITY Test_UAL IS
END Test_UAL;
 
ARCHITECTURE behavior OF Test_UAL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UAL
    PORT(
         A : IN  std_logic_vector(0 to 15);
         B : IN  std_logic_vector(0 to 15);
         Ctrl_Alu : IN  std_logic_vector(0 to 1);
         S : OUT  std_logic_vector(0 to 15);
         Flags : OUT  std_logic_vector(0 to 3)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(0 to 15) := (others => '0');
   signal B : std_logic_vector(0 to 15) := (others => '0');
   signal Ctrl_Alu : std_logic_vector(0 to 1) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(0 to 15);
   signal Flags : std_logic_vector(0 to 3);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN

	uut: UAL PORT MAP (
		A => A,
		B => B,
		Ctrl_Alu => Ctrl_Alu,
		S => S,
		Flags => Flags
	);
 
	A <= x"0002";
	B <= x"000a";
	Ctrl_Alu <= "01", "00" after 100 ns, "10" after 200 ns;
 
END;
