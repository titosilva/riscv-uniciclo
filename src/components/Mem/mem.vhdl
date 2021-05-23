library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_rv is
  port (
    clock : in std_logic;
    we : in std_logic;
    address : in std_logic_vector;
    datain : in std_logic_vector;
    dataout : out std_logic_vector
  );
end entity mem_rv;

architecture RTL of mem_rv is
  Type mem_type is array (0 to 32) of std_logic_vector(datain'range);
  signal mem : mem_type;
  signal read_address : unsigned(address'range);
begin
  root_proc: process(clock) is
  begin
    if (clock'event and clock='1') then
      if we = '1' then
        mem(to_integer(unsigned(address))) <= datain;
      end if;

      read_address <= unsigned(address);
    end if;

  end process root_proc;
    
  mem_proc: process(mem, read_address)
  begin
    dataout <= mem(to_integer(read_address));
  end process mem_proc;
end RTL;
