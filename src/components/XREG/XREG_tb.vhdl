library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XREG_tb is
end XREG_tb;

architecture testbench of XREG_tb is
  component XREG is
    port (
      clock : in std_logic;
      we : in std_logic;
      address1 : in std_logic_vector(4 downto 0);
      address2 : in std_logic_vector(4 downto 0);
      addressWrite : in std_logic_vector(4 downto 0);
      writeData : in std_logic_vector(31 downto 0);
      dataout1 : out std_logic_vector(31 downto 0);
      dataout2 : out std_logic_vector(31 downto 0)
    );
  end component;

  signal period: time := 8 ns;
  signal clock : std_logic := '0';
  signal we : std_logic := '1';
  signal address1 : std_logic_vector(4 downto 0);
  signal address2 : std_logic_vector(4 downto 0);
  signal addressWrite : std_logic_vector(4 downto 0);
  signal writeData : std_logic_vector(31 downto 0);
  signal finished : std_logic := '0';
begin
  clock <= not clock after period/2 when finished = '0' else '0';

  module: XREG port map(
    clock => clock,
    we => we,
    address1 => address1,
    address2 => address2,
    addressWrite => addressWrite,
    writeData => writeData,
    dataout1 => open,
    dataout2 => open
  );

  test_handler: process is
  begin
    wait for period;

    addressWrite <= std_logic_vector(to_unsigned(20, 5));
    writeData <= std_logic_vector(to_signed(-1, 32));
    wait for period;

    address1 <= std_logic_vector(to_unsigned(20, 5));
    wait for period;

    address2 <= std_logic_vector(to_unsigned(20, 5));
    wait for period;

    addressWrite <= std_logic_vector(to_unsigned(0, 5));
    writeData <= std_logic_vector(to_signed(-1, 32));
    wait for period;

    address1 <= std_logic_vector(to_unsigned(0, 5));
    address2 <= std_logic_vector(to_unsigned(0, 5));
    wait for period;

    finished <= '1';
    wait;
  end process;
end architecture;