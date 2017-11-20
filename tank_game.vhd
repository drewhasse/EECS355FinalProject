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
    collA, collB, bull_a_active, bull_b_active : out std_logic;
    HexA, HexB, HexLabelA, HexLabelB : out std_logic_vector(6 downto 0);
    keyboard_clk, keyboard_data : in std_logic;
    VGA_RED, VGA_GREEN, VGA_BLUE              : out std_logic_vector(7 downto 0);
    HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK : out std_logic;
    LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
    LCD_RW						: BUFFER STD_LOGIC;
    DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
end entity;

architecture structural of tank_game is
  signal pulse : std_logic;
  signal aXout, bXout : std_logic_vector(9 downto 0);
  signal is_hit_a, is_hit_b : std_logic;
  signal bull_a_x, bull_a_y, bull_b_x, bull_b_y : std_logic_vector(9 downto 0);
  signal speedA, speedB : std_logic_vector(1 downto 0);
  signal fireA, fireB : std_logic;
  signal win_sig : std_logic_vector(1 downto 0);
  signal scoreA, scoreB : std_logic_vector(3 downto 0);
  signal hold : std_logic;
begin
  counter_i : counter
  port map (
    clk   => clk,
    reset => reset,
    hold  => hold,
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
    isLoser => win_sig(1),
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
    isLoser => win_sig(0),
    xout    => bXout
  );

  bullet_a : bullet
  generic map (
    tank_y_pos       => TANKA_Y,
    bullet_direction => '1'
  )
  port map (
    clk                   => clk,
    reset                 => reset,
    pulse                 => pulse,
    fire                  => fireA,
    tank_x_pos            => std_logic_vector((unsigned(aXout) + to_unsigned(TANK_WIDTH/2,10))),
    collision             => is_hit_b,
    next_bullet_active    => bull_a_active,
    next_y_pos            => bull_a_y,
    next_x_pos            => bull_a_x
  );

  bullet_b : bullet
  generic map (
    tank_y_pos       => std_logic_vector((unsigned(TANKB_Y) + to_unsigned(TANK_HEIGHT,10) - to_unsigned(BULLET_HEIGHT,10))),
    bullet_direction => '0'
  )
  port map (
    clk                   => clk,
    reset                 => reset,
    pulse                 => pulse,
    fire                  => fireB,
    tank_x_pos            => std_logic_vector((unsigned(bXout) + to_unsigned(TANK_WIDTH/2,10))),
    collision             => is_hit_a,
    next_bullet_active    => bull_b_active,
    next_y_pos            => bull_b_y,
    next_x_pos            => bull_b_x
  );

  collision_a : collision
  port map (
    tank_x   => aXout,
    tank_y   => TANKA_Y(8 downto 0),
    bullet_x => bull_b_x,
    bullet_y => bull_b_y(8 downto 0),
    clk      => clk,
    reset    => reset,
    pulse    => pulse,
    is_hit   => is_hit_a
  );

  collision_b : collision
  port map (
    tank_x   => bXout,
    tank_y   => TANKB_Y(8 downto 0),
    bullet_x => bull_a_x,
    bullet_y => bull_a_y(8 downto 0),
    clk      => clk,
    reset    => reset,
    pulse    => pulse,
    is_hit   => is_hit_b
  );

  score_a : score
  port map (
    clk       => clk,
    reset     => reset,
    collision => is_hit_b,
    pulse     => pulse,
    score     => scoreA
  );

  score_b : score
  port map (
    clk       => clk,
    reset     => reset,
    collision => is_hit_a,
    pulse     => pulse,
    score     => scoreB
  );

  win:  win_logic
  port map(
    clk => clk,
    reset => reset,
    pulse =>  pulse,
    scoreA => scoreA,
    scoreB => scoreB,
    hold => hold,
    winner => win_sig
  );


  leddcd_a : leddcd
  port map (
    data_in      => scoreA,
    segments_out => HexA
  );

  leddcd_b : leddcd
  port map (
    data_in      => scoreB,
    segments_out => HexB
  );

  leddcd_c : leddcd
  port map (
    data_in      => "1010",
    segments_out => HexLabelA
  );

  leddcd_d : leddcd
  port map (
    data_in      => "1011",
    segments_out => HexLabelB
  );

  lcd : de2lcd
  	PORT MAP(
      reset => not(reset),
      clk_50Mhz => clk,
  		winner => win_sig,
  		LCD_RS => LCD_RS,
      LCD_E => LCD_E,
      LCD_ON => LCD_ON,
      RESET_LED => RESET_LED,
      SEC_LED => SEC_LED,
  		LCD_RW => LCD_RW,
  		DATA_BUS => DATA_BUS
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
    collA <= is_hit_a;
    collB <= is_hit_b;
end architecture;
