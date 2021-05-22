library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end PC_tb;

architecture testbench of PC_tb is
  component PC is
    port (
      clock: in std_logic;
      we: in std_logic;
      datain: in std_logic_vector(31 downto 0);
      dataout: out std_logic_vector(31 downto 0)
    );
  end component;

  signal period: time := 8 ns;
  signal clock: std_logic := '0';
  signal finished: std_logic := '0';
  signal we: std_logic := '1';
  signal datain: std_logic_vector(31 downto 0);
begin
  clock <= not clock after period/2 when finished = '0' else '0';

  module: PC port map(
    clock => clock,
    we => we,
    datain => datain,
    dataout => open
  );

  test_handler: process is
  begin
    wait for period;

    datain <= std_logic_vector(to_unsigned(80, 32));
    wait for period;

    datain <= std_logic_vector(to_unsigned(100, 32));
    wait for period;

    we <= '0';
    datain <= std_logic_vector(to_unsigned(80, 32));
    wait for period;

    finished <= '1';
    wait;
  end process;
end architecture;