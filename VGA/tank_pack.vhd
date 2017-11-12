library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Additional standard or custom libraries go here
package tank_pack is
  constant TANK_WIDTH : natural := 96;
  constant TANK_HEIGHT : natural := 105;
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

end package tank_pack;
package body tank_pack is
end package body tank_pack;
