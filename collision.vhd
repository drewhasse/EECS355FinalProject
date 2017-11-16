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
signal is_hit_c: std_logic;
type collision_states is (idle, calculation, collision);
signal state: collision_states;
begin

clocking: process(clk, reset) is 
	begin
		

	end process;

detection: process(tank_x, tank_y, bullet_x, bullet_y) is 
	begin
		is_hit <= '0';
		if (((signed(tank_x) + TANK_WIDTH/2) > signed(bullet_x)) and ((signed(tank_x) - TANK_WIDTH/2) < signed(bullet_x))) then -- hit in x
			if ((signed(tank_y) - TANK_HEIGHT/2) < signed(bullet_y)) then -- hit in y also
				is_hit <= '1';
			end if;
		end if;		
	end process;

end architecture behavioral;