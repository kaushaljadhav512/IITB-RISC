library std;
library ieee;
use ieee.std_logic_1164.all;

package components_init is
  
  component shifter_1 is
  port (
	 data_in : in std_logic_vector(15 downto 0);
	 data_out : out std_logic_vector(15 downto 0)
  );
  end component shifter_1;
  
  component PriorityEncoder is
  port (
    PriorityEncoderReg : IN STD_LOGIC_VECTOR(7 downto 0);
	 PE_out : OUT STD_LOGIC_VECTOR(2 downto 0);
    PE0 : OUT STD_LOGIC);
  end component PriorityEncoder;
	
  component ALU is 
  port (
    alu_a : in std_logic_vector(15 downto 0);
    alu_b : in std_logic_vector(15 downto 0);
    alu_op : in std_logic_vector(1 downto 0);
    alu_out : out std_logic_vector(15 downto 0);
	 carry : out std_logic;
	 zero : out std_logic
  );
  end component ALU;

  component decoder is 
  port (
    decoder_input : in std_logic_vector(2 downto 0);
    decoder_output : out std_logic_vector(15 downto 0)
  );
  end component decoder;

  component data_extension is 
  port (
    data_in : in std_logic_vector(8 downto 0);
    data_out : out std_logic_vector(15 downto 0)
  );
  end component data_extension;

  component inst_register_data is 
  port (
    inst_in : in std_logic_vector(15 downto 0);
    inst_out : out std_logic_vector(15 downto 0);
    inst_enable : in STD_LOGIC;
    clk : in STD_LOGIC
  );
  end component inst_register_data;

  component instruction_register is
  port (
    instruction : in std_logic_vector(15 downto 0);
    instruction_operation : out std_logic_vector(1 downto 0);
    instruction_carry : out std_logic;
    instruction_zero : out std_logic;
    instruction_type : out std_logic_vector(3 downto 0)
  );
  end component instruction_register;

  component memory is
  port (
    clk : in std_logic;
    memory_read : in std_logic;
    memory_write : in std_logic;
    address_in : in std_logic_vector(15 downto 0);
    data_in : in std_logic_vector(15 downto 0);
    initialize : in std_logic;
    data_out : out std_logic_vector(15 downto 0)
  );
  end component memory; 

  component reg_file is 
  port (
    clk : in STD_LOGIC;
    reg_file_read : in STD_LOGIC; 
    reg_file_write : in STD_LOGIC;
    PC_write_rf : in std_logic_vector(1 downto 0);
    address_1 : in std_logic_vector(2 downto 0);
    address_2 : in std_logic_vector(2 downto 0);
    address_3 : in std_logic_vector(2 downto 0);
    data_in : in std_logic_vector(15 downto 0);
    data_out_1 : out std_logic_vector(15 downto 0);
    data_out_2 : out std_logic_vector(15 downto 0);
	 PC_in : in std_logic_vector(15 downto 0)
  );
  end component reg_file;

  component sign_extender_6 is 
  port (
    data_in : in std_logic_vector(5 downto 0);
    data_out : out std_logic_vector(15 downto 0)
  );
  end component sign_extender_6;

  component sign_extender_9 is 
  port (
    data_in : in std_logic_vector(8 downto 0);
    data_out : out std_logic_vector(15 downto 0)
  );
  end component sign_extender_9;

  component register_data is 
  port (
    data_in : in std_logic_vector(15 downto 0);
    data_out : out std_logic_vector(15 downto 0);
    clk : in STD_LOGIC
  );
  end component register_data;

  component data_path is 
  port (
    ir_enable : in STD_LOGIC;
    pc_select : in std_logic_vector(1 downto 0);
    alu_op : in std_logic_vector(1 downto 0);
    alu_a_select : in std_logic_vector(1 downto 0);
    alu_b_select : in std_logic_vector(2 downto 0);
    mem_add_select : in std_logic_vector(1 downto 0);
    mem_write : in std_logic;
    mem_read : in std_logic;
    rf_write : in std_logic;
    rf_read : in std_logic;
    rf_a1_select : in STD_LOGIC;
    rf_a3_select : in std_logic_vector(1 downto 0);
    rf_d3_select : in std_logic_vector(1 downto 0);
    t1 : in std_logic;
    t2 : in std_logic;
--    t4 : in std_logic;
--    t5 : in std_logic;
    carry_en : in std_logic;
    zero_en : in std_logic;
    continue_state : out std_logic;
    loop_out : out std_logic;
    zero_out : out std_logic;
    carry_out : out std_logic;
    clk : in std_logic;
    rst : in std_logic;
    inst_type: out std_logic_vector(3 downto 0)


  );
  end component data_path;

  component controlpath is 
  port (
    ir_enable : out std_logic;
    pc_select : out std_logic_vector(1 downto 0);
    alu_op : out std_logic_vector(1 downto 0);
    alu_a_select : out std_logic_vector(1 downto 0);
    alu_b_select : out std_logic_vector(2 downto 0);
    mem_add_select : out std_logic_vector(1 downto 0);
    mem_data : out std_logic;
	 mem_write : out std_logic;
    mem_read : out std_logic;
    rf_write : out std_logic;
    rf_read : out std_logic;
    rf_a1_select : out std_logic;
    rf_a3_select : out std_logic_vector(1 downto 0);
    rf_d3_select : out std_logic_vector(2 downto 0);
    t1 : out std_logic_vector(1 downto 0);
    t2 : out std_logic_vector(2 downto 0);
--    t4 : out std_logic_1164std_logic_1164;
--    t5 : out std_logic_1164std_logic_1164;
    carry_en : out std_logic;
    zero_en : out std_logic;
    continue_state : in std_logic;
    loop_out : in std_logic;
    zero_out : in std_logic;
    carry_out : in std_logic;
    clk : in std_logic;
    rst : in std_logic;
    inst_type: in std_logic_vector(3 downto 0)
  );
  end component controlpath;

end package components_init;