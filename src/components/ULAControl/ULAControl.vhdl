library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULAControl is
  port ( 
    funct7 : in std_logic_vector(6 downto 0);
    funct3 : in std_logic_vector(2 downto 0);
    aluop : in std_logic_vector(1 downto 0);
    aluctr : out std_logic_vector(3 downto 0)
  );
end entity;

architecture RTL of ULAControl is
begin
  process(funct7, funct3, aluop) begin
    case aluop is
      when "00" => aluctr <= "0000"; -- soma
      when "01" => aluctr <= "0001"; -- subtração
      when "10" => 
        case funct3 is
          when "000" => 
            if (funct7(5)='1') 
            then 
              aluctr <= "0001";
            else 
              aluctr <= "0000";
          end if;
          when "111" => aluctr <= "0010";
          when "110" => aluctr <= "0011";
          when "010" => aluctr <= "0111";
          when others => aluctr <= "1000";
        end case;
      when others => aluctr <= "0000";
    end case;
  end process;
end architecture;