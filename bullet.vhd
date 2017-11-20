library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bullet is
generic (
	tank_y_pos : std_logic_vector (9 downto 0);
	bullet_direction : std_logic
);
port (
	clk : in std_logic;
	reset : in std_logic;
	pulse : in std_logic;
	fire : in std_logic;
	tank_x_pos : in std_logic_vector (9 downto 0);
	collision : in std_logic;
	next_bullet_active : out std_logic;
	next_y_pos : out std_logic_vector (9 downto 0);
	next_x_pos : out std_logic_vector (9 downto 0)
);
end entity bullet;

architecture behavioral of bullet is
	TYPE state is (idle,waitOnPulseLow);
	signal current,next_state : state;
	signal next_active : std_logic;
	signal next_y : std_logic_vector (9 downto 0);
	signal next_x : std_logic_vector (9 downto 0);
	signal current_y : std_logic_vector (9 downto 0);
	signal current_x : std_logic_vector (9 downto 0);
	signal current_active : std_logic;
begin

update_position_clk : process (clk,reset) is
begin
	if (reset = '1') then
		current <= idle;
		current_y <= (others => '1');
		current_x <= (others => '1');
		current_active <= '0';
	elsif (rising_edge(clk)) then
		current <= next_state;
		current_y <= next_y;
		current_x <= next_x;
		current_active <= next_active;
	end if;
end process;

update_position_comb : process (pulse,fire,current_active)
	variable y_int : integer;
	variable width_int : integer;
	variable height_int : integer;
begin

next_y <= current_y;
next_x <= current_x;
next_state <= current;
next_active <= current_active;

next_y_pos <= current_y;
next_x_pos <= current_x;
next_bullet_active <= current_active;

case (current) is
	when idle =>
	if (pulse = '1') then
		if(fire = '0' and current_active = '0') then
			next_active <= '0';
			next_y <= "1111111111";
			next_x <= "1111111111";
		elsif(fire = '1' and current_active = '0') then
			next_active <= '1';
			next_x <= tank_x_pos;
			next_y <= tank_y_pos;
		elsif(current_active = '1') then
			if (collision = '1') then
				next_active <= '0';
				next_y <= "1111111111";
				next_x <= "1111111111";
			else
				if (bullet_direction = '0') then
					if(signed(current_y) >= to_signed(480,10)) then
						next_active <= '0';
						next_y <= "1111111111";
						next_x <= "1111111111";
					else
						y_int := to_integer(signed(current_y)) + 8;
						next_y <= std_logic_vector(to_signed(y_int,10));
					end if;
				elsif (bullet_direction = '1') then
					if(signed(current_y) <= to_signed(0,10)) then
						next_active <= '0';
						next_y <= "1111111111";
						next_x <= "1111111111";
					else
						y_int := to_integer(signed(current_y)) - 8;
						next_y <= std_logic_vector(to_signed(y_int,10));
					end if;
				end if;
			end if;
		end if;
		next_state <= waitOnPulseLow;
	end if;

	when waitOnPulseLow =>
		if (pulse = '0') then
			next_state <= idle;
		end if;
	end case;
	end process;
	end architecture behavioral;

	-- when update =>
  --
	-- if (bullet_direction = '0') then
	-- 	y_int := to_integer(signed(current_y)) + 5;
	-- 	next_y <= std_logic_vector(to_signed(y_int,9));
	-- elsif (bullet_direction = '1') then
	-- 	y_int := to_integer(signed(current_y)) - 5;
	-- 	next_y <= std_logic_vector(to_signed(y_int,9));
	-- else
	-- 	next_y <= current_y;
	-- end if;
	-- next_state <= bullet_check;
  --
	-- when bullet_check =>
  --
	-- if(bullet_direction = '0') then
	-- 	if(current_y >= "111100000" or collision = '1') then
	-- 		next_active <= '0';
	-- 	else
	-- 		next_active <= '1';
	-- 	end if;
	-- elsif(bullet_direction = '1') then
	-- 	if(current_y <= "000000000" or collision = '1') then
	-- 		next_active <= '0';
	-- 	else
	-- 		next_active <= '1';
	-- 	end if;
	-- end if;
	-- next_state <= waitOnPulseLow;
