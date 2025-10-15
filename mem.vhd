library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mem is
port ( clk : in std_logic;
       memWrite : in std_logic;
       en : in std_logic; 
       aluResIn : in std_logic_vector(31 downto 0);
       rd2  : in std_logic_vector(31 downto 0);
       memData : out std_logic_vector(31 downto 0);
       aluResOut: out std_logic_vector(31 downto 0));
end mem ;

architecture Behavioral of mem is
type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal ram : ram_type := (
10 => X"0000000C", -- 12
11 => X"00000043", -- 67
12 => X"00000059", -- 89
13 => X"00000005", -- 5
14 => X"0000002D", -- 45
15 => X"0000004E", -- 78
16 => X"00000019", -- 25
17 => X"00000042", -- 66
18 => X"00000054", -- 84
others => X"00000000");

begin

process(clk)
begin
if rising_edge(clk) then
if en = '1' and memWrite='1' then
ram(conv_integer(aluResIn(7 downto 2))) <= rd2;
end if;
end if;
end process;

memData <= ram(conv_integer(aluResIn(7 downto 2)));
aluResOut <= aluResIn;
end Behavioral;