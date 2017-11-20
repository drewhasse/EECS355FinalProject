library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tank_pack.all;

entity score is
  port (
  clk : in std_logic;
  reset : in std_logic;
  collision : in std_logic;
  pulse : in std_logic;
  score : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavioral of score is
type state is (idle, waitforlow);
signal current_s, next_s : state;
signal count, count_c : std_logic_vector(3 downto 0);
begin
  clocked : process(clk, reset) is
    begin
      if (reset = '1') then
        count <= (others => '0');
        current_s <= idle;
      elsif (rising_edge(clk)) then
        count <= count_c;
        current_s <= next_s;
      end if;
  end process clocked;

  combinational : process(count, pulse, collision, current_s) is
    constant one : std_logic_vector(3 downto 0) := (0 => '1', others => '0');
    constant zero : std_logic_vector(3 downto 0) := (others => '0');
    begin
    --Internal state signals
    count_c <= count;
    next_s <= current_s;
    --Output
    score <= count;

    case (current_s) is
      when (idle) =>
        if (pulse = '1' and collision = '1') then
          count_c <= std_logic_vector(unsigned(count) + unsigned(one));
          next_s <= waitforlow;
        end if;
      when (waitforlow) =>
        if (pulse = '0' and collision = '0') then
          next_s <= idle;
        end if;
    end case;

  end process combinational;
end architecture;
