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
				if (((unsigned(tank_x) + TANK_WIDTH) >= unsigned(bullet_x)) and ((unsigned(tank_x)) <= unsigned(bullet_x) + BULLET_WIDTH)) then -- hit in x
					if (((unsigned(tank_y) + TANK_HEIGHT) >= unsigned(bullet_y)) and ((unsigned(tank_y)) <= unsigned(bullet_y) + BULLET_HEIGHT)) then -- hit in y also
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
				is_hit_c <= '0';
			end if;
		end case;
	end process;

end architecture behavioral;
