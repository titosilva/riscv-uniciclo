library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUM is
  port (
    datain0 : in std_logic_vector;
    datain1 : in std_logic_vector;
    dataout : out std_logic_vector
  );
end entity SUM;

architecture RTL of SUM is
  signal A : signed(datain0'range);
  signal B : signed(datain1'range);
begin
  root_proc: process(datain0, datain1) is
  begin
    A <= signed(datain0);
    B <= signed(datain1);
    dataout <= std_logic_vector(A + B);
  end process root_proc;
end RTL;
