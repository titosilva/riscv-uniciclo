library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_components.all;

entity riscv is
  port (
    clock: in std_logic
  );
end riscv;

architecture RTL of riscv is
  signal PC_dataIn : std_logic_vector(31 downto 0);
  signal instrAddress : std_logic_vector(31 downto 0);
  signal instr : std_logic_vector(31 downto 0);
  signal branch: std_logic;
  signal memRead: std_logic;
  signal memReg: std_logic;
  signal ULAOp: std_logic_vector(1 downto 0);
  signal ULASrc: std_logic;
  signal memWrite: std_logic;
  signal regWrite: std_logic;
  signal regWriteData: std_logic_vector(31 downto 0);
  signal rs1: std_logic_vector(31 downto 0);
  signal rs2: std_logic_vector(31 downto 0);
  signal imm32: std_logic_vector(31 downto 0);
  signal ULADataIn0: std_logic_vector(31 downto 0);
  signal ULADataIn1: std_logic_vector(31 downto 0);
  signal ULACtr: std_logic_vector(3 downto 0);
  signal ULAResult: std_logic_vector(31 downto 0);
  signal ULAZero: std_logic;
  signal MDOut: std_logic_vector(31 downto 0);
  signal memRegOut: std_logic_vector(31 downto 0);
  signal PC_SUM_4Result: std_logic_vector(31 downto 0);
  signal PC_SUM_SHIFTResult: std_logic_vector(31 downto 0);
  signal branchAndULAZero: std_logic;
  signal imm32shifted: std_logic_vector(31 downto 0);
begin
  PC_i: PC port map(
    clock => clock,
    we => '1',
    datain => PC_dataIn,
    dataout => instrAddress
  );

  MI_i: MI port map(
    clock => clock,
    address => instrAddress(11 downto 0),
    dataout => instr
  );

  Control_i: Control port map (
    opcode => instr(6 downto 0),
    branch => branch,
    memRead => memRead,
    memReg => memReg,
    ULAOp => ULAOp,
    ULASrc => ULASrc,
    memWrite => memWrite,
    regWrite => regWrite
  );

  XREG_i: XREG port map (
    clock => clock,
    we => regWrite,
    address1 => instr(19 downto 15),
    address2 => instr(24 downto 20),
    addressWrite => instr(11 downto 7),
    writeData => regWriteData,
    dataout1 => rs1,
    dataout2 => rs2
  );
  ULADataIn0 <= rs1;

  GenImm32_i: GenImm32 port map (
    instr => instr,
    imm32 => imm32
  );

  MuxAluSrc: MUX_2_to_1 port map (
    datain0 => rs2,
    datain1 => imm32,
    selector => ULASrc,
    dataout => ULADataIn1
  );

  ULAControl_i: ULAControl port map ( 
    funct7 => instr(31 downto 25),
    funct3 => instr(14 downto 12),
    aluop => ULAOp,
    aluctr => ULACtr
  );

  ULA_i: ULA port map (
    opcode => ULACtr,
    A => ULADataIn0,
    B => ULADataIn1,
    Z => ULAResult,
    zero => ULAZero
  );

  MD_i: MD port map (
    clock => clock,
    we => memWrite,
    address => ULAResult,
    datain => rs2,
    dataout => MDOut
  );

  MuxMemToReg: MUX_2_to_1 port map (
    datain0 => ULAResult,
    datain1 => MDOut,
    selector => memReg,
    dataout => memRegOut
  );
  regWriteData <= memRegOut;

  PC_SUM_4: SUM port map (
    datain0 => instrAddress,
    datain1 => std_logic_vector(to_signed(4, 32)),
    dataout => PC_SUM_4Result
  );

  PC_SUM_SHIFT: SUM port map (
    datain0 => instrAddress,
    datain1 => imm32shifted,
    dataout => PC_SUM_SHIFTResult
  );

  branchAndULAZero <= branch and ULAZero;
  PC_MUX: MUX_2_to_1 port map (
    datain0 => PC_SUM_4Result,
    datain1 => PC_SUM_SHIFTResult,
    selector => branchAndULAZero,
    dataout => PC_dataIn
  );

  imm32shift_proc: process(imm32)
  begin
    imm32shifted <= std_logic_vector(shift_left(signed(imm32), 1));
  end process imm32shift_proc;
end RTL;
