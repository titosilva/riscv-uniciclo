library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
  port (
    clock: in std_logic;
    we: in std_logic;
    datain: in std_logic_vector(31 downto 0);
    dataout: out std_logic_vector(31 downto 0)
  );
end entity PC;

architecture RTL of PC is
  signal current_value: std_logic_vector(31 downto 0);
begin
  root_proc: process(clock) is
  begin
    if(rising_edge(clock) and we = '1')
    then
      if current_value(0) = 'U' then
        -- Inicialização
        current_value <= std_logic_vector(to_unsigned(0, 32));
      else
        current_value <= datain;
      end if;
    end if;
  end process root_proc;

  output_proc: process(current_value) is
  begin
    dataout <= current_value;
  end process output_proc;
end RTL;
