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
      when "10" => -- R Type
        case funct3 is
          when "000" => 
            if (funct7(5)='1')
            then 
              aluctr <= "0001"; -- add
            else 
              aluctr <= "0000"; -- sub
          end if;
          when "111" => aluctr <= "0010"; -- and
          when "010" => aluctr <= "1000"; -- slt
          when "110" => aluctr <= "0011"; -- or
          when "100" => aluctr <= "0100"; -- xor
          when "011" => aluctr <= "1001"; -- sltu
          when others => aluctr <= "1000";
        end case;
      when "11" => -- I Type
      case funct3 is
        when "000" => aluctr <= "0000"; -- addi
        when "111" => aluctr <= "0010"; -- andi
        when "110" => aluctr <= "0011"; -- ori
        when "100" => aluctr <= "0100"; -- xori
        when "001" => aluctr <= "0101"; -- slli
        when "101" => 
          if (funct7(5)='1')
            then 
              aluctr <= "0111"; -- srai
            else 
              aluctr <= "0110"; -- srli
          end if;
        when "010" => aluctr <= "1000"; -- stli
        when "011" => aluctr <= "1001"; -- sltui
        when others => aluctr <= "1000";
      end case;
      when others => aluctr <= "0000";
    end case;
  end process;
end architecture;