library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bullet is 
generic (
	w : std_logic_vector (3 downto 0);
	h : std_logic_vector (3 downto 0);
	rgb_color : std_logic_vector (9 downto 0);
	direction : std_logic;
	tank_x_pos : std_logic_vector (9 downto 0);
	tank_y_pos : std_logic_vector (8 downto 0)
);
port (
	clk : in std_logic;
	reset : in std_logic;
	fire : in std_logic;
	current_x_pos : in std_logic_vector (9 downto 0);
	next_x_pos : out std_logic_vector (9 downto 0);
	current_y_pos : in std_logic_vector (8 downto 0);
	next_y_pos : out std_logic_vector (8 downto 0);
	current_bullet_active : in std_logic;
	next_bullet_active : out std_logic
);
end entity bullet;

architecture behavioral of bullet is

begin

update_position : process (clk,reset) is
	variable y_int : integer;
	begin
	if (rising_edge(clk)) then
		next_bullet_active <= '0';
		next_x_pos <= current_x_pos;
		next_y_pos <= current_y_pos;

		if( fire = '1' and current_bullet_active = '0') then
			next_bullet_active <= '1';
			next_x_pos <= tank_x_pos;
			next_y_pos <= tank_y_pos;

		elsif (current_bullet_active ='1') then
			next_bullet_active <= '1';
			next_x_pos <= current_x_pos;

			if ( direction = '0') then
				y_int := to_integer(signed(current_y_pos)) + 5;
				next_y_pos <= std_logic_vector(to_signed(y_int,9));
			
			elsif (direction = '1') then
				y_int := to_integer(signed(current_y_pos)) - 5;
				next_y_pos <= std_logic_vector(to_signed(y_int,9));
			else
				next_y_pos <= current_y_pos;
			end if;
		end if;
	end if;

	if (reset = '1') then
		next_bullet_active <= '0';	
		next_x_pos <= tank_x_pos;
		next_y_pos <= tank_y_pos;
	end if;

end process;			
		
end architecture behavioral;
	
	
	
	
