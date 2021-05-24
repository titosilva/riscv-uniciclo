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
  signal mem : mem_type := (others => (others => '0'));
  signal read_address : unsigned(11 downto 0);
  signal initialize : std_logic;
  signal initialized : std_logic := '0';
  signal temp_data: std_logic_vector(31 downto 0);
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
      
      mem_temp := init_mem_hex;

      load_mem: for i in 0 to 2**12-1 loop
        mem(i) <= mem_temp(i);
      end loop load_mem;
      initialized <= '1';

    end if;
  end process init_proc;
  
  root_proc: process(clock, initialized, datain, address) is
    begin
      if (initialized = '1' and clock'event and clock='1') then
        if we = '1' then
          temp_data <= datain;
        end if;
  
        if re = '1' then
          read_address <= unsigned(address(11 downto 0));
        end if;
      end if;
  end process root_proc;

  save_proc: process(temp_data)
  begin
    mem(to_integer(unsigned(address(11 downto 0)))) <= temp_data;
  end process save_proc;

  mem_proc: process(mem, read_address)
  begin
    dataout <= mem(to_integer(read_address)/4);
  end process mem_proc;
end RTL;
