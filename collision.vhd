library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tank_pack.all;

entity collision is
port (
	tank_x : in std_logic_vector(9 downto 0);
	tank_y : in std_logic_vector (8 downto 0);
	bullet_x : in std_logic_vector(9 downto 0);
	bullet_y : in std_logic_vector(8 downto 0);
	clk : in std_logic;
	reset : in std_logic;
	pulse : in std_logic;
	is_hit : out std_logic
);
end entity;

architecture behavioral of collision is
signal is_hit_c, is_hit_next: std_logic;
type collision_states is (idle, waitOnPulseLow);
signal current_state, next_state: collision_states;


begin

CollisionClkProc: process(clk, reset) is
	begin
		if (reset = '1') then
			current_state <= idle;
			is_hit_next <= '0';
		elsif (rising_edge(clk)) then
			current_state <= next_state;
			is_hit_next <= is_hit_c;
		end if;
	end process;

detection: process(tank_x, tank_y, bullet_x, bullet_y, current_state, pulse) is
	begin
		is_hit_c <= is_hit_next;
		is_hit <= is_hit_next;
		next_state <= current_state;
		case (current_state) is
		when (idle) =>
			if (pulse = '1') then
				if (((signed(tank_x) + TANK_WIDTH) >= signed(bullet_x)) and ((signed(tank_x)) <= signed(bullet_x))) then -- hit in x
					if (((signed(tank_y) + TANK_HEIGHT) >= signed(bullet_y)) and ((signed(tank_y)) <= signed(bullet_y))) then -- hit in y also
						is_hit_c <= '1';
						next_state <= waitOnPulseLow;
					else
						is_hit_c <= '0';
					end if;
				else
					is_hit_c <= '0';
				end if;
			end if;

		when (waitOnPulseLow) =>
			if (pulse = '0') then
				next_state <= idle;
			end if;
		end case;
	end process;

end architecture behavioral;
