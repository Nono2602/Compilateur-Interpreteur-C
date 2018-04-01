--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:40:08 05/09/2017
-- Design Name:   
-- Module Name:   /home/artigouh/Documents/Syst info/archi/Archi/Test_CheminDonnees.vhd
-- Project Name:  Archi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CheminDonnees
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
 
ENTITY Test_CheminDonnees IS
END Test_CheminDonnees;
 
ARCHITECTURE behavior OF Test_CheminDonnees IS 

    COMPONENT CheminDonnees
    PORT(
			clk : IN std_logic;
			rst : IN std_logic);
			--data_i : IN std_logic_vector(15 downto 0);
			--data_we : OUT std_logic;
			--data_a : OUT std_logic_vector(15 downto 0);
			--data_do : OUT std_logic_vector(15 downto 0));
    END COMPONENT;
    
   -- Signaux
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	
	--signal data_i : std_logic_vector(0 to 15) := (others => '0');
	--signal data_we : std_logic := '0';
	--signal data_a : std_logic_vector(0 to 15) := (others => '0');
	--signal data_do : std_logic_vector(0 to 15) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   chemin: CheminDonnees PORT MAP (
			 clk => clk,
			 rst => rst);
			 --data_i => data_i,
			 --data_we => data_we,
			 --data_a => data_a,
			 --data_do => data_do);

   -- TEST
	clk <= not clk after 2 ns;
	rst <= '0', '1' after 20 ns;

END;
