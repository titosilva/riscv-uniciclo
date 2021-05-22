library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUM is
  port (
    datain0 : in std_logic_vector(31 downto 0);
    datain1 : in std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
  );
end entity SUM;

architecture RTL of SUM is
  signal A : signed(datain0'range) := to_signed(0, 32);
  signal B : signed(datain1'range) := to_signed(0, 32);
begin
  root_proc: process(datain0, datain1) is
  begin
    A <= signed(datain0);
    B <= signed(datain1);
  end process root_proc;

  AB_proc: process(A, B) is
  begin
    dataout <= std_logic_vector(A + B);
  end process AB_proc;
end RTL;
