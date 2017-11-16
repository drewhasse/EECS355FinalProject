library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Additional standard or custom libraries go here
package tank_pack is
  constant TANK_WIDTH : natural := 96;
  constant TANK_HEIGHT : natural := 105;
  constant TANKA_Y : std_logic_vector(9 downto 0) := "0000001010";
  constant TANKB_Y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(380, 10));
  constant TANK_INITIAL_X : natural := 320;
  constant SPEED_FACTOR : natural := 10;
  constant BULLET_HEIGHT : natural := 50;
  constant BULLET_WIDTH : natural := 8;
  constant BACK_WIDTH : natural := 256;
  constant BACK_HEIGHT : natural := 256;
  constant CLEAR_COLOR : std_logic_vector(23 downto 0) := "000000000000000000000000";
  constant CHROMA_KEY : std_logic_vector(23 downto 0) := "111111001111110011111100";
  component tankAROM is
  	port
  	(
  		address		: in std_logic_vector (13 downto 0);
  		clock		: in std_logic  := '1';
  		q			: out std_logic_vector (23 downto 0)
  	);
  end component tankAROM;

  component tankBROM is
  	port
  	(
  		address		: in std_logic_vector (13 downto 0);
  		clock		: in std_logic  := '1';
  		q			: out std_logic_vector (23 downto 0)
  	);
  end component tankBROM;

  component BulletUpROM
  port (
    address : IN  STD_LOGIC_VECTOR (8 DOWNTO 0);
    clock   : IN  STD_LOGIC  := '1';
    q       : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
  );
  end component BulletUpROM;

  component BulletDownROM
  port (
    address : IN  STD_LOGIC_VECTOR (8 DOWNTO 0);
    clock   : IN  STD_LOGIC  := '1';
    q       : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
  );
  end component BulletDownROM;

  component backROM
  port (
    address : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
    clock   : IN  STD_LOGIC  := '1';
    q       : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
  );
  end component backROM;

  component bullet
  generic (
    w                : std_logic_vector(3 downto 0);
    h                : std_logic_vector(3 downto 0);
    rgb_color        : std_logic_vector(9 downto 0);
    tank_y_pos       : std_logic_vector (8 downto 0);
    bullet_direction : std_logic
  );
  port (
    clk                   : in  std_logic;
    reset                 : in  std_logic;
    pulse                 : in  std_logic;
    fire                  : in  std_logic;
    current_x_pos         : in  std_logic_vector (9 downto 0);
    current_y_pos         : in  std_logic_vector (8 downto 0);
    current_bullet_active : in  std_logic;
    tank_x_pos            : in  std_logic_vector (9 downto 0);
    collision             : in  std_logic;
    next_bullet_active    : out std_logic;
    next_y_pos            : out std_logic_vector (8 downto 0);
    next_x_pos            : out std_logic_vector (9 downto 0)
  );
  end component bullet;

  component tank
  generic (
    width : std_logic_vector(5 downto 0)
  );
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    pulse   : in  std_logic;
    speed   : in  std_logic_vector(1 downto 0);
    isLoser : in  std_logic;
    xout    : out std_logic_vector(9 downto 0)          --moveDirNew : out std_logic
  );
  end component tank;

  component GraphicsOut
  port (
    Ax, Ay, Bx, By, BAx, BAy, BBx, BBy        : in std_logic_vector(9 downto 0);
    CLOCK_50 : in  std_logic;
    RESET_N  : in  std_logic;
    VGA_BLUE : out std_logic_vector(7 downto 0);
    VGA_CLK  : out std_logic
  );
  end component GraphicsOut;

  component counter
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    hold  : in  std_logic;
    pulse : out std_logic
  );
end component counter;



end package tank_pack;
package body tank_pack is
end package body tank_pack;
