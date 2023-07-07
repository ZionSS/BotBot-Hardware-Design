----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:49:40 05/22/2023 
-- Design Name: 
-- Module Name:    Car_Control - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Car_Control is
Port(
			Reset 	: in std_logic;
		SysClk 	: in std_logic;
		Rx 		: in  std_logic;
		--Tx 		: out  std_logic;
		Motor	  : out std_logic_vector(3 downto 0);
		Led 		: out std_logic_vector(7 downto 0);
		MN			: out std_logic_vector(7 downto 0) := "00000000"
		);
end Car_Control;

architecture Behavioral of Car_Control is
	-- Car Direction
	signal data : std_logic_vector(7 downto 0);
	signal state : std_logic_vector(3 downto 0);
	constant move_forward : std_logic_vector(3 downto 0) := "1010";
	constant move_backward : std_logic_vector(3 downto 0) := "0101";
	constant turn_left : std_logic_vector(3 downto 0) := "1001";
	constant turn_right : std_logic_vector(3 downto 0) := "0110";
	constant stop : std_logic_vector(3 downto 0) := "0000";
	begin
	rx_inst : entity work.rx
    port map(  
		Reset => Reset,
		SysClk => SysClk,
		Rx => Rx,
		Data => data,
		Led => Led
    );
	
	
	process(SysClk)
begin
	if(rising_edge(SysClk)) then
		case data is
				when x"AA" => 
						motor <= move_forward;
						state <= move_forward;
						MN(3 downto 0) <= move_forward;
				when x"DD" => 
						motor <= move_backward;
						state <= move_backward;
						MN(3 downto 0) <= move_backward;
				when x"BB" => 
						motor <= turn_left;
						state <= turn_left;
						MN(3 downto 0) <= turn_left;
				when x"CC" => 
						motor <= turn_right;
						state <= turn_right;
						MN(3 downto 0) <= turn_right;
				when x"EE" =>
						motor <= stop;
						state <= stop;
						MN(3 downto 0) <= stop;
				when others =>
						motor <= state;
				end case;
	end if;
end process;
end Behavioral;

