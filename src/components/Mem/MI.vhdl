library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity MI is
  port (
    clock : in std_logic;
    address : in std_logic_vector (11 downto 0);
    dataout : out std_logic_vector (31 downto 0)
  );
end entity MI;

architecture RTL of MI is
  Type mem_type is array (0 to 2**12-1) of std_logic_vector(31 downto 0);
  signal mem : mem_type;
  signal read_address : unsigned(11 downto 0);
  signal initialize : std_logic;
begin
  initialize <= '1';
  init_proc: process(initialize) is
    -- Function to read from file
    impure function init_mem_hex return mem_type is
      file text_file : text open read_mode is "./src/components/Mem/hex_instructions.txt";
      variable text_line : line;
      variable mem_content : mem_type;
      variable i : integer := 0;
    begin
      while not endfile(text_file) loop
        readline(text_file, text_line);
        hread(text_line, mem_content(i));
        i := i + 1;
      end loop;
     
      return mem_content;
    end function;
    -- END init_mem_hex
  begin
    mem <= init_mem_hex;
  end process init_proc;

  root_proc: process(clock) is
  begin
    if (clock'event and clock='1') then
      read_address <= unsigned(address);
    end if;
  end process root_proc;
    
  mem_proc: process(mem, read_address)
  begin
    dataout <= mem(to_integer(read_address));
  end process mem_proc;
end RTL;
