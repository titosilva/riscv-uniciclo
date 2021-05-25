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
  signal initialize : std_logic;
  signal trigger : std_logic := '0';
  signal read_address: std_logic_vector (11 downto 0);
begin
  initialize <= '1';
  init_proc: process(initialize) is
    -- Function to read from file
    impure function init_mem_hex return mem_type is
      file text_file : text open read_mode is "./uniciclo_hex.txt";
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
    if (rising_edge(clock)) then
      -- Esse sinal, na verdade, só serve para atrasar um pouco a atribuição da saída e pegar o resultado correto
      trigger <= not trigger after 1 ns;
    end if;
  end process root_proc;
    
  mem_proc: process(trigger)
  begin
    dataout <= mem(to_integer(unsigned(address))/4);
  end process mem_proc;
end RTL;
