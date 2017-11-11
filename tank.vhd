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
        orientation : in std_logic;
        moveDir : in std_logic;
        visible : in std_logic;
        xnew : out std_logic_vector(9 downto 0);
        moveDirNew : out std_logic
  );
end entity;

architecture behavioral of tank is
begin
  updatePos: process(moveDir,x,speed) is
    begin
      xnew <= x;
      if (moveDir = '0') then
        xnew <= std_logic_vector(to_signed(to_integer(signed(x)) + to_integer(signed(speed))*SPEEDFACTOR, 10));
      elsif (moveDir = '1') then
        xnew <= std_logic_vector(to_signed(to_integer(signed(x)) - to_integer(signed(speed))*SPEEDFACTOR, 10));
      end if;
    end process;

    updateDir: process(x,width,moveDir) is
      variable x_int : integer := to_integer(signed(x));
      variable width_int : integer := to_integer(signed(width));
      begin
        if (x_int < 0 + width_int/2 and moveDir = '1') then --x is negative and moving left
          moveDirNew <= '0';
        elsif (x_int > 639 - width_int/2 and moveDir = '0') then
          moveDirNew <= '1';
        else
          moveDirNew <= moveDir;
        end if;
      end process;

end architecture;
