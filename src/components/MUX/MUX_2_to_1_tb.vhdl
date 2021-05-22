library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2_to_1_tb is
end MUX_2_to_1_tb;

architecture testbench of MUX_2_to_1_tb is
  component MUX_2_to_1 is
    port (
      datain0 : in std_logic_vector(31 downto 0);
      datain1 : in std_logic_vector(31 downto 0);
      selector : in std_logic;
      dataout : out std_logic_vector(31 downto 0)
    );
  end component;

  signal period: time := 8 ns;
  signal datain0: std_logic_vector(31 downto 0);
  signal datain1: std_logic_vector(31 downto 0);
  signal selector: std_logic := '0';
begin
  module: MUX_2_to_1 port map(
    datain0 => datain0,
    datain1 => datain1,
    selector => selector,
    dataout => open
  );

  test_handler: process is
  begin
    wait for period;

    datain0 <= std_logic_vector(to_unsigned(1, 32));
    datain1 <= std_logic_vector(to_unsigned(0, 32));

    selector <= '0';
    wait for period;

    selector <= '1';
    wait for period;

    datain0 <= std_logic_vector(to_unsigned(0, 32));
    datain1 <= std_logic_vector(to_unsigned(1, 32));
    wait for period;

    wait;
  end process;
end architecture;