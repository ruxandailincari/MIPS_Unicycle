library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ex is
 Port (rd1: in std_logic_vector(31 downto 0);
       ALUSrc: in std_logic;
       rd2: in std_logic_vector(31 downto 0);
       ext_imm: in std_logic_vector(31 downto 0);
       sa: in std_logic_vector(4 downto 0);
       func: in std_logic_vector(5 downto 0);
       ALUOp : in std_logic_vector(2 downto 0);
       pcPlus: in std_logic_vector(31 downto 0);
       z: out std_logic;
       aluRes: out std_logic_vector(31 downto 0);
       branchAddress: out std_logic_vector(31 downto 0));
end ex;

architecture Behavioral of ex is

signal ALUCtrl : std_logic_vector(2 downto 0);
signal aux: std_logic_vector(31 downto 0);
signal c: std_logic_vector(31 downto 0);
signal ext_imm_aux: std_logic_vector(31 downto 0);
begin

process(ALUOp, func)
begin
case ALUOp is
when "000" => --R op
    case func is
    when "100000" => ALUCtrl <= "000"; -- cod + ALU
    when "100010" => ALUCtrl <= "001"; -- cod - ALU
    when "100100" => ALUCtrl <= "010"; -- cod and ALU 
    when "101111" => ALUCtrl <= "011"; -- cod srl ALU
    when "100101" => ALUCtrl <= "100"; --cod or ALU
    when "100001" => ALUCtrl <= "101"; --cod sll ALU
    when "100110" => ALUCtrl <= "110"; --cod sra ALU
    when "100111" => ALUCtrl <= "111"; --cod xor ALU
    when others => ALUCtrl <= (others=>'X');
    end case;
when "001" => ALUCtrl <= "000";
when "010" => ALUCtrl <= "001";
when "011" => ALUCtrl <= "010";
when "100" => ALUCtrl <= "100";
when others => ALUCtrl <= (others => 'X');
end case;
end process;

process(ALUCtrl, aux, rd1, sa)
begin
case ALUCtrl is
when "000" => c <= aux + rd1;
when "001" => c <=  rd1 - aux;
when "010" => c <= rd1 and aux;
when "100" => c <= rd1 or aux;
when "011" => c <= to_stdlogicvector(to_bitvector(aux) srl conv_integer(sa));
when "101" => c <= to_stdlogicvector(to_bitvector(aux) sll conv_integer(sa));
when "110" => c <= to_stdlogicvector(to_bitvector(aux) sra conv_integer(sa));
when "111" => c <= rd1 xor aux;
when others => c <= (others => '0');
end case;
end process;

aux<= rd2 when ALUSrc='0' else ext_imm;
aluRes <= c;
z <= '1' when c=X"00000000" else '0';

ext_imm_aux <= ext_imm(29 downto 0) & "00";
branchAddress <= ext_imm_aux + pcPlus;

end Behavioral;
