library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_components is
  component Control is
    port (
      opcode: in std_logic_vector(6 downto 0);
      branch: out std_logic;
      memRead: out std_logic;
      memReg: out std_logic;
      ULAOp: out std_logic_vector(1 downto 0);
      ULASrc: out std_logic;
      memWrite: out std_logic;
      regWrite: out std_logic
    );
  end component Control;

  component MD is
    port (
      clock : in std_logic;
      we : in std_logic;
      address : in std_logic_vector(7 downto 0);
      datain : in std_logic_vector(31 downto 0);
      dataout : out std_logic_vector(31 downto 0)
    );
  end component MD;

  component MI is
    port (
      clock : in std_logic;
      address : in std_logic_vector;
      dataout : out std_logic_vector (31 downto 0)
    );
  end component MI;

  component MUX_2_to_1 is
    port (
      datain0 : in std_logic_vector;
      datain1 : in std_logic_vector;
      selector : in std_logic;
      dataout : out std_logic_vector
    );
  end component MUX_2_to_1;

  component PC is
    port (
      clock: in std_logic;
      we: in std_logic;
      datain: in std_logic_vector(31 downto 0);
      dataout: out std_logic_vector(31 downto 0)
    );
  end component PC;
  
  component SUM is
    port (
      datain0 : in std_logic_vector;
      datain1 : in std_logic_vector;
      dataout : out std_logic_vector
    );
  end component SUM;
  
  component ULA is
    generic (WSIZE : natural := 32);
    port (
      opcode : in std_logic_vector(3 downto 0);
      A, B : in std_logic_vector(WSIZE-1 downto 0);
      Z : out std_logic_vector(WSIZE-1 downto 0);
      zero : out std_logic
    );
  end component ULA;

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
  end component XREG;

  component GenImm32 is
    port (
      instr : in std_logic_vector(31 downto 0);
      imm32 : out std_logic_vector(31 downto 0)
    );
  end component GenImm32;

end package riscv_components;
