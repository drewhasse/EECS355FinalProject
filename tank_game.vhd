library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.tank_pack.all;

entity tank_game is
  port (
    clk : in std_logic;
    reset : in std_logic;
    spd1, spd2 : out std_logic_vector(1 downto 0);
    fire1, fire2 : out std_logic;
    keyboard_clk, keyboard_data : in std_logic;
    VGA_RED, VGA_GREEN, VGA_BLUE              : out std_logic_vector(7 downto 0);
    HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK : out std_logic
  );
end entity;

architecture structural of tank_game is
  signal pulse : std_logic;
  signal aXout, bXout : std_logic_vector(9 downto 0);
  signal bull_a_x, bull_a_y, bull_b_x, bull_b_y : std_logic_vector(9 downto 0);
  signal speedA, speedB : std_logic_vector(1 downto 0);
  signal bull_a_active, bull_b_active : std_logic;
  signal fireA, fireB : std_logic;
begin
  counter_i : counter
  port map (
    clk   => clk,
    reset => reset,
    hold  => '0',
    pulse => pulse
  );

  keyboardInput : ps2
  port map(keyboard_clk => keyboard_clk,
           keyboard_data => keyboard_data,
           clock_50MHz => clk,
           reset => not (reset),
           speedA => speedA,
           speedB => speedB,
           fireA => fireA,
           fireB => fireB
          );

  tank_A : tank
  generic map (
    width  => std_logic_vector(to_unsigned(TANK_WIDTH, 6))
  )
  port map (
    clk     => clk,
    reset   => reset,
    pulse   => pulse,
    speed   => speedA,
    isLoser => '0',
    xout    => aXout
  );

  tank_B : tank
  generic map (
    width  => std_logic_vector(to_unsigned(TANK_WIDTH, 6))
  )
  port map (
    clk     => clk,
    reset   => reset,
    pulse   => pulse,
    speed   => speedB,
    isLoser => '0',
    xout    => bXout
  );

  bullet_a : bullet
  generic map (
    tank_y_pos       => TANKA_Y(8 downto 0),
    bullet_direction => '1'
  )
  port map (
    clk                   => clk,
    reset                 => reset,
    pulse                 => pulse,
    fire                  => fireA,
    tank_x_pos            => std_logic_vector((unsigned(aXout) + to_unsigned(TANK_WIDTH/2,10))),
    collision             => '0',
    next_bullet_active    => bull_a_active,
    next_y_pos            => bull_a_y(8 downto 0),
    next_x_pos            => bull_a_x
  );

  bullet_b : bullet
  generic map (
    tank_y_pos       => std_logic_vector((unsigned(TANKB_Y(8 downto 0)) + to_unsigned(TANK_HEIGHT,9) - to_unsigned(BULLET_HEIGHT,9))),
    bullet_direction => '0'
  )
  port map (
    clk                   => clk,
    reset                 => reset,
    pulse                 => pulse,
    fire                  => fireB,
    tank_x_pos            => std_logic_vector((unsigned(bXout) + to_unsigned(TANK_WIDTH/2,10))),
    collision             => '0',
    next_bullet_active    => bull_b_active,
    next_y_pos            => bull_b_y(8 downto 0),
    next_x_pos            => bull_b_x
  );

  graphics : GraphicsOut
  	port map(
  			aXout, TANKA_Y, --Tank A
        bXout, TANKB_Y, --Tank B
        bull_a_x, bull_a_y, --Bullet A
        bull_b_x, bull_b_y, --Bullet B
  		  clk,
  			reset,
  			VGA_RED, VGA_GREEN, VGA_BLUE,
  			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK
  	);

    spd1 <= speedA;
    spd2 <= speedB;
    fire1 <= fireA;
    fire2 <= fireB;
end architecture;
