library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUM_tb is
end SUM_tb;

architecture testbench of SUM_tb is
  component SUM is
    port (
    datain0 : in std_logic_vector(31 downto 0);
    datain1 : in std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
  );
  end component;

  signal period: time := 8 ns;
  signal datain0: std_logic_vector(31 downto 0);
  signal datain1: std_logic_vector(31 downto 0);
begin
  module: SUM port map(
    datain0 => datain0,
    datain1 => datain1,
    dataout => open
  );

  test_handler: process is
  begin
    wait for period;

    datain0 <= std_logic_vector(to_unsigned(1, 32));
    datain1 <= std_logic_vector(to_unsigned(1, 32));
    wait for period;

    datain0 <= std_logic_vector(to_signed(-5, 32));
    datain1 <= std_logic_vector(to_signed(1, 32));
    wait for period;

    wait for period;
    wait;
  end process;
end architecture;