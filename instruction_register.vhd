library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

--All the signals you want from the instruction used for next state logic, branches etc
--Takes in the instruction and gives the necessary information about the instruction 
entity instruction_register is
  port (
	--Doesnt need a clock, just a decoder type of circuit 
	instruction : in std_logic_vector(15 downto 0);
	instruction_operation : out std_logic_vector(1 downto 0);
	instruction_carry : out std_logic;
	instruction_zero : out std_logic;
	instruction_type : out std_logic_vector(3 downto 0)
  ) ;
end entity ; -- instruction_register

--Instruction type and what it corresponds to 
--0000 means it is an ADI
--0001 means it is ADD
--0010 means it is NAND instructions
--0011 means it is LHI
--0101 means it is SW
--0111 means it is LW
--1000 means it is BEQ
--1001 means it is JAL 
--1010 means it is JLR 
--1011 means it is JRI 
--1100 means it is LM
--1101 means it is SM

architecture IR of instruction_register is

	signal OP : std_logic_vector(3 downto 0);
	signal CZ : std_logic_vector(1 downto 0);

begin
	OP <= instruction(15 downto 12);
	CZ <= instruction(1 downto 0);
	process(OP)

	begin 
		if OP = "0001" or OP = "0010" then
		instruction_carry <= CZ(1);
		instruction_zero <= CZ(0);
		instruction_operation <= CZ;
		end if;

	end process;

	process(OP)

	begin 
		instruction_type <= OP;
	end process;
			
end architecture ; -- IR

