library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
  Port (Instr: in std_logic_vector(5 downto 0);
        RegDst: out std_logic;
        ExtOp: out std_logic;
        ALUSrc: out std_logic;
        Branch: out std_logic;
        Jump: out std_logic;
        ALUOp: out std_logic_vector(2 downto 0);
        MemWrite: out std_logic;
        MemToReg: out std_logic;
        RegWrite: out std_logic
        );
end UC;

architecture Behavioral of UC is

begin

process(Instr)
begin
RegDst<='0'; ExtOp <= '0'; ALUSrc <= '0';
Branch <= '0'; Jump <= '0'; ALUOp <= "000"; MemWrite <= '0';
MemToReg <= '0'; RegWrite <= '0';
case Instr is
when "000000" => 
    RegDst <= '1'; RegWrite <= '1';
    ALUOp <= "000";
when "001000" => --addi
    ExtOp <= '1'; ALUSrc <= '1'; RegWrite <= '1';
   ALUOp <= "001";
when "100011" => --lw
    ExtOp <= '1'; ALUSrc <= '1'; MemToReg <= '1'; RegWrite <= '1';
    ALUOp <= "001";
when "101011" => --sw
    ExtOp <= '1'; ALUSrc <= '1'; MemWrite <= '1';
    ALUOp <= "001";
when "000100" => --beq
 ExtOp <= '1'; Branch <= '1';
 ALUOp <= "010";
 when "000010" => --jump
 Jump <= '1';
 when "001100" => --andi
  ALUSrc <= '1'; RegWrite <= '1';
  ALUOp <= "011";
 when "001101" => --ori
 ALUSrc <= '1'; RegWrite <= '1';
 ALUOp <= "100";
 when others =>
end case;
end process;

end Behavioral;
