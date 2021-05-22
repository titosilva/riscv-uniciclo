library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ent_tb is
  -- Generics
end ent_tb;

architecture testbench of ent_tb is
  component ent is
    port (
      -- ports
    );
  end component;

  -- signal
begin
  module: ent port map(
    -- port map
  );

  test_handler: process
  begin
    -- statements
  end process;
end testbench;