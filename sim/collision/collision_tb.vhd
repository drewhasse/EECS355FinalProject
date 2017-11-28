library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_pack.all;

--Additional standard or custom libraries go here

entity collision_tb is 

end entity collision_tb;

architecture behavioral of collision_tb is	

component collision is
port(
	tank_x : in std_logic_vector(9 downto 0);
	tank_y : in std_logic_vector (8 downto 0);
	bullet_x : in std_logic_vector(9 downto 0);
	bullet_y : in std_logic_vector(8 downto 0);
	clk : in std_logic;
	reset : in std_logic;
	pulse : in std_logic;
	is_hit : out std_logic 
);
end component collision;


	signal tank_x_tb : std_logic_vector(9 downto 0);
	signal tank_y_tb : std_logic_vector (8 downto 0);
	signal bullet_x_tb :  std_logic_vector(9 downto 0);
	signal bullet_y_tb : std_logic_vector(8 downto 0);
	signal is_hit_tb : std_logic;
	signal clk_tb: std_logic;
	signal reset_tb : std_logic := '0';
	signal pulse_tb : std_logic := '0';



begin

uat: collision
	port map(
		tank_x => tank_x_tb,
		tank_y => tank_y_tb,
		bullet_x => bullet_x_tb,
		bullet_y => bullet_y_tb,	
		clk => clk_tb,
		reset => reset_tb,
		pulse => pulse_tb,
		is_hit => is_hit_tb			
		);

process
begin
	clk_tb <= '1';
	wait for 0.01 ns;
	clk_tb <= '0';
	wait for 0.01 ns;
end process;				
					
process is
begin
	tank_x_tb <= std_logic_vector(to_signed(300, tank_x_tb'length));
	tank_y_tb <= std_logic_vector(to_signed(25, tank_y_tb'length));
	bullet_x_tb <= std_logic_vector(to_signed(302, bullet_x_tb'length));
	bullet_y_tb <= std_logic_vector(to_signed(25, bullet_y_tb'length));
	pulse_tb <= '1';
	wait for 0.5 ns;

	pulse_tb <= '0';
	wait for 0.5 ns;
	
	bullet_x_tb <= std_logic_vector(to_signed(10, bullet_x_tb'length));
	wait for 0.5 ns;
	pulse_tb <= '1';

	wait;
end process;
	

--component declaration and stimuli processes go here

end architecture behavioral;