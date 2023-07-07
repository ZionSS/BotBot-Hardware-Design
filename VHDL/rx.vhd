----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:52:37 05/20/2023 
-- Design Name: 
-- Module Name:    rx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rx is
	Port (
		Reset 	: in std_logic;
		SysClk 	: in std_logic;
		Rx 		: in  std_logic;
		Data 		: out std_logic_vector(7 downto 0) := "00000000";
		Led 		: out std_logic_vector(7 downto 0) := "00000000");
end rx;

 architecture Behavioral of rx is
	constant Count_BuadRate : std_logic_vector (15 downto 0) := X"208D"; --Baud rate = 9600 bit per sec.
	signal 	Data_Pack 		: std_logic_vector (9 downto 0) := "0000000000";
-- internal signal
	signal 	Clk_Count 		: std_logic_vector (15 downto 0) :=x"0000";
--variable
	signal 	shift_bit		: integer range 0 to 9 :=0; 
	signal 	Start_bit_check: boolean := false;
begin
	Receive_Rx : process (SysClk, Rx) Is
		Begin
			if rising_edge(SysClk) then
				if (Reset='1') then	-- Press Reset button for clear all.
					shift_bit <=0; --move to Data_Pack [0]
					Data_Pack <= (others=> '0'); 
					Start_bit_check <= false;
					Clk_Count <= (others=> '0'); 
					Led <= (others => '0');
					Data <= (others => '0');
				else
					if Rx = '0' and Start_bit_check = false then --Capture start bit Enable start bit flag
					Start_bit_check <= true; 
					Data_Pack <= (others=> '0');
					Clk_Count <= (others=> '0'); 						--Clear Clk_Count
					elsif (Start_bit_check = true) then 			-- Check flag start bit 
						if (Count_BuadRate-1)=Clk_Count then 
							shift_bit <=	shift_bit+1; 
							Clk_Count <= (others=> '0');
						elsif Clk_Count=(x"411"-1) then 				--Capture data logic on middle point = Count_BuadRate/2 = x"516"
							Data_Pack(shift_bit) <= Rx; 
							Clk_Count <= Clk_Count + 1; 
							if (shift_bit=9) then
							shift_bit <= 0;
							Start_bit_check <= false; 					-- Clear start bit flag 
							Led <= Data_Pack (8 downto 1); 			-- ass LED
							Data <= Data_Pack (8 downto 1); 
							end if;
						else
							Clk_Count <= Clk_Count+1;
						End if;
					End if;
				End if;
			End if;
	End process Receive_Rx;
end Behavioral;

