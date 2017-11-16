library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tank_pack.all;

entity tank_tb is
end entity;

architecture behavioral of tank_tb is
  component tank
    generic (
      y      : std_logic_vector(8 downto 0);
      width  : std_logic_vector(5 downto 0);
      height : std_logic_vector(5 downto 0);
      color  : std_logic_vector(9 downto 0)
    );
    port (
      clk        : in std_logic;
      reset      : in std_logic;
      pulse      : in std_logic;
      speed      : in  std_logic_vector(1 downto 0);
      isLoser    : in  std_logic;
      xout       : out std_logic_vector(9 downto 0)
    );
end component tank;
  signal hold : std_logic := '0';
  signal clk_tb : std_logic;
  signal reset_tb : std_logic;
  signal pulse_tb : std_logic;
  signal speed_tb      : std_logic_vector(1 downto 0);
  signal isLoser_tb    : std_logic;
  signal xout_tb       : std_logic_vector(9 downto 0);

  begin
    dut : tank
      generic map (
        y      => "000000000",
        width  => std_logic_vector(to_signed(TANK_WIDTH, 6)),
        height => std_logic_vector(to_signed(TANK_HEIGHT, 6)),
        color  => "0000000000"
      )

      port map (
        clk        => clk_tb,
        reset      => reset_tb,
        pulse      => pulse_tb,
        speed      => speed_tb,
        isLoser    => isLoser_tb,
        xout       => xout_tb
      );

    clock_generate: process is
      begin
        clk_tb <= '0';
        wait for 1 ns;
        clk_tb <= not clk_tb;
        wait for 1 ns;
        if hold = '1' then
          wait;
        end if;
      end process clock_generate;

      stim_pulse : process is
      begin
        pulse_tb <= '0';
        wait for 20 ns;
        pulse_tb <= not pulse_tb;
        wait for 20 ns;
        if hold = '1' then
          wait;
        end if;
      end process;

      stim_speed : process is
      begin
        speed_tb <= "01"; wait for 8 ns;
        wait;
      end process;

      stim_reset : process is
      begin
        reset_tb <= '1'; wait for 1 ns;
        reset_tb <= '0'; wait for 100 ns;
        reset_tb <= '1'; wait for 1 ns;
        reset_tb <= '0';
        wait;
      end process;

      stim_isLower : process is
      begin
        isLoser_tb <= '0';
        --wait for 250 ns; isLoser_tb <= '1';
        wait;
      end process;

      stop_clk : process is
      begin
        wait for 6 ms;
        hold <= '1';
        wait;
      end process;


end architecture;
