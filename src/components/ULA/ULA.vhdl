library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
  generic (WSIZE : natural := 32);
  port (
    opcode : in std_logic_vector(3 downto 0);
    A, B : in std_logic_vector(WSIZE-1 downto 0);
    Z : out std_logic_vector(WSIZE-1 downto 0);
    zero : out std_logic
  );
end ULA;

architecture RTL of ULA is
  signal Asigned, Bsigned, Zsigned: signed (WSIZE-1 downto 0);
begin
  Asigned <= signed(A);
  Bsigned <= signed(B);

  compute: process(opcode, Asigned, Bsigned)
  begin
    case opcode is
      when "0000" => 
        Zsigned <= Asigned + Bsigned;
      when "0001" => 
        Zsigned <= Asigned - Bsigned;
      when "0010" => 
        Zsigned <= Asigned and Bsigned;
      when "0011" => 
        Zsigned <= Asigned or Bsigned;
      when "0100" => 
        Zsigned <= Asigned xor Bsigned;
      when "0101" => 
        Zsigned <= Asigned sll to_integer(Bsigned);
      when "0110" => 
        Zsigned <= Asigned srl to_integer(Bsigned);
      when "0111" => 
        Zsigned <= signed (to_stdlogicvector(to_bitvector(std_logic_vector(Asigned)) sra to_integer(Bsigned)));
      when "1000" => 
        if(Asigned < Bsigned)
        then
          Zsigned <= to_signed(1, WSIZE);
        else
        Zsigned <= to_signed(0, WSIZE);
        end if;
      when "1001" => 
        if(unsigned(Asigned) < unsigned(Bsigned))
        then
          Zsigned <= to_signed(1, WSIZE);
        else
        Zsigned <= to_signed(0, WSIZE);
        end if;
      when "1010" => 
        if(Asigned >= Bsigned)
        then
          Zsigned <= to_signed(1, WSIZE);
        else
        Zsigned <= to_signed(0, WSIZE);
        end if;
      when "1011" => 
        if(unsigned(Asigned) >= unsigned(Bsigned))
        then
          Zsigned <= to_signed(1, WSIZE);
        else
          Zsigned <= to_signed(0, WSIZE);
        end if;
      when "1100" => 
        if(Asigned = Bsigned)
        then
          Zsigned <= to_signed(1, WSIZE);
        else
        Zsigned <= to_signed(0, WSIZE);
        end if;
      when "1101" => 
        if(Asigned /= Bsigned)
        then
          Zsigned <= to_signed(1, WSIZE);
        else
        Zsigned <= to_signed(0, WSIZE);
        end if;
      when others => 
        Zsigned <= to_signed(0, WSIZE);
    end case;
  end process compute;

  process(Zsigned)
  begin
    Z <= std_logic_vector(Zsigned);

    if (Zsigned = to_signed(0, WSIZE))
    then 
      zero <= '1';
    else 
      zero <= '0';
    end if;
  end process;
end RTL;
