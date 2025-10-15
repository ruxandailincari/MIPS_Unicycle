library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
Port ( clk: in std_logic;
      RegWrite: in std_logic;
      Instr: in std_logic_vector(25 downto 0);
       RegDst: in std_logic;
       en : in std_logic;
       ExtOp: in std_logic;
       wd: in std_logic_vector(31 downto 0);
       rd1: out std_logic_vector(31 downto 0);
       rd2: out std_logic_vector(31 downto 0);
       ext_imm: out std_logic_vector(31 downto 0);
       func: out std_logic_vector(5 downto 0);
       sa: out std_logic_vector(4 downto 0));
end ID;

architecture Behavioral of ID is

type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (
others => X"00000000");

signal write_address: std_logic_vector(4 downto 0);

begin

write_address <= Instr(20 downto 16) when RegDst='0' else Instr(15 downto 11);

process(clk)
begin
if rising_edge(clk) then
if RegWrite = '1' and en = '1' then
reg_file(conv_integer(write_address)) <= wd;
end if;
end if;
end process;
rd1 <= reg_file(conv_integer(Instr(25 downto 21)));
rd2 <= reg_file(conv_integer(Instr(20 downto 16)));

ext_imm(15 downto 0) <= Instr(15 downto 0);
ext_imm(31 downto 16) <= (others => Instr(15)) when ExtOp='1' else (others => '0');

func <= Instr(5 downto 0);
sa <= Instr(10 downto 6);
end Behavioral;
