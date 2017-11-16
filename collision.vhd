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
type collision_states is (idle, calculation, waitOnPulseLowCollision, waitOnPulseLowNoCollision);
signal current_state, next_state: collision_states;


begin

CollisionClkProc: process(clk, reset) is 
	begin
		if (reset = '1') then
			current_state <= idle;
			is_hit <= '0';
		elsif (rising_edge(clk)) then
			current_state <= next_state;
			is_hit <= is_hit_c;
		end if;
	end process;

detection: process(tank_x, tank_y, bullet_x, bullet_y, current_state, pulse) is 
	begin
		is_hit_c <= '0';		
		case (current_state) is
		when (idle) =>

			if (pulse = '0') then
				next_state <= idle;
			else
				next_state <= calculation;
			end if;
		
		when (calculation) =>
			is_hit_c <= '0';
			if (((signed(tank_x) + TANK_WIDTH/2) > signed(bullet_x)) and ((signed(tank_x) - TANK_WIDTH/2) < signed(bullet_x))) then -- hit in x
				if ((signed(tank_y) - TANK_HEIGHT/2) < signed(bullet_y)) then -- hit in y also
					is_hit_c <= '1';
					next_state <= waitOnPulseLowCollision;
				end if;
			else 
				is_hit_c <= '0';
				next_state <= waitONPulseLowNoCollision;
			end if;		

		when (waitOnPulseLowCollision) =>
			if (pulse = '0') then
				next_state <= idle;
				is_hit_c <= '0';
			else
				is_hit_c <= '1';
				next_state <= waitOnPulseLowCollision;
			end if;
		when (waitOnPulseLowNoCollision) =>
			if (pulse = '0') then
				next_state <= idle;
				is_hit_c <= '0';
			else
				is_hit_c <= '0';
				next_state <= waitOnPulseLowNoCollision;
			end if;
		end case; 	
	end process;

end architecture behavioral;