library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tank_pack.all;

entity tank is
  generic (
           y : std_logic_vector(8 downto 0);
           width : std_logic_vector(5 downto 0);
           height : std_logic_vector(5 downto 0);
           color : std_logic_vector(9 downto 0)
  );
  port (
        clk : in std_logic;
        reset : in std_logic;
        pulse : in std_logic;
        speed : in std_logic_vector(1 downto 0);
        moveDir : in std_logic;
        isLoser : in std_logic;
        xnew : out std_logic_vector(9 downto 0);
        moveDirNew : out std_logic
  );
end entity;

architecture behavioral of tank is

  type state is (idle, update, lost, waitOnPulseLow);
  signal moveDirNew_c : std_logic;
  signal xnew_c : std_logic_vector(9 downto 0);

begin

  TankClkProc: process(clk, reset) is
    begin
      if (reset = '1') then
        xnew <= std_logic_vector(to_unsigned(TANK_INITIAL_X, 10));
        moveDirNew <= '0';
        current_s <= idle;
      elsif (rising_edge(clk)) then
        xnew <= xnew_c;
        moveDirNew <= moveDirNew_c;
        current_s <= next_s;
      end if;
    end process;

  TankCombProc: process(current_s, moveDirNew, xnew, speed, isLoser) is
    
    variable x_int : integer;
    variable width_int : integer;

    begin
      x_int := to_integer(unsigned(xnew));
      width_int := to_integer(unsigned(width));

      xnew_c <= xnew;
      moveDirNew_c <= moveDirNew;
      next_s <= current_s;

      case (current_s) is
---------------------------------Idle------------------------------------------
        when (idle) =>
          moveDirNew_c <= moveDirNew;
          xnew_c <= xnew;
          if (pulse = '0') then
            next_s <= idle;
          elsif (pulse = '1') then
            next_s <= update;
          end if;

-------------------------------Update Position--------------------------------
        when (update) =>
          if (moveDirNew = '0') then
            xnew_c <= std_logic_vector(to_unsigned(to_integer(unsigned(xnew)) + to_integer(unsigned(speed))*SPEED_FACTOR, 10));
          elsif (moveDirNew = '1') then
            xnew_c <= std_logic_vector(to_unsigned(to_integer(unsigned(xnew)) - to_integer(unsigned(speed))*SPEED_FACTOR, 10));
          end if;

          if (x_int < 0 + width_int/2 and moveDirNew = '1') then --x is negative and moving left
            moveDirNew_c <= '0';
          elsif (x_int > 639 - width_int/2 and moveDirNew = '0') then
            moveDirNew_c <= '1';
          else
            moveDirNew_c <= moveDirNew;
          end if;
          if (isLoser = '1') then
            next_s <= lost;
          else
            next_s <= waitOnPulseLow;       --- Send here so you don't bounce between idle and update
          end if;

---------------------------------Wait for pulse to go low------------------------------
        when (waitOnPulseLow) =>            --- Might need to add xnew_c and moveDirNew_c assignments
          if (pulse = '0') then
            next_s <= idle;
          else
            next_s <= waitOnPulseLow;
          end if;

        when (lost) =>
          xnew_c <= "1111111111";
          next_s <= lost;

----------------------------------Others------------------------------------------
        when others =>
          next_s <= idle;
          moveDirNew_c <= '0';
          xnew_c <= xnew;
        end case;
      end process;

end architecture;
