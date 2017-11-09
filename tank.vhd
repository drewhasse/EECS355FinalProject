library ieee;
use ieee.std_logic_1164.all;
use numeric_std.all;

entity tank is
  generic (y : std_logic_vector(8 downto 0);
           width : std_logic_vector(6 downto 0);
           height : std_logic_vector(6 downto 0);
           color : std_logic_vector(9 downto 0)
  );
  port (x : in std_logic_vector(9 downto 0);
        speed : in std_logic_vector(1 downto 0);
        direction : in std_logic;
        visible : in std_logic;
        xnew : out std_logic_vector(9 downto 0)
  );
end entity;

architecture behavioral of tank is
begin

end architecture;
