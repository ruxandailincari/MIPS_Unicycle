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

entity IFetch is
 Port (jump: in std_logic;
        jumpAddress: in std_logic_vector(31 downto 0);
        PCSrc: in std_logic;
        branchAddress: in std_logic_vector(31 downto 0);
        en: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        instruction: out std_logic_vector(31 downto 0);
        PCRez: out std_logic_vector(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

--programul transforma in numere pare numerele impare dintr-un sir
-- face suma numerelor rezultate care sunt divizibile cu 4
type rom_mem is array(0 to 31) of std_logic_vector(31 downto 0);
signal mem1: rom_mem := (
B"000000_00000_00000_00001_00000_100000", -- X"820", 00: add $1, $0, $0 : se aduna valoarea 0 din R0, se salveaza in R1 = contorul buclei
B"001000_00000_00010_0000000000001001", --X"20020009", 01: addi $2, $0, 9 : in R2 se pune nr maxim de iteratii
B"001101_00000_00011_0000000000000000",--X"34030000" , 02: ori $3, $0, 0 : initializarea indexului locatiei de memorie in R3
B"001000_00000_00111_0000000000000000",  -- X"20070000", 03: addi $7, $0, 0 : initializeaza suma cu 0 si stocheaza in R7
B"000100_00001_00010_0000000000010001", --X"10220011" , 04: beq $1, $2, 17 :salt in afara loopului dupa 9 iteratii
B"100011_00011_00100_0000000000101000", -- X"8C640028" , 05: lw $4, 40($3) : in R4 se aduce elementul curent din sir, sirul incepe in memoria ram de la adresa 10
B"001100_00100_00101_0000000000000001", -- X"30850001", 06: andi $5, $4, 1 : in R5 se stocheaza rezultatul operatiei and intre elementul curent din sir si 1
B"001000_00000_00110_0000000000000001", --X"20060001", 07: addi $6, $0, 1 : in R6 stochez nr-ul 1
B"000100_00101_00000_0000000000000001", --X"10A00001" , 08: beq $5,$0, 1 : daca elementul curent este par sar peste o instr (rezultatul lui and = 0)
B"000000_00100_00110_00100_00000_100010", -- X"862022" , 09: sub $4, $4, $6 : scad din elementul curent -1 pentru a-l face impar
B"101011_00011_00100_0000000000101000", -- X"AC640028" , 10: sw $4, 40($3) : rescriu in memorie elementul care a fost sau nu schimbat
B"100011_00011_00100_0000000000101000", --X"8C640028", 11: lw $4, 40($3) : in R4 se aduce elementul curent din sir
B"000000_00100_00110_01000_00000_100100", --X"864024", 12:  and $8, $4 , $6 : salvez ultimul bit din elementul curent in R8
B"000000_00000_00100_01001_00001_101111", --X"4486F" , 13: srl $9, $4, 1 : shifteaza la stanga cu 1 elementul curent, stocheaza in R9
B"000000_01001_00110_01001_00000_100100", --X"1264824" , 14: and $9, $9, $6 : salveaza penultimul bit in R9
B"000000_01000_01001_01001_00000_100101", --X"1094825", 15: or $9, $8, $9 : face or intre ultimii 2 biti
B"000100_01001_00110_0000000000000001",  -- X"11260001", 16:  beq $9, $6, 1 : daca R9 este 1 sare peste urmatoarea instructiune
B"000000_00111_00100_00111_00000_100000", -- X"E43820", 17:  add $7, $7, $4 : aduna la suma elementul din sir daca e divizibil cu 4
B"001000_00011_00011_0000000000000100", -- X"20630004", 18 : addi $3, $3, 4: indexul urmatorului element din sir
B"001000_00001_00001_0000000000000001", -- X"20210001", 19:  addi $1, $1, 1 : i=i+1 actualizare bucla
B"101011_00000_00111_0000000001001100", --X"AC07004C", 20: sw $7, 76($0) : stocheaza suma in memorie la adresa 124
B"000010_00000000000000000000000100", -- X"8000004", 21:  j 3 : salt la inceputul buclei
others=>X"00000000");

signal q: std_logic_vector(31 downto 0) := (others => '0');
signal pcaux: std_logic_vector(31 downto 0);
signal s1: std_logic_vector(31 downto 0);
signal d: std_logic_vector(31 downto 0);

begin

process(clk,rst)
begin
if rst = '1' then
 q <= (others => '0');
 elsif(rising_edge(clk)) then
 if en = '1' then
  q <= d;
  end if;
end if;
end process;

instruction <= mem1(conv_integer(q(6 downto 2)));

pcaux <= q + 4;
PCRez <= pcaux;

s1 <= branchAddress when PCSrc='1' else pcaux;
d <= jumpAddress when jump='1' else s1;

end Behavioral;
