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
      x          : in  std_logic_vector(9 downto 0);
      speed      : in  std_logic_vector(1 downto 0);
      moveDir    : in  std_logic;
      visible    : in  std_logic;
      xnew       : out std_logic_vector(9 downto 0);
      moveDirNew : out std_logic
    );
end component tank;
  signal x_tb          : std_logic_vector(9 downto 0);
  signal speed_tb      : std_logic_vector(1 downto 0);
  signal moveDir_tb    : std_logic;
  signal visible_tb    : std_logic;
  signal xnew_tb       : std_logic_vector(9 downto 0);
  signal moveDirNew_tb : std_logic;

  begin
    dut : tank
      generic map (
        y      => "000000000",
        width  => std_logic_vector(to_signed(TANK_WIDTH, 6)),
        height => std_logic_vector(to_signed(TANK_HEIGHT, 6)),
        color  => "0000000000"
      )
      port map (
        x          => x_tb,
        speed      => speed_tb,
        moveDir    => moveDir_tb,
        visible    => visible_tb,
        xnew       => xnew_tb,
        moveDirNew => moveDirNew_tb
      );

    stim_speed : process is
    begin
      speed_tb <= "01"; wait for 5 ns;
      wait;
    end process;

    stim_x : process is
    begin
      x_tb <= "0000000001"; wait for 5 ns;
      x_tb <= std_logic_vector(to_unsigned(640, 10)); wait for 5 ns;
      wait;
    end process;

    stim_moveDir : process is
    begin
      moveDir_tb <= '0';
      visible_tb <= '0';
      wait;
    end process;


end architecture;
