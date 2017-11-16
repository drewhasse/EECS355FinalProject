library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tank_pack.all;

entity counter_tb is
end entity;
architecture behavioral of counter_tb is

  signal clk_tb   : std_logic;
  signal reset_tb : std_logic;
  signal hold_tb  : std_logic := '0';
  signal pulse_tb : std_logic;

  component counter
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    hold  : in  std_logic;
    pulse : out std_logic
  );
  end component counter;

  begin
    counter_i : counter
    port map (
      clk   => clk_tb,
      reset => reset_tb,
      hold  => hold_tb,
      pulse => pulse_tb
    );

    clock_generate: process is
      begin
        clk_tb <= '0';
        wait for 20 ns;
        clk_tb <= not clk_tb;
        wait for 20 ns;
      end process clock_generate;

    reset_gen: process is
      begin
        reset_tb <= '1';
        wait for 80 ns;
        reset_tb <= '0';
        wait;
      end process reset_gen;


end architecture;
