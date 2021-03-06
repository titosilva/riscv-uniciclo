library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2_to_1 is
  port (
    datain0 : in std_logic_vector(31 downto 0);
    datain1 : in std_logic_vector(31 downto 0);
    selector : in std_logic;
    dataout : out std_logic_vector(31 downto 0)
  );
end entity MUX_2_to_1;

architecture RTL of MUX_2_to_1 is
begin
  root_proc: process(datain0, datain1, selector) is
  begin
    case selector is
      when '0' => dataout <= datain0;
      when '1' => dataout <= datain1;
      when others => dataout <= datain0;
    end case;
  end process root_proc;
end RTL;
