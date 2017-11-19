LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ps2 is
	port(keyboard_clk, keyboard_data, clock_50MHz, reset : in std_logic;
			 speedA, speedB : out std_logic_vector(1 downto 0);
			 fireA, fireB : out std_logic
		  );
end entity ps2;


architecture structural of ps2 is
signal scan_int : std_logic;
signal flag, flag2, flag3, flag4, flag5, flag6 : boolean := false;
signal scan_code_int : std_logic_vector( 7 downto 0 );
signal key1, key2, key4, key5 : std_logic;
signal read : std_logic;

component keyboard is
port(
	keyboard_clk, keyboard_data, clock_50MHz, reset, read : IN STD_LOGIC;
	scan_code   : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	scan_ready  : OUT STD_LOGIC);
end component keyboard;

component oneshot is
port(
	pulse_out  : out std_logic;
	trigger_in : in std_logic;
	clk        : in std_logic );
end component oneshot;

begin
u1: keyboard
port map(
	keyboard_clk => keyboard_clk,
	keyboard_data => keyboard_data,
	clock_50MHz => clock_50MHz,
	reset => reset,
	read => read,
	scan_code => scan_code_int,
	scan_ready => scan_int
);

pulser : oneshot
port map(
 pulse_out  => read,
 trigger_in => scan_int,
 clk        => clock_50MHz
);

a1 : process(scan_int)
begin
	if(rising_edge(scan_int)) then
		if (scan_code_int = x"F0" and not flag) THEN
			flag <= true;
		end if;
		if (scan_code_int = x"F0" and not flag2) THEN
			flag2 <= true;
		end if;
		if (scan_code_int = x"F0" and not flag3) THEN
			flag3 <= true;
		end if;
		if (scan_code_int = x"F0" and not flag4) THEN
			flag4 <= true;
		end if;
		if (scan_code_int = x"F0" and not flag5) THEN
			flag5 <= true;
		end if;
		if (scan_code_int = x"F0" and not flag6) THEN
			flag6 <= true;
		end if;
		--TANK A INPUT
		if(scan_code_int = x"41" and not flag) THEN
			key1 <= '1';
		elsif(scan_code_int = x"41" and flag) THEN
			key1 <= '0';
			flag <= false;
			flag2 <= false;
			flag3 <= false;
			flag4 <= false;
			flag5 <= false;
			flag6 <= false;
		end if;

	  if(scan_code_int = x"49" and not flag2) THEN
			key2 <= '1';
		elsif(scan_code_int = x"49" and flag2) THEN
			key2 <= '0';
			flag <= false;
			flag2 <= false;
			flag3 <= false;
			flag4 <= false;
			flag5 <= false;
			flag6 <= false;
		end if;

		if(scan_code_int = x"4A" and not flag3) THEN
			fireA <= '1';
		elsif(scan_code_int = x"4A" and flag3) THEN
			fireA <= '0';
			flag <= false;
			flag2 <= false;
			flag3 <= false;
			flag4 <= false;
			flag5 <= false;
			flag6 <= false;
		end if;

		--TANK B INPUT
		if(scan_code_int = x"1A" and not flag4) THEN
			key4 <= '1';
		elsif(scan_code_int = x"1A" and flag4) THEN
			key4 <= '0';
			flag <= false;
			flag2 <= false;
			flag3 <= false;
			flag4 <= false;
			flag5 <= false;
			flag6 <= false;
		end if;

		if(scan_code_int = x"22" and not flag5) THEN
			key5 <= '1';
		elsif(scan_code_int = x"22" and flag5) THEN
			key5 <= '0';
			flag <= false;
			flag2 <= false;
			flag3 <= false;
			flag4 <= false;
			flag5 <= false;
			flag6 <= false;
		end if;

		if(scan_code_int = x"21" and not flag6) THEN
			fireB <= '1';
		elsif(scan_code_int = x"21" and flag6) THEN
			fireB <= '0';
			flag <= false;
			flag2 <= false;
			flag3 <= false;
			flag4 <= false;
			flag5 <= false;
			flag6 <= false;
		end if;
	end if;
end process a1;

combOutput : process(key1, key2, key4, key5) is
	BEGIN
		if (key1 = '1') THEN
			speedA <= "01";
		elsif (key2 = '1') THEN
			speedA <= "11";
		else
			speedA <= "10";
		end if;

		if (key4 = '1') THEN
			speedB <= "01";
		elsif (key5 = '1') THEN
			speedB <= "11";
		else
			speedB <= "10";
		end if;
end process combOutput;

end architecture structural;
