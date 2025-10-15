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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal en: std_logic;
signal instr: std_logic_vector(31 downto 0);
signal pcr: std_logic_vector(31 downto 0) := (others => '0');
signal digits: std_logic_vector(31 downto 0) := (others => '0');

component MPG
Port(enable: out std_logic;
     btn: in std_logic;
     clk: in std_logic);
end component;

component SSD
Port(clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch
 Port (jump: in std_logic;
       jumpAddress: in std_logic_vector(31 downto 0);
       PCSrc: in std_logic;
       branchAddress: in std_logic_vector(31 downto 0);
       en: in std_logic;
       rst: in std_logic;
       clk: in std_logic;
       instruction: out std_logic_vector(31 downto 0);
       PCRez: out std_logic_vector(31 downto 0));
end component;

component UC
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
end component;

component ID
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
end component;

component ex
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
end component;

component mem
port ( clk : in std_logic;
       memWrite : in std_logic;
       en : in std_logic; 
       aluResIn : in std_logic_vector(31 downto 0);
       rd2  : in std_logic_vector(31 downto 0);
       memData : out std_logic_vector(31 downto 0);
       aluResOut: out std_logic_vector(31 downto 0));
end component;

signal RegWrite: std_logic;
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal MemToReg: std_logic;
signal MemWrite: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal wd: std_logic_vector(31 downto 0);
signal rd1: std_logic_vector(31 downto 0);
signal rd2: std_logic_vector(31 downto 0);
signal ext_imm: std_logic_vector(31 downto 0);
signal func: std_logic_vector(5 downto 0);
signal sa: std_logic_vector(4 downto 0);
signal z : std_logic;
signal aluRes: std_logic_vector(31 downto 0);
signal branchAddress: std_logic_vector(31 downto 0);
signal aluResOut: std_logic_vector(31 downto 0);
signal memData: std_logic_vector(31 downto 0);
signal muxOut: std_logic_vector(31 downto 0);
signal andGate : std_logic;
signal jumpAddress: std_logic_vector(31 downto 0);

begin

monopulse1: MPG port map(en,btn(0),clk);
display: SSD port map(clk,digits,an,cat);
fetch: IFetch port map(Jump, jumpAddress, andGate, branchAddress, en, btn(1), clk, instr,pcr);
instruct: ID port map(clk, RegWrite, instr(25 downto 0), RegDst, en, ExtOp, muxOut,
        rd1, rd2, ext_imm, func, sa);
control_unit: UC port map(instr(31 downto 26) , RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp,
        MemWrite, MemToReg, RegWrite);
execute: ex port map(rd1, ALUSrc, rd2, ext_imm, sa, func, ALUOp, pcr, z, aluRes, branchAddress);
memory: mem port map(clk, memWrite, en, aluRes, rd2, memData, aluResOut);

wd <= aluResOut when MemToReg='0' else memData;

process(instr, pcr, rd1, rd2, ext_imm, aluRes, memData, wd)
begin
case sw(7 downto 5) is
when "000" => digits <= instr;
when "001" => digits <= pcr;
when "010" => digits <= rd1;
when "011" => digits <= rd2;
when "100" => digits <= ext_imm;
when "101" => digits <= aluRes;
when "110" => digits <= memData;
when others => digits <= wd;
end case;
end process;

led(7) <= RegDst;
led(6) <= ExtOp;
led(5) <= ALUSrc;
led(4) <= Branch;
led(3) <= Jump;
led(2) <= MemWrite;
led(1) <= MemToReg;
led(0) <= RegWrite;
led(10 downto 8) <= ALUOp;

muxOut <= aluResOut when MemToReg='0' else memData;
andGate <= z and Branch;
jumpAddress <= pcr(31 downto 28) & instr(25 downto 0) & "00";

end Behavioral;

