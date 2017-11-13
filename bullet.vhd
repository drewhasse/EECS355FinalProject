library ieee;
use ieee.std_logic_1164.all;
use numeric_std.all;

entity bullet is 
generic (
	w : std_logic_vector (3 downto 0);
	h : std_logic_vector (3 downto 0);
	rgb_color : std_logic_vector (9 downto 0);
);
port (
	fire : in std_logic;
	initial_x_pos : in std_logic_vector (9 downto 0)
	y_pos : out std_logic_vector (8 downto 0)
);
end entity bullet;

architecture behavioral of bullet is

begin

end architecture behavioral;
	
	
