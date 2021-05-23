library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity MD is
  port (
    clock : in std_logic;
    we : in std_logic;
    address : in std_logic_vector(31 downto 0);
    datain : in std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
  );
end entity MD;

architecture RTL of MD is
  component mem_rv is
    port (
      clock : in std_logic;
      we : in std_logic;
      address : in std_logic_vector;
      datain : in std_logic_vector;
      dataout : out std_logic_vector
    );
  end component mem_rv;
begin
  internalMem: mem_rv port map(
    clock => clock,
    we => we,
    address => address,
    datain => datain,
    dataout => dataout
  );
end RTL;
