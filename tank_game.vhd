library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.tank_pack.all;

entity tank_game is
  port (
    clk : in std_logic;
    reset : in std_logic;
    VGA_RED, VGA_GREEN, VGA_BLUE              : out std_logic_vector(7 downto 0);
    HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK : out std_logic
  );
end entity;

architecture structural of tank_game is
  signal pulse : std_logic;
  signal xout : std_logic_vector(9 downto 0);
begin
  counter_i : counter
  port map (
    clk   => clk,
    reset => reset,
    hold  => '0',
    pulse => pulse
  );

  tank_i : tank
  generic map (
    width  => std_logic_vector(to_unsigned(TANK_WIDTH, 6))
  )
  port map (
    clk     => clk,
    reset   => reset,
    pulse   => pulse,
    speed   => "01",
    isLoser => '0',
    xout    => xout
  );

  graphics : GraphicsOut
  	port map(
  			xout, TANKA_Y, "0000000000", TANKB_Y, xout, TANKA_Y, "0000000000", TANKB_Y,
  		  clk,
  			reset,
  			VGA_RED, VGA_GREEN, VGA_BLUE,
  			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK
  	);



end architecture;
