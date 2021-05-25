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
  Type mem_type is array (0 to 2**14-1) of std_logic_vector(31 downto 0);
  signal writable_mem, initialized_mem : mem_type := (others => (others => '0'));
  type mem_addresses is array (0 to 2**12-1) of std_logic;
  signal written_addresses : mem_addresses := (others => '0');
  signal initialize : std_logic;
  signal trigger : std_logic := '0';
  signal dataout_temp : std_logic_vector (31 downto 0) := std_logic_vector(to_unsigned(0, 32));
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
      for i in 0 to 2047 loop
        mem_content(i) := std_logic_vector(to_unsigned(0, 32));
      end loop;

      while not endfile(text_file) loop
        readline(text_file, text_line);
        -- O endereço base é 0x2000 = 8192. Mas como acessamos só palavras, a base é 8192/4 = 2048
        hread(text_line, mem_content(i + 2048));
        i := i + 1;
      end loop;
     
      return mem_content;
    end function;
    -- END init_mem_hex
    variable mem_temp : mem_type;
  begin
      initialized_mem <= init_mem_hex;
  end process init_proc;
  
  root_proc: process(clock) is
    variable write_address : integer;
  begin
    write_address := to_integer(unsigned(address(15 downto 0)))/4;
    if (rising_edge(clock)) then
      -- Escrita não deve ser atrasada
      if we = '1' then
        report "writable_mem written" severity note;
        writable_mem(write_address) <= datain;
        written_addresses(write_address) <= '1';
      end if;

      trigger <= not trigger after 3 ns;
    end if;
  end process root_proc;

  triggered_proc: process (trigger)
    variable result_address : integer;
  begin
    result_address := to_integer(unsigned(address(15 downto 0)))/4;

    if re = '1' then
      if written_addresses(result_address) = '1' then
        report "writable_mem read" severity note;
        dataout_temp <= writable_mem(result_address);
      else
        report "initialized_mem read" severity note;
        dataout_temp <= initialized_mem(result_address);
      end if;
    else
        dataout_temp <= std_logic_vector(to_unsigned(0, 32));
    end if;
  end process triggered_proc;

  output_proc: process(dataout_temp)
  begin
    dataout <= dataout_temp;
  end process output_proc;
end RTL;
