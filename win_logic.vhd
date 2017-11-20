library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tank_pack.all;

entity win_logic is
  port (
  clk : in std_logic;
  reset : in std_logic;
  pulse : in std_logic;
  scoreA, scoreB : in std_logic_vector(3 downto 0);
  hold : out std_logic;
  winner: out std_logic_vector(1 downto 0)
  );
end entity;

architecture behavioral of win_logic is
type state is (idle, delay, endgame);
signal current_s, next_s : state;
signal win, win_c : std_logic_vector(1 downto 0);
signal hold_int, hold_int_c : std_logic;
begin
  clocked : process(clk, reset) is
    begin
      if (reset = '1') then
        win <= "00";
        hold_int <= '0';
        current_s <= idle;
      elsif (rising_edge(clk)) then
        win <= win_c;
        current_s <= next_s;
        hold_int <= hold_int_c;
      end if;
  end process clocked;

  combinational : process(current_s, win) is
    begin
    --Internal state signals
    win_c <= win;
    next_s <= current_s;
    hold_int_c <= hold_int;
    --Output
    winner <= win;
    hold <= hold_int;

    case (current_s) is
      when (idle) =>
       if (pulse = '1') then
          if (scoreA = SCORE_TO_WIN) THEN
            win_c <= "01";
            next_s <= delay;
          end if;
          if (scoreB = SCORE_TO_WIN) THEN
            win_c <= "10";
            next_s <= delay;
          end if;
        end if;
      when (delay) =>
        if (pulse = '0') THEN
          next_s <= endgame;
        end if;
      when (endgame) =>
        if (pulse = '1') THEN
          hold_int_c <= '1';
        end if;
    end case;

  end process combinational;
end architecture;
