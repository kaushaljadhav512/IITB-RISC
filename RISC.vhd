library std;
library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.ProcessorComponents.all;
entity controlpath is 
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
	
	--Zero flag value out 
	zero_flag : in std_logic;

	--Carry flag value out
	carry_flag : in std_logic;

	--Clock signal in 
	clk : in std_logic;

	--Reset pin 
	rst : in std_logic;

	--Instruction type -----------------------------------------//check
	inst_type: in std_logic_vector(3 downto 0);
	
	--
	inst_op : in std_logic_vector(1 downto 0);
	
	PE0 : in std_logic
);
end entity;

architecture struct of controlpath is
	type FsmState is (S0_reset, S0, S1, S2, S3, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21);
	signal state: FsmState;
begin
	--determining next state
	process(clk, rst, state, zero_flag, carry_flag, inst_type,inst_op)
  		variable statenext: FsmState;
	begin
		statenext := S0_reset;
	case state is
		--PC points to this as soon as the microprocessor gets booted 
		when S0_reset =>  
			--First state of every instruction - Housekeeping task
        	statenext := S0;   
		when S0 =>
			--For ADD instructions and NAND instructions and BEQ instruction
        	if inst_type = "0001" then
			
         		if inst_op = "00" then
						statenext := S1;
					
					elsif inst_op = "10" then
						if carry_flag = '1' then
							statenext := S1;
						else statenext := S0;
						end if;
						
					elsif inst_op = "01" then
						if zero_flag = '1' then
							statenext := S1;
						else statenext := S0;
						end if;
					
					else
						statenext := S5;
					end if;
			
			--For NAND instructions
			elsif inst_type = "0010" then
         		
					if inst_op = "00" then
						statenext := S1;
					end if;
					
					if inst_op = "10" then
						if carry_flag = '1' then
							statenext := S1;
						else statenext := S0;
						end if;
						end if;
						
					if inst_op = "01" then
						if zero_flag = '1' then
							statenext := S1;
						else statenext := S0;
						end if;
						end if;
					
         	--For LM and SM instructions
       	elsif inst_type = "1100" or inst_type = "1101" then
          		statenext := S1;			
					
          	--LW and SW instruction
        	elsif inst_type = "0111" or inst_type = "0101" then
         		statenext := S9;
					
			
         	
				--JAL and JLR instruction
        	elsif inst_type = "1001" or inst_type = "1010" then
        		statenext := S18;
		   	
				--ADI instruction 
		   elsif inst_type = "0000" then 
		   		statenext := S6;
		   	--LHI instruction
		   elsif inst_type = "0011" then
		   		statenext := S8;
				--JRI
			elsif inst_type = "1011" then
		   		statenext := S20;
		   else
		   		statenext := S0;
         end if;
		
		when S1 =>  
			   
				-- for LM
		   	if inst_type = "1100" then 
		   		statenext := S12;
				
				--for SM	
		   	elsif inst_type = "1101" then 
		   		statenext := S14;

		   	else
		   		statenext := S2;
		   	end if;

		when S2 =>
			--LW
			if inst_type = "0111" then 
				statenext := S10;
			--SW
			elsif inst_type = "0101" then 
				statenext := S11;
			
			elsif inst_type = "1000" then 
				if zero_flag ='1' then
					statenext := S16;
				else statenext := S0;
				end if;
			
			else 
				statenext := S3;
			end if;
				
		when S3 => 
			statenext := S0;
		
		when S5 => -- from ADL
			statenext := S2;

		when S6 => 
			--ADI instruction
			statenext := S7;

		when s7 =>
			statenext := S0; --from ADL
		
		when S8 =>
			statenext := S0; --from LHI
		
		when S9 =>
			statenext := S2; --LW

		when S10 =>
			statenext := S0; --LW

		when S11 =>
			statenext := S0;--SW
		
		--for LM
		when S12=>
			if PE0 = '0' then
				statenext := S13;
			else statenext := S0;
			end if;

		when S13 =>
			statenext := S12;

		--for SM
		when S14 =>
			if PE0 = '0' then
				statenext := S15;
			else statenext := S0;
			end if;

		when S15=>
			statenext := S14;
	
		when S16 =>
		statenext := S17;

		when S17=> 
		statenext := S0;

		when S18 =>
			if inst_type = "1001" then
				statenext := S19;
			else 
				statenext := S21;
			end if;

		--LHI instruction
		when S19 =>
			statenext := S17;

		when S20 =>
			statenext := S0;

		when S21 =>
		statenext := S0;
		
		when others =>
			statenext := S0_reset;

	end case;

	if (clk'event and clk = '1') then
    	if (rst = '1') then
        	state <= S0_reset;
      	else
        	state <= statenext;
      	end if;
    end if;
  	end process;
		
------control signal assignments

process (state, clk)
--Instruction Register signals
  	variable nir_enable : std_logic;
  	variable npc_select : std_logic_vector(1 downto 0);
  	variable nalu_op : std_logic_vector(1 downto 0);
  	variable nalu_a_select : std_logic_vector(1 downto 0);
  	variable nalu_b_select : std_logic_vector(2 downto 0);
  	variable nmem_add : std_logic_vector(1 downto 0);
	variable nmem_data : std_logic;
	variable nmem_write : std_logic;
	variable nmem_read : std_logic; 
	variable nrf_write : std_logic;
	variable nrf_read : std_logic;
	variable nrf_a1 : std_logic;
	variable nrf_a2 : std_logic;
	variable nrf_a3 : std_logic_vector(1 downto 0);
	variable nrf_d3 : std_logic_vector(2 downto 0);
	variable nt1 : std_logic_vector(1 downto 0);
	variable nt2 : std_logic_vector(2 downto 0);
	variable ncarry_en : std_logic;
	variable nzero_en : std_logic;
begin

	nir_enable := '0';
  	npc_select := "00";
  	nalu_op := "00";
  	nalu_a_select := "00";
  	nalu_b_select := "000";
  	nmem_add := "00";
	nmem_data := '0';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a2 := '0';
	nrf_a3 := "00";
	nrf_d3 := "000";
	nt1 := "00";
	nt2 := "000";
	ncarry_en := '0';
	nzero_en := '0';

case state is

	when S0_reset =>
		nir_enable := '0';
  		npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := '0';
		nmem_data := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0';

	when S0 =>
		nir_enable := '1';
	  	npc_select := "01";
	  	nalu_op := "11";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
		nmem_read := '1';
	  	nmem_data := '0';
		nmem_add := "00";
		nmem_write := '0';	 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0'; 

	when S1 =>
		nrf_write := '0';
		nrf_a1 := '0';
	----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_data := '0';
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_read := '1';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0'; 

	when S2 =>
		ncarry_en := '1';
		nzero_en := '1';
	  	nalu_op := "10";
	  	nalu_a_select := "01";
	  	nalu_b_select := "001";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nmem_data := '0';
		nmem_add := "00";
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
	
	when S3 =>
		nrf_write := '1';
		nrf_d3 := "011";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select :="11";
	  	nalu_b_select :="111";
	  	nmem_add :="00";
		nmem_write :='0';
		nmem_data := '0';
		nmem_read :='0'; 
		nrf_read := '0';
		nrf_a1 :='0';
		nrf_a2 :='0';
		nrf_a3 :="00";
		nt1 :="00";
		nt2 :="000";
		ncarry_en :='0';
		nzero_en :='0';

		when S5 =>
		nrf_read := '1';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nt2 := "000";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
	  	nmem_add := "00";
		nmem_write := '0';
		nmem_data := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nrf_a2 := '0';
		nt1 := "00";
		ncarry_en := '0';
		nzero_en := '0';	

		when S6 =>
		nrf_read := '1';
		nrf_a1 := '1';
		nrf_a2 := '1';
		nt2 := "100";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
	  	nmem_add := "00";
		nmem_data := '0';
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nrf_a2 := '0';
		nt1 := "00";
		ncarry_en := '0';
		nzero_en := '0';		
		
	when S7 =>
		nrf_a3 := "01";
		nrf_d3 := "011";
		nrf_write := '1';
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
	  	nmem_data := '0';
		nmem_add := "00";
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0';

	when S8 =>
		nrf_write := '1';
		nrf_a3 := "10";
	-------------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "00";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
	  	nmem_data := '0';
		nmem_add := "00";
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_d3 := "010";
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0';		

	when S9 =>
		nrf_write := '0';
		nrf_a3 := "00";
	-------------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
	  	nmem_data := '0';
		nmem_add := "00";
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_read := '1';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_d3 := "000";
		nt1 := "01";
		nt2 := "100";
		ncarry_en := '0';
		nzero_en := '0';	
		
	when S10 =>
		nrf_a3 := "10";
		nrf_d3 := "001";
	  	nmem_add := "10";
		nmem_read := '1'; 
		nrf_write := '0';
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
		nmem_data := '0';
		nmem_write := '0';
		nrf_read := '1';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nt1 := "01";
		nt2 := "100";
		ncarry_en := '0';
		nzero_en := '0';

	when S11 =>
		nrf_a1 := '1';
		nrf_write := '1';
	  	nmem_add := "01";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "00";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
		nmem_write := '0';
		nmem_data := '0';
		nmem_read := '0'; 
		nrf_read := '0';
		nrf_a3 := "01";
		nrf_a2 := '0';
		nrf_d3 := "011";
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0';

--- S12, S13, S14, S15
	when S12 =>
		nrf_a1 := '0';
		nrf_write := '0';
	  	nmem_add := "01";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
		nmem_data := '0';
		nmem_write := '0';
		nmem_read := '1'; 
		nrf_read := '0';
		nrf_a3 := "00";
		nrf_a2 := '0';
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "011";
		ncarry_en := '0';
		nzero_en := '0';

	when S13 =>
		nrf_a1 := '0';
		nrf_write := '1';
	  	nmem_add := "00";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "00";
	  	nalu_a_select := "01";
	  	nalu_b_select := "000";
		nmem_data := '0';
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_read := '0';
		nrf_a3 := "11";
		nrf_a2 := '0';
		nrf_d3 := "100";
		nt1 := "10";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0';

	when S14 =>
		nrf_a1 := '1';
		nrf_write := '0';
	  	nmem_add := "00";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
		nmem_data := '0';
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_read := '1';
		nrf_a3 := "00";
		nrf_a2 := '0';
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "010";
		ncarry_en := '0';
		nzero_en := '0';

	when S15 =>
		nrf_a1 := '0';
		nrf_write := '0';
	  	nmem_add := "01";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nalu_op := "00";
	  	nalu_a_select := "01";
	  	nalu_b_select := "000";
		nmem_data := '1';
		nmem_write := '1';
		nmem_read := '0'; 
		nrf_read := '0';
		nrf_a3 := "00";
		nrf_a2 := '0';
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0';
		
	when S16 =>
	  	npc_select := "01";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "011";
	------------------------------------------------------------------------
		nir_enable := '0';
	  	nmem_add := "00";
		nmem_write := '0';
		nmem_read := '0'; 
		nmem_data := '0';
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
--		nt4 := '0';
--		nt5 := '0';
		ncarry_en := '0';
		nzero_en := '0';
	
	when S17 =>
	  	npc_select := "01";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "010";
	-----------------------------------------------------------------------
		nir_enable := '0';
	  	nmem_add := "00";
		nmem_write := '0';
		nmem_data := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		ncarry_en := '0';
		nzero_en := '0';	
		
	when S18 =>
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
		ncarry_en := '0';
	------------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "11";
	  	nmem_data := '0';
		nmem_add := "00";
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "10";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		nzero_en := '0';

	when S19 =>
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
		ncarry_en := '0';
	------------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "01";
	  	nmem_add := "00";
		nmem_write := '0';
		nmem_data := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		nzero_en := '0';		

	when S20 =>
	  	nalu_op := "00";
	  	nalu_a_select := "10";
	  	nalu_b_select := "100";
		ncarry_en := '0';
	------------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "01";
	  	nmem_add := "00";
		nmem_data := '0';
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		nzero_en := '0';
		
	when S21 =>
	  	nalu_op := "11";
	  	nalu_a_select := "11";
	  	nalu_b_select := "111";
		ncarry_en := '0';
	------------------------------------------------------------------------
		nir_enable := '0';
	  	npc_select := "00";
	  	nmem_add := "00";
		nmem_data := '0';
		nmem_write := '0';
		nmem_read := '0'; 
		nrf_write := '0';
		nrf_read := '0';
		nrf_a1 := '0';
		nrf_a2 := '0';
		nrf_a3 := "00";
		nrf_d3 := "000";
		nt1 := "00";
		nt2 := "000";
		nzero_en := '0';		
		

end case;

if (clk'event and clk = '1') then
	ir_enable <= nir_enable;
  	pc_select <= npc_select;
  	alu_op <= nalu_op;
  	alu_a_select <= nalu_a_select;
  	alu_b_select <= nalu_b_select;
  	mem_add_select <= nmem_add;
	mem_data <= nmem_data;
	mem_write <= nmem_write;
	mem_read <= nmem_read; 
	rf_write <= nrf_write;
	rf_read <= nrf_read;
	rf_a1_select <= nrf_a1;
	rf_a3_select <= nrf_a3;
	rf_d3_select <= nrf_d3;
	t1 <= nt1;
	t2<= nt2;
	carry_en <= ncarry_en;
	zero_en <= nzero_en;
end if;
end process;
end struct;