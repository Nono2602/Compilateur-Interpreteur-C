----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:39:34 04/25/2017 
-- Design Name: 
-- Module Name:    CheminDonnees - Behavioral 
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

entity CheminDonnees is
	Port(	clk : IN std_logic;
			rst : IN std_logic);
			--data_i : IN std_logic_vector(15 downto 0);
			--data_we : OUT std_logic;
			--data_a : OUT std_logic_vector(15 downto 0);
			--data_do : OUT std_logic_vector(15 downto 0));
end CheminDonnees;

architecture Behavioral of CheminDonnees is
	component BancReg
    port(A : IN  std_logic_vector(0 to 7);
         B : IN  std_logic_vector(0 to 7);
         WAddr : IN  std_logic_vector(0 to 7);
         W : IN  std_logic;
         Data : IN  std_logic_vector(0 to 15);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(0 to 15);
         QB : OUT  std_logic_vector(0 to 15));
   end component;
	 
	component UAL
	 port(A : in  STD_LOGIC_VECTOR (15 downto 0);
			B : in  STD_LOGIC_VECTOR (15 downto 0);
			Ctrl_Alu : in  STD_LOGIC_VECTOR (3 downto 0);
			S : out  STD_LOGIC_VECTOR (15 downto 0);
			Flags : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component Compteur
	 port(Din : in  STD_LOGIC_VECTOR (15 downto 0);
         Dout : out  STD_LOGIC_VECTOR (15 downto 0);
         CK : in  STD_LOGIC;
         RST : in  STD_LOGIC;
         SENS : in  STD_LOGIC;
         LOAD : in  STD_LOGIC;
			alea : in STD_LOGIC;
         EN : in  STD_LOGIC);
	end component;
	
	component Pipeline1
	 port(InstrIn : in  STD_LOGIC_VECTOR (31 downto 0);
			CLK : in STD_LOGIC;
			alea : in STD_LOGIC;
         OP : out  STD_LOGIC_VECTOR (7 downto 0);
         A : out  STD_LOGIC_VECTOR (15 downto 0);
         B : out  STD_LOGIC_VECTOR (15 downto 0);
         C : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component Pipeline2
	 port(OPin : in  STD_LOGIC_VECTOR (7 downto 0);
         Ain : in  STD_LOGIC_VECTOR (15 downto 0);
         Bin : in  STD_LOGIC_VECTOR (15 downto 0);
         Cin : in  STD_LOGIC_VECTOR (15 downto 0);
			CLK : in STD_LOGIC;
			alea : in STD_LOGIC;
         OPout : out  STD_LOGIC_VECTOR (7 downto 0);
         Aout : out  STD_LOGIC_VECTOR (15 downto 0);
         Bout : out  STD_LOGIC_VECTOR (15 downto 0);
         Cout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component Pipeline3
	 port(OPin : in  STD_LOGIC_VECTOR (7 downto 0);
         Ain : in  STD_LOGIC_VECTOR (15 downto 0);
         Bin : in  STD_LOGIC_VECTOR (15 downto 0);
			CLK : in STD_LOGIC;
         OPout : out  STD_LOGIC_VECTOR (7 downto 0);
         Aout : out  STD_LOGIC_VECTOR (15 downto 0);
         Bout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component Pipeline4
	 port(OPin : in  STD_LOGIC_VECTOR (7 downto 0);
         Ain : in  STD_LOGIC_VECTOR (15 downto 0);
         Bin : in  STD_LOGIC_VECTOR (15 downto 0);
			CLK : in STD_LOGIC;
         OPout : out  STD_LOGIC_VECTOR (7 downto 0);
         Aout : out  STD_LOGIC_VECTOR (15 downto 0);
         Bout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component bram16
	  generic (
		 init_file : String := "none";
		 adr_width : Integer := 11);
	  port (
	  -- System
	  sys_clk : in std_logic;
	  sys_rst : in std_logic;
	  -- Master
	  di : out std_logic_vector(15 downto 0);
	  we : in std_logic;
	  a : in std_logic_vector(15 downto 0);
	  do : in std_logic_vector(15 downto 0));
	end component;
	
	component bram32
	  generic (
		 init_file : String := "out_hexa.hex"; -- none = le fichier en exa à interpréter, 8 caractère exa par ligne
		 adr_width : Integer := 11);
	  port (
	  -- System
	  sys_clk : in std_logic;
	  sys_rst : in std_logic;
	  -- Master
	  di : out std_logic_vector(31 downto 0);
	  we : in std_logic;
	  a : in std_logic_vector(15 downto 0);
	  do : in std_logic_vector(31 downto 0));
	end component;

	-- IP and Instr
	signal ip : std_logic_vector(15 downto 0);
	signal instr : std_logic_vector(31 downto 0);
	signal ip_aligned: std_logic_vector(15 downto 0);
	
	-- Pipeline 1
	signal p1a : std_logic_vector(15 downto 0);
	signal p1op : std_logic_vector(7 downto 0);
   signal p1b : std_logic_vector(15 downto 0);
   signal p1c : std_logic_vector(15 downto 0);
	
	-- Pipeline 2
	signal p2a : std_logic_vector(15 downto 0);
	signal p2op : std_logic_vector(7 downto 0);
   signal p2b : std_logic_vector(15 downto 0);
   signal p2c : std_logic_vector(15 downto 0);
	
	-- Pipeline 3
	signal p3a : std_logic_vector(15 downto 0);
	signal p3op : std_logic_vector(7 downto 0);
   signal p3b : std_logic_vector(15 downto 0);
	
	-- Pipeline 4
	signal p4a : std_logic_vector(15 downto 0);
	signal p4op : std_logic_vector(7 downto 0);
   signal p4b : std_logic_vector(15 downto 0);
	
	-- Banc Reg
	signal brega : std_logic_vector(15 downto 0);
	signal bregb : std_logic_vector(15 downto 0);
	
	-- UAL
	signal uals : std_logic_vector(15 downto 0);
	
	-- LC
	signal lc1 : std_logic_vector(3 downto 0);
	signal lc2 : std_logic;
	signal lc3 : std_logic;
	
	-- MUX
	signal mux1 : std_logic_vector(15 downto 0);
	signal mux2 : std_logic_vector(15 downto 0);
	signal mux3 : std_logic_vector(15 downto 0);
	signal mux4 : std_logic_vector(15 downto 0);
	
	-- Data In
	signal datain : std_logic_vector(15 downto 0);
	
	-- CPT
	signal inCpt : std_logic_vector(15 downto 0);
	signal sensCpt : std_logic;
	signal loadCpt : std_logic;
	signal enCpt : std_logic;
	
	-- Aléas
	signal read_reg_p1 : std_logic;
	signal write_reg_p2 : std_logic;
	signal write_reg_p3 : std_logic;
	signal alea_signal : std_logic;
	
begin
	-- TODO
	sensCpt <= '1';
	enCpt <= '0';
	
	-- pour IP
	ip_aligned <= ip(13 downto 0) & "00"; -- x 4
	
   BancRegistre: BancReg port map (
          A => p1b(7 downto 0),
          B => p1c(7 downto 0),
          WAddr => p4a(7 downto 0),
          W => lc3,
          Data => mux4,
          RST => rst,
          CLK => clk,
          QA => brega,
          QB => bregb);
	
	ALU: UAL port map (
			A => p2b,
			B => p2c,
			Ctrl_Alu => lc1,
			S => uals);
	
	Cpt: Compteur port map (
			Din => inCpt,
         Dout => ip,
         CK => clk,
         RST => rst,
         SENS => sensCpt,
         LOAD => loadCpt,
			alea => alea_signal,
         EN => enCpt);
	
	Pipe1: Pipeline1 port map (
			InstrIn => instr,
			CLK => clk,
			alea => alea_signal,
         OP => p1op,
         A => p1a,
         B => p1b,
         C => p1c);
	
	Pipe2: Pipeline2 port map (
			OPin => p1op,
         Ain => p1a,
         Bin => mux1,
         Cin => bregb,
			CLK => clk,
			alea => alea_signal,
         OPout => p2op,
         Aout => p2a,
         Bout => p2b,
         Cout => p2c);
	
	Pipe3: Pipeline3 port map (
			OPin => p2op,
         Ain => p2a,
         Bin => mux2,
			CLK => clk,
         OPout => p3op,
         Aout => p3a,
         Bout => p3b);
	
	Pipe4: Pipeline4 port map (
			OPin => p3op,
         Ain => p3a,
         Bin => p3b,
			CLK => clk,
         OPout => p4op,
         Aout => p4a,
         Bout => p4b);
			
	RAM: bram16 port map (
			sys_clk => clk,
			sys_rst => rst,
			di => datain,
			we => lc2,
			a => mux3,
			do => p3b);
	
	Instrs: bram32 port map (
	  sys_clk => clk,
	  sys_rst => rst,
	  di => instr,
	  we => '0',
	  a => ip_aligned,
	  do => x"00000000");
	
	-- LC
	lc1 <= "0000" when p2op = x"03" -- ADD
	else "0001" when p2op = x"04" -- SUB
	else "0010" when p2op = x"10" -- NEG
	else "0011" when p2op = x"0b" -- INF
	else "0100" when p2op = x"0c" -- INFE
	else "0101" when p2op = x"0d" -- SUP
	else "0110" when p2op = x"0e" -- SUPE
	else "0111" when p2op = x"0f" -- EQU
	else "1000" when p2op = x"0a" -- AND
	else "1001" when p2op = x"09" -- OR
	else "1111";
	lc2 <= '1' when p3op = x"02" else '0'; -- 1 quand STORE, 0 sinon
	lc3 <= '0' when p4op = x"00" or p4op = x"02" or p4op = x"06" or p4op = x"07" or p4op = x"08" or p4op = x"11" else '1'; -- 0 quand NOP, STORE, JMP, JMPC, JMPI, PRI, 1 sinon
	
	-- MUX
	mux1 <= p1b when p1op = x"05" or p1op = x"01" else brega; -- p1b quand AFC ou LOAD, brega sinon
	mux2 <= uals when p2op = x"03" or p2op = x"04" or p2op = x"10" or p2op = x"0b" or p2op = x"0c" or p2op = x"0d" or p2op = x"0e" or p2op = x"0f" or p2op = x"0a" or p2op = x"09" else p2b; -- uals quand ADD, SUB, NEG, INF, INFE, SUP, SUPE, EQU, AND, OR, p2b sinon
	mux3 <= p3a(14 downto 0) & "0" when p3op = x"02" else p3b(14 downto 0) & "0"; -- p3a quand STORE, p3b sinon -- adr x 2
	mux4 <= datain when p4op = x"01" else p4b; -- datain quand LOAD, p4b sinon

	-- Detection des aléas
	read_reg_p1 <= '1' when p1op /= x"00" and p1op /= x"01" and p1op /= x"05" and p1op /= x"06" else '0'; -- lecture quand il n'y a pas NOP, LOAD, AFC, JMP
	write_reg_p2 <= '1' when p2op /= x"00" and p2op /= x"02" and p2op /= x"06" and p2op /= x"07" and p2op /= x"08" and p2op /= x"11" else '0'; -- ecriture quand il n'y a pas NOP, STORE, JMP, JMPC, JMPI, PRI
	write_reg_p3 <= '1' when p3op /= x"00" and p3op /= x"02" and p3op /= x"06" and p3op /= x"07" and p3op /= x"08" and p3op /= x"11" else '0'; -- ecriture quand il n'y a pas NOP, STORE, JMP, JMPC, JMPI, PRI
	
	alea_signal <= '1' when
		((read_reg_p1 = '1' and write_reg_p2 = '1' and (p2a = p1b or p2a = p1c)) or
		(read_reg_p1 = '1' and write_reg_p3 = '1' and (p3a = p1b or p3a = p1c)))
		else '0';
		
	-- gestion des JMP, JMPC, JMPI
	loadCpt <= '1' when (p1op = x"06" or p1op = x"08" or (p1op = x"07" and brega = x"0000")) and alea_signal = '0' else '0';
	inCpt <= p1a when p1op = x"06" or p1op = x"07" else brega;

end Behavioral;

