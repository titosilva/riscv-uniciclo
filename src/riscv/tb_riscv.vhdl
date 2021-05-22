library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_tb is
  -- Generics
end riscv_tb;

architecture testbench of riscv_tb is
  component riscv is
    port (
      clock: in std_logic
    );
  end component riscv;

  signal clock : std_logic = '0';
  signal finished: std_logic = '0';
begin
  clock <= not clock after 5 ns when not finished;

  module: riscv port map(
    clock => clock
  );

  test_handler: process
  begin
    wait for 5 ns;
    finished <= '1';
    wait;
  end process;
end testbench;