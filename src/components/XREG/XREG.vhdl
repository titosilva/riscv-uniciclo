library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity XREG is
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
end entity XREG;

architecture RTL of XREG is
  Type mem_type is array (0 to 31) of std_logic_vector(writeData'range);
  signal mem : mem_type;
  signal read_address1 : unsigned(4 downto 0);
  signal read_address2 : unsigned(4 downto 0);
begin
  root_proc: process(clock) is
  begin
    if (clock'event and clock='1') then
      if we = '1' then
        mem(to_integer(unsigned(addressWrite))) <= writeData;
      end if;

      read_address1 <= unsigned(address1);
      read_address2 <= unsigned(address2);
    end if;
  end process root_proc;
    
  mem_proc: process(mem, read_address1, read_address2)
  begin
    case read_address1 is
      when "00000" => dataout1 <= std_logic_vector(to_signed(0, 32));
      when "UUUUU" => dataout1 <= std_logic_vector(to_signed(0, 32));
      when others => dataout1 <= mem(to_integer(read_address1));
    end case;

    case read_address2 is
      when "00000" => dataout2 <= std_logic_vector(to_signed(0, 32));
      when "UUUUU" => dataout2 <= std_logic_vector(to_signed(0, 32));
      when others => dataout2 <= mem(to_integer(read_address2));
    end case;
  end process mem_proc;
end RTL;
