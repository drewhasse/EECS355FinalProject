library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tank_pack.all;

entity counter is
  port (
  clk : in std_logic;
  reset : in std_logic;
  hold : in std_logic;
  pulse : out std_logic
  );
end entity;

architecture behavioral of counter is
type state is (increment, hold_s);
signal current_s, next_s : state;
signal count, count_c : std_logic_vector(18 downto 0);
signal pulseint,  pulseint_c : std_logic;
begin
  clocked : process(clk, reset) is
    begin
      if (reset = '1') then
        count <= (others => '0');
        pulseint <= '0';
        current_s <= increment;
      elsif (rising_edge(clk)) then
        count <= count_c;
        pulseint <= pulseint_c;
        current_s <= next_s;
      end if;
  end process clocked;

  combinational : process(count, pulseint) is
    constant one : std_logic_vector(18 downto 0) := (0 => '1', others => '0');
    constant zero : std_logic_vector(18 downto 0) := (others => '0');
    begin
    --Internal state signals
    count_c <= count;
    next_s <= current_s;
    pulseint_c <= pulseint;
    --Output
    pulse <= pulseint;

    case (current_s) is
      when (increment) =>
        if (hold = '1') then
          next_s <= hold_s;
        else
          count_c <= std_logic_vector(unsigned(count) + unsigned(one));
          if (count = zero) then
            pulseint_c <= not(pulseint);
          end if;
        end if;

      when (hold_s) =>
        pulseint_c <= '0';
        if (hold = '0') then
          next_s <= increment;
        end if;

    end case;

  end process combinational;
end architecture;
