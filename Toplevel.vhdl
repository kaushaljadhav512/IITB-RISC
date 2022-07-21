library std;
library ieee;
use ieee.std_logic_1164.all;

entity TopLevel is
	port (reset, clock : in std_logic) ;
end entity ;

architecture struct of TopLevel is

signal ir_en_sig, mem_data_sel_sig, mem_write_sig, mem_read_sig, rf_write_sig, rf_read_sig, rf_a1_sel_sig, c_en_sig, z_en_sig, z_flag_sig, c_flag_sig, PE0_sig : std_logic;

signal alu_op_sig, alu_a_sel_sig, mem_add_sel_sig, pc_sel_sig, rf_a3_sel_sig, t1_c_sig, inst_op_sig : std_logic_vector(1 downto 0);

signal alu_b_sel_sig, rf_d3_sel_sig, t2_c_sig : std_logic_vector(2 downto 0);

signal inst_type_sig : std_logic_vector(3 downto 0);

component data_path is 
port (

  	--Instruction Register signals
  	ir_enable : in std_logic;

  	-- PC in
  	pc_select : in std_logic_vector(1 downto 0);

  	-- ALU Operation signals
  	alu_op : in std_logic_vector(1 downto 0); --rename alu
  	-- ALU - a
  	alu_a_select : in std_logic_vector(1 downto 0);
  	-- ALU - b
  	alu_b_select : in std_logic_vector(2 downto 0);

  	--Memory address select signals
  	mem_add_select : in std_logic_vector(1 downto 0);
	
	mem_data_select : in std_logic;
	--Memory read and write signals
	mem_write : in std_logic;
	mem_read : in std_logic;

	--Register File read and write control signals 
	rf_write : in std_logic;
	rf_read : in std_logic;
	-- Register file - A1
	rf_a1_select : in std_logic;
	-- Register file - A3	
	rf_a3_select : in std_logic_vector(1 downto 0);
	-- Register file - D3
	rf_d3_select : in std_logic_vector(2 downto 0); -- 2 down to 0

	--Temporary Registers control signals 
	--T1
	t1_c : in std_logic_vector(1 downto 0); -- change no of bits
	--T2
	t2_c : in std_logic_vector(2 downto 0); -- change no of bits

	--Carry and Zero flags enable signals
	carry_en : in std_logic;
	zero_en : in std_logic;

--	--Continue signal (For instructions like ADC, ADZ etc)
--	continue_state : out std_logic; 


	--Zero flag value out 
	zero_flag : out std_logic;

	--Carry flag value out
	carry_flag : out std_logic;

	--Clock signal in 
	clk : in std_logic;

	--Reset pin 
	rst : in std_logic;

	--Instruction type -----------------------------------------//check
	inst_type: out std_logic_vector(3 downto 0);
	
		inst_op: out std_logic_vector(1 downto 0);
			PE0 : out std_logic

	
  );
end component data_path;

component controlpath is 
	port (

	--Instruction Register signals
  	ir_enable : out std_logic;

  	-- PC in
  	pc_select : out std_logic_vector(1 downto 0); --doubtful

  	-- ALU Operation signals
  	alu_op : out std_logic_vector(1 downto 0);
  	-- ALU - a
  	alu_a_select : out std_logic_vector(1 downto 0);
  	-- ALU - b
	alu_b_select : out std_logic_vector(2 downto 0);

  	--Memory address select signals
  	mem_add_select : out std_logic_vector(1 downto 0);
	mem_data : out std_logic;

	--Memory read and write signals
	mem_write : out std_logic;
	mem_read : out std_logic;

	--Register File read and write control signals 
	rf_write : out std_logic;
	rf_read : out std_logic;
	-- Register file - A1
	rf_a1_select : out std_logic;
	
	-- Register file - A3
	rf_a3_select : out std_logic_vector(1 downto 0);
	-- Register file - D3
	rf_d3_select : out std_logic_vector(2 downto 0);

	--Temporary Registers control signals 
	--T1
	t1 : out std_logic_vector(1 downto 0);
	--T2
	t2 : out std_logic_vector(2 downto 0);

	--Carry and Zero flags enable signals
	carry_en : out std_logic;
	zero_en : out std_logic;
	
	zero_flag : in std_logic;

	--Carry flag value out
	carry_flag : in std_logic;

	--Clock signal in 
	clk : in std_logic;

	--Reset pin 
	rst : in std_logic;

	--Instruction type -----------------------------------------//check
	inst_type: in std_logic_vector(3 downto 0);
		inst_op: in std_logic_vector(1 downto 0);
			PE0 : in std_logic
);
end component controlpath;

begin

Datapath : data_path port map(ir_en_sig ,pc_sel_sig,alu_op_sig, alu_a_sel_sig, alu_b_sel_sig,mem_add_sel_sig, mem_data_sel_sig,
mem_write_sig, mem_read_sig,  rf_write_sig, rf_read_sig, rf_a1_sel_sig, rf_a3_sel_sig,rf_d3_sel_sig , t1_c_sig, t2_c_sig, 
c_en_sig, z_en_sig,  z_flag_sig, c_flag_sig, clock,reset, inst_type_sig,inst_op_sig,PE0_sig
) ;

FSM_control: controlpath port map (ir_en_sig ,pc_sel_sig,alu_op_sig, alu_a_sel_sig, alu_b_sel_sig,mem_add_sel_sig, mem_data_sel_sig,
mem_write_sig, mem_read_sig,  rf_write_sig,  rf_read_sig, rf_a1_sel_sig, rf_a3_sel_sig,rf_d3_sel_sig , t1_c_sig, t2_c_sig,
 c_en_sig, z_en_sig, z_flag_sig, c_flag_sig, clock,reset,inst_type_sig,inst_op_sig,PE0_sig
) ;

end struct;