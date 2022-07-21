library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.components_init.all;

entity ALU is
  port (
	
	alu_a : in std_logic_vector(15 downto 0);
	alu_b : in std_logic_vector(15 downto 0);

	--Carries the operation ALU has to perform
	--00 - add
	--11 - XOR
	--10 - nand
	alu_op : in std_logic_vector(1 downto 0);
	alu_out : out std_logic_vector(15 downto 0);
	carry : out std_logic;
	zero : out std_logic
  ) ;
end entity ; -- ALU

architecture alu_arch of ALU is

	
	signal alu_out_sig : std_logic_vector(16 downto 0);
	signal carry_sig: std_logic;

	

begin

	
	process(alu_a, alu_b, alu_op)
	
	variable var_alu_a : std_logic_vector(16 downto 0);
	variable var_alu_b : std_logic_vector(16 downto 0);
	
	begin 
	var_alu_a(15 downto 0) := alu_a;
	var_alu_b(15 downto 0) := alu_b;
	var_alu_a(16) := '0';
	var_alu_b(16) := '0';
	
		if alu_op = "10" then 
			alu_out_sig(15 downto 0) <= alu_a nand alu_b;
			alu_out_sig(16)<= '0';
			
		end if;
		
		if alu_op = "01" then 
			alu_out_sig <= std_logic_vector(unsigned(var_alu_a) + unsigned(var_alu_b));
		end if;
		
		if alu_op = "11" then 
			alu_out_sig(15 downto 0) <= alu_a xor alu_b;
			alu_out_sig(16)<= '0';
		end if;
		
	end process;

	alu_out <= alu_out_sig(15 downto 0);
	zero <= '1' when alu_out_sig = "00000000000000000" else '0';

	carry_sig <= alu_out_sig(16);
	
carry <=carry_sig;

end architecture ; -- alu