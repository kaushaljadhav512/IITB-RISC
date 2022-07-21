library ieee;
use ieee.std_logic_1164.all;

entity PEEnable is
	port (current_state : IN STD_LOGIC_VECTOR(4 downto 0);
        PE_enable : OUT STD_LOGIC
        );
end PEEnable;


architecture desc of PEEnable is

		begin
			process (current_state)
			begin
			PE_enable <= '1';

			end process;
end desc;
