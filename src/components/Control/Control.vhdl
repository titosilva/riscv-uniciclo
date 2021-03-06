library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control is
  port (
    opcode: in std_logic_vector(6 downto 0);
    branch: out std_logic;
    memRead: out std_logic;
    memReg: out std_logic;
    ULAOp: out std_logic_vector(1 downto 0);
    ULASrc: out std_logic;
    memWrite: out std_logic;
    regWrite: out std_logic;
    is_jalx: out std_logic;
    is_jalr: out std_logic
  );
end entity Control;

architecture RTL of Control is
begin
  root_proc: process(opcode) is
  begin
    case opcode is
      -- R-type
      when "0110011" =>
        ULASrc <= '0';
        memReg <= '0';
        regWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        branch <= '0';
        ULAOp <= "10";
        is_jalx <= '0';
        is_jalr <= '0';
      -- I-type
      when "0010011" =>
        ULASrc <= '1';
        memReg <= '0';
        regWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        branch <= '0';
        ULAOp <= "11";
        is_jalx <= '0';
        is_jalr <= '0';
      -- B-type
      when "1100011" =>
        ULASrc <= '0';
        memReg <= '0';
        regWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        branch <= '1';
        ULAOp <= "01";
        is_jalx <= '0';
        is_jalr <= '0';
      -- LUI
      when "0110111" => 
        ULASrc <= '1';
        memReg <= '0';
        regWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        branch <= '0';
        ULAOp <= "00";
        is_jalx <= '0';
        is_jalr <= '0';
      -- lw
      when "0000011" =>
        ULASrc <= '1';
        memReg <= '1';
        regWrite <= '1';
        memRead <= '1';
        memWrite <= '0';
        branch <= '0';
        ULAOp <= "00";
        is_jalx <= '0';
        is_jalr <= '0';
      -- sw
      when "0100011" => 
        ULASrc <= '1';
        memReg <= '1';
        regWrite <= '0';
        memRead <= '0';
        memWrite <= '1';
        branch <= '0';
        ULAOp <= "00";
        is_jalx <= '0';
        is_jalr <= '0';
      when "1101111" =>
        ULASrc <= '0';
        memReg <= '0';
        regWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        branch <= '1';
        ULAOp <= "00";
        is_jalx <= '1';
        is_jalr <= '0';
      when "1100111" =>
        ULASrc <= '0';
        memReg <= '0';
        regWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        branch <= '1';
        ULAOp <= "00";
        is_jalx <= '1';
        is_jalr <= '1'; 
      when others =>
        ULASrc <= '0';
        memReg <= '0';
        regWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        branch <= '0';  
        ULAOp <= "01";
        is_jalx <= '0';
        is_jalr <= '0'; 
    end case;
  end process root_proc;
end RTL;
