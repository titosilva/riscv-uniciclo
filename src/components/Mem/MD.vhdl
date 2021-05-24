library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity MD is
  port (
    clock : in std_logic;
    we : in std_logic;
    re : in std_logic;
    address : in std_logic_vector(31 downto 0);
    datain : in std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
  );
end entity MD;

architecture RTL of MD is
  Type mem_type is array (0 to 2**12-1) of std_logic_vector(31 downto 0);
  signal writable_mem, initialized_mem : mem_type := (others => (others => '0'));
  type mem_addresses is array (0 to 2**12-1) of std_logic;
  signal written_addresses : mem_addresses := (others => '0');
  signal read_address : unsigned(11 downto 0);
  signal initialize : std_logic;
  signal initialized : std_logic := '0';
begin
  initialize <= '1';
  init_proc: process(initialize) is
    -- Function to read from file
    impure function init_mem_hex return mem_type is
      file text_file : text open read_mode is "./uniciclo_data_hex.txt";
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
    variable mem_temp : mem_type;
  begin
    if initialized = '0' then
      
      initialized_mem <= init_mem_hex;

      initialized <= '1';
    end if;
  end process init_proc;
  
  root_proc: process(clock, datain, address, we, re) is
    begin
      if (clock'event and clock='1') then
        if we = '1' then
          writable_mem(to_integer(unsigned(address(11 downto 0)))/4) <= datain;
          written_addresses(to_integer(unsigned(address(11 downto 0)))/4) <= '1';
        end if;
  
        if re = '1' then
          read_address <= unsigned(address(11 downto 0));
        end if;
      end if;
  end process root_proc;

  mem_proc: process(writable_mem, read_address)
  begin
    if written_addresses(to_integer(unsigned(read_address))) = '1' then
      dataout <= writable_mem(to_integer(read_address)/4);
    else
      dataout <= initialized_mem(to_integer(read_address)/4);
    end if;
  end process mem_proc;
end RTL;
