library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.tank_pack.all;

entity pixelGenerator is
	port(
			Ax, Ay, Bx, By, BullAx, BullAy, BullBx, BullBy : in std_logic_vector(9 downto 0);
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			red_out, green_out, blue_out					: out std_logic_vector(7 downto 0)
		);
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

signal colorAddress : std_logic_vector (13 downto 0);
signal colorAddTrans : std_logic_vector (15 downto 0);
signal colorAddInter, colorAddIntTrans : integer;
signal colorA, colorB, colorC, colorD, colorF : std_logic_vector (23 downto 0);

signal pixel_row_int, pixel_column_int : natural;
signal TankAx, TankAy : integer;
signal TankBx, TankBy : integer;
signal BullAxint, BullAyint : integer;
signal BullBxint, BullByint : integer;
signal TankAxLim, TankAyLim : integer;
signal TankBxLim, TankByLim : integer;
signal BullAxLim, BullAyLim : integer;
signal BullBxLim, BullByLim : integer;

begin
--------------------------------------------------------------------------------------------

	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));

	TankAx <= to_integer(unsigned(Ax));
	TankAy <= to_integer(unsigned(Ay));
	TankBx <= to_integer(unsigned(Bx));
	TankBy <= to_integer(unsigned(By));
	BullAxint <= to_integer(unsigned(BullAx));
	BullAyint <= to_integer(unsigned(BullAy));
	BullBxint <= to_integer(unsigned(BullBx));
	BullByint <= to_integer(unsigned(BullBy));

	TankAxLim <= (TankAx+TANK_WIDTH);
	TankAyLim <= (TankAy+TANK_HEIGHT);
	TankBxLim <= (TankBx+TANK_WIDTH);
	TankByLim <= (TankBy+TANK_HEIGHT);
	BullAxLim <= (BullAxint+BULLET_WIDTH);
	BullAyLim <= (BullAyint+BULLET_HEIGHT);
	BullBxLim <= (BullBxint+BULLET_WIDTH);
	BullByLim <= (BullByint+BULLET_HEIGHT);

--------------------------------------------------------------------------------------------

	colorsA : tankAROM
		port map(colorAddress(13 downto 0), ROM_clk, colorA);
	colorsB : tankBROM
		port map(colorAddress(13 downto 0), ROM_clk, colorB);
	colorsC : BulletUpROM
		port map(colorAddress(8 downto 0), ROM_clk, colorC);
	colorsD : BulletDownROM
		port map(colorAddress(8 downto 0), ROM_clk, colorD);
	colorsF : backROM
		port map(colorAddTrans, ROM_clk, colorF);

--------------------------------------------------------------------------------------------
	pixelDraw : process(clk, rst_n) is
	begin
		if (rising_edge(clk)) then
			colorAddIntTrans <= ((pixel_row_int mod (BACK_HEIGHT-1))-1)*BACK_WIDTH + (pixel_column_int mod (BACK_WIDTH-1));
			colorAddTrans <= std_logic_vector(to_unsigned(colorAddIntTrans, 16));
			if (pixel_row_int <= BullAyLim and pixel_row_int > BullAyint and pixel_column_int < BullAxLim and pixel_column_int >= BullAxint) then
				colorAddInter <= ((pixel_row_int-(BullAyint+1))*BULLET_WIDTH)+(pixel_column_int-BullAxint);
				colorAddress <= std_logic_vector(to_unsigned(colorAddInter, 14));
				if (colorC = CHROMA_KEY) then
					red_out <= colorF(23 downto 16);
					green_out <= colorF(15 downto 8);
					blue_out <= colorF(7 downto 0);
				else
					red_out <= colorC(23 downto 16);
					green_out <= colorC(15 downto 8);
					blue_out <= colorC(7 downto 0);
				end if;
			elsif (pixel_row_int <= BullByLim and pixel_row_int > BullByint and pixel_column_int < BullBxLim and pixel_column_int >= BullBxint) then
				colorAddInter <= ((pixel_row_int-(BullByint+1))*BULLET_WIDTH)+(pixel_column_int-BullBxint);
				colorAddress <= std_logic_vector(to_unsigned(colorAddInter, 14));
				if (colorD = CHROMA_KEY) then
					red_out <= colorF(23 downto 16);
					green_out <= colorF(15 downto 8);
					blue_out <= colorF(7 downto 0);
				else
					red_out <= colorD(23 downto 16);
					green_out <= colorD(15 downto 8);
					blue_out <= colorD(7 downto 0);
				end if;
			elsif (pixel_row_int < TankAyLim and pixel_row_int > TankAy and pixel_column_int < TankAxLim and pixel_column_int >= TankAx) then
				colorAddInter <= ((pixel_row_int-(TankAy+1))*TANK_WIDTH)+(pixel_column_int-TankAx);
				colorAddress <= std_logic_vector(to_unsigned(colorAddInter, 14));
				if (colorA = CHROMA_KEY) then
					red_out <= colorF(23 downto 16);
					green_out <= colorF(15 downto 8);
					blue_out <= colorF(7 downto 0);
				else
					red_out <= colorA(23 downto 16);
					green_out <= colorA(15 downto 8);
					blue_out <= colorA(7 downto 0);
				end if;
			elsif (pixel_row_int < TankByLim and pixel_row_int > TankBy and pixel_column_int < TankBxLim and pixel_column_int >= TankBx) then
				colorAddInter <= ((pixel_row_int-(TankBy+1))*TANK_WIDTH)+(pixel_column_int-TankBx);
				colorAddress <= std_logic_vector(to_unsigned(colorAddInter, 14));
				if (colorB = CHROMA_KEY) then
					red_out <= colorF(23 downto 16);
					green_out <= colorF(15 downto 8);
					blue_out <= colorF(7 downto 0);
				else
					red_out <= colorB(23 downto 16);
					green_out <= colorB(15 downto 8);
					blue_out <= colorB(7 downto 0);
				end if;
			else
				red_out <= colorF(23 downto 16);
				green_out <= colorF(15 downto 8);
				blue_out <= colorF(7 downto 0);
			end if;

		end if;

	end process pixelDraw;

--------------------------------------------------------------------------------------------

end architecture behavioral;
