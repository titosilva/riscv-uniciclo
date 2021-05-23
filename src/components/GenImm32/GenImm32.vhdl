library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity GenImm32 is
  port (
    instr : in std_logic_vector(31 downto 0);
    imm32 : out std_logic_vector(31 downto 0)
  );
end GenImm32;

architecture GenImm32_arch of GenImm32 is
  type FORMAT_RV is ( R_type, I_type, S_type, SB_type, UJ_type, U_type );
  signal opcode: std_logic_vector(7 downto 0);
  signal currentType: FORMAT_RV;
  signal imm32s: signed(31 downto 0);
begin
  opcode <= '0' & instr(6 downto 0);

  opcodeProc: process(instr, opcode)
  begin
    case opcode is
      when x"33" => currentType <= R_type;
      when x"03" | x"13" | x"67" => currentType <= I_type;
      when x"23" => currentType <= S_type;
      when x"63" => currentType <= SB_type;
      when x"37" => currentType <= U_type;
      when x"6F" => currentType <= UJ_type;
      when others => currentType <= R_type;
    end case;
  end process opcodeProc;

  currentTypeProc: process(instr, currentType)
  begin
    case currentType is
      when I_type => imm32s <= resize(signed(instr(31 downto 20)), 32);
      when S_type => imm32s <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);
      when SB_type => imm32s <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32);
      when UJ_type => imm32s <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32);
      when U_type => imm32s <= signed(instr(31 downto 12) & x"000");
      when R_type => imm32s <= to_signed(0, 32);
      when others => imm32s <= to_signed(0, 32);
    end case;
  end process currentTypeProc;

  output_proc: process(imm32s)
  begin
    imm32 <= std_logic_vector(imm32s);
  end process output_proc;
end GenImm32_arch;