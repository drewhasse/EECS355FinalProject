library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bullet is 
generic (
	w : std_logic_vector (3 downto 0);
	h : std_logic_vector (3 downto 0);
	rgb_color : std_logic_vector (9 downto 0);
	tank_w : std_logic_vector (5 downto 0);
	tank_h : std_logic_vector (5 downto 0);
	bullet_direction : std_logic
);
port (
	clk : in std_logic;
	reset : in std_logic;
	pulse : in std_logic;
	fire : in std_logic;
	current_x_pos : in std_logic_vector (9 downto 0);
	current_y_pos : in std_logic_vector (8 downto 0);
	current_bullet_active : in std_logic;
	tank_x_pos : in std_logic_vector (9 downto 0);
	tank_y_pos : in std_logic_vector (8 downto 0);
	collision : in std_logic;
	next_bullet_active : out std_logic;
	next_y_pos : out std_logic_vector (8 downto 0);
	next_x_pos : out std_logic_vector (9 downto 0)
);
end entity bullet;

architecture behavioral of bullet is
TYPE state is (idle,fire_state,update,waitOnPulseLow,bullet_check,output);
signal current,next_state : state;
signal next_active : std_logic;
signal next_y : std_logic_vector (8 downto 0);
signal next_x : std_logic_vector (9 downto 0);
signal current_y : std_logic_vector (8 downto 0);
signal current_x : std_logic_vector (9 downto 0);
signal current_active : std_logic;



begin


update_position_clk : process (clk,reset) is

begin

	if (reset = '1') then
		current <= idle;
	elsif (rising_edge(clk)) then
		current <= next_state;
		current_y <= next_y;
		current_x <= next_x;
		current_active <= next_active;
		next_y_pos <= next_y;
		next_x_pos <= next_x;
		next_bullet_active <= next_active;
	end if;
end process;

update_position_comb : process (pulse,fire,current_bullet_active)
variable y_int : integer;
variable width_int : integer;
variable height_int : integer;

begin

next_y <= current_y;
next_x <= current_x;
next_active <= current_active;

case (current) is 
	when idle =>

	if(pulse = '0') then
		next_state <= idle;
	else
		if(fire = '0' and current_bullet_active = '0') then
			next_y <= "111111111";
			next_x <= "1111111111";
			next_active <= '0';
			next_state <= idle;
		elsif(fire = '1' and current_bullet_active = '0') then
			next_active <= '1';
			next_x <= tank_x_pos;
			next_y <= tank_y_pos;
			next_state <= update;
		else
			next_state <= update;
		end if;
		
	end if;
		
	when update =>
	
	if (bullet_direction = '0') then
		y_int := to_integer(signed(current_y)) + 5;
		next_y <= std_logic_vector(to_signed(y_int,9));
	elsif (bullet_direction = '1') then
		y_int := to_integer(signed(current_y)) - 5;
		next_y <= std_logic_vector(to_signed(y_int,9));
	else
		next_y <= current_y;
	end if;
	next_state <= bullet_check;

	when bullet_check =>

	if(bullet_direction = '0') then
		if(current_y >= "111100000" or collision = '1') then
			next_active <= '0';
		else
			next_active <= '1';
		end if;
	elsif(bullet_direction = '1') then
		if(current_y <= "000000000" or collision = '1') then
			next_active <= '0';
		else
			next_active <= '1';
		end if;
	end if;
	next_state <= waitOnPulseLow;
		

	when waitOnPulseLow =>
		if (pulse = '0') then
			next_state <= idle;
		else
			next_state <= waitOnPulseLow;
		end if;

	when others =>
		
		next_y <= "111111111";
		next_x <= "1111111111";
		next_state <= idle;
	
	end case;

end process;
		
						
		
end architecture behavioral;
	
	
	
	
	
	
	
