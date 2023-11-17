library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SingleCycleCPU is
port(clk :in STD_LOGIC;
     rst :in STD_LOGIC;
     --Probe ports used for testing
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end SingleCycleCPU;


architecture structural of singleCycleCPU is
     -- AND2
     signal and2_in0, and2_in1     : std_logic;
     signal and2_output       : std_logic;
     -- mux5
     signal mux5_in0, mux5_in1     : std_logic_vector(4 downto 0);
     signal mux5_sel :   std_logic;
     signal mux5_out : std_logic_vector(4 downto 0);
     -- mux64_1
     signal mux64_in0, mux64_in1     : std_logic_vector(63 downto 0);
     signal mux64_sel :   std_logic;
     signal mux64_out : std_logic_vector(63 downto 0);
     -- mux64_2
     signal mux642_in0, mux642_in1     : std_logic_vector(63 downto 0);
     signal mux642_sel :   std_logic;
     signal mux642_out : std_logic_vector(63 downto 0);
     -- mux64_3
     signal mux643_in0, mux643_in1     : std_logic_vector(63 downto 0);
     signal mux643_sel :   std_logic;
     signal mux643_out : std_logic_vector(63 downto 0);
     -- sign extend
     signal se_x  : std_logic_vector(31 downto 0);
     signal se_y  : std_logic_vector(63 downto 0);
     -- shift left <<2
     signal sl2_x, sl2_y : std_logic_vector(63 downto 0);
     -- pc use the clk and reset of this component
     signal pc_en   : std_logic;
     signal AddressIn    : std_logic_vector(63 downto 0);
     signal AddressOut   : std_logic_vector(63 downto 0);
     -- add
     signal add1_in0, add1_in1, add1_out     : std_logic_vector(63 downto 0);
     signal add2_in0, add2_in1, add2_out     : std_logic_vector(63 downto 0);
     -- alu
     signal alu_in0, alu_in1  : std_logic_vector(63 downto 0);
     signal alu_op  : std_logic_vector(3 downto 0);
     signal alu_result  : std_logic_vector(63 downto 0);
     signal zero    : std_logic;
     signal overflow : std_logic;
     signal not_zero    : std_logic;
     -- alu control
     signal aluControl_aluOp : std_logic_vector(1 downto 0);
     signal aluControl_opcode : std_logic_vector(10 downto 0);
     signal aluControl_operation : std_logic_vector(3 downto 0);
     -- cpu control
     signal cpuControl_opcode : std_logic_vector(10 downto 0);
     signal cpuControl_reg2loc     : std_logic;
     signal cpuControl_CBranch     : std_logic;
     signal cpuControl_memRead     : std_logic;
     signal cpuControl_memtoReg    : std_logic;
     signal cpuControl_memWrite    : std_logic;
     signal cpuControl_ALUsrc      : std_logic;
     signal cpuControl_regWrite    : std_logic;
     signal cpuControl_UBranch     : std_logic;
     signal cpuControl_ALUOp       : std_logic_vector(1 downto 0);
     -- imem
     signal imem_address  : std_logic_vector(63 downto 0);
     signal imem_readData : std_logic_vector(31 downto 0);
     -- dmem
     signal dmem_writeData    : std_logic_vector(63 downto 0);
     signal dmem_address      : std_logic_vector(63 downto 0);
     signal dmem_memRead      : std_logic;
     signal dmem_memWrite     : std_logic;
     signal dmem_clk          : std_logic;
     signal dmem_readData     : std_logic_vector(63 downto 0);
     signal dmem_debug_mem_contents     : std_logic_vector(64*4 - 1 downto 0);
     -- registers
     signal registers_rr1     : std_logic_vector(4 downto 0);
     signal registers_rr2     : std_logic_vector(4 downto 0);
     signal registers_wr      : std_logic_vector(4 downto 0);
     signal registers_wd      : std_logic_vector(63 downto 0);
     signal registers_regWrite : std_logic;
     signal registers_clk     : std_logic; 
     signal registers_rd1     : std_logic_vector(63 downto 0);
     signal registers_rd2     : std_logic_vector(63 downto 0);
     signal registers_debug_tmp_regs    : std_logic_vector(64 * 4 - 1 downto 0);
     signal registers_debug_saved_regs    : std_logic_vector(64 * 4 - 1 downto 0);
     
     component AND2 is
          port (
               in0    : in  STD_LOGIC;
               in1    : in  STD_LOGIC;
               output : out STD_LOGIC -- in0 and in1
          );
     end component;

     component MUX5 is
          port(
               in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
               in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
               sel    : in STD_LOGIC; -- selects in0 or in1
               output : out STD_LOGIC_VECTOR(4 downto 0)
          );
     end component;
     
     component MUX64 is
          port(
               in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
               in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
               sel    : in STD_LOGIC; -- selects in0 or in1
               output : out STD_LOGIC_VECTOR(63 downto 0)
          );
     end component;

     component SignExtend is 
          port(
               x : in  STD_LOGIC_VECTOR(31 downto 0);
               y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
          );
     end component;

     component ShiftLeft2 is 
          port(
               x : in  STD_LOGIC_VECTOR(63 downto 0);
               y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
          );
     end component;

     component PC is 
          port(
               clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
               write_enable : in  STD_LOGIC; -- Only write if '1'
               rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
               AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
               AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
          );
     end component;

     component ADD is 
               port(
                    in0    : in  STD_LOGIC_VECTOR(63 downto 0);
                    in1    : in  STD_LOGIC_VECTOR(63 downto 0);
                    output : out STD_LOGIC_VECTOR(63 downto 0)
               );
          end component;

          component ALU is 
               port(
                    in0       : in     STD_LOGIC_VECTOR(63 downto 0);
                    in1       : in     STD_LOGIC_VECTOR(63 downto 0);
                    operation : in     STD_LOGIC_VECTOR(3 downto 0);
                    result    : buffer STD_LOGIC_VECTOR(63 downto 0);
                    zero      : buffer STD_LOGIC;
                    overflow  : buffer STD_LOGIC
              );
          end component;

          component ALUControl is 
               port(
                    ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
                    Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
                    Operation : out STD_LOGIC_VECTOR(3 downto 0)
               );
          end component;

          component CPUControl is
               port(
                    Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
                    Reg2Loc   : out STD_LOGIC;
                    CBranch  : out STD_LOGIC;  --conditional
                    MemRead  : out STD_LOGIC;
                    MemtoReg : out STD_LOGIC;
                    MemWrite : out STD_LOGIC;
                    ALUSrc   : out STD_LOGIC;
                    RegWrite : out STD_LOGIC;
                    UBranch  : out STD_LOGIC; -- This is unconditional 
                    ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
               );
          end component;

          component IMEM is 
               port(
                    Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
                    ReadData : out STD_LOGIC_VECTOR(31 downto 0)
               );
          end component;

          component DMEM is 
               port(
                    WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
                    Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
                    MemRead            : in  STD_LOGIC; -- Indicates a read operation
                    MemWrite           : in  STD_LOGIC; -- Indicates a write operation
                    Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
                    ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
                    --Probe ports used for testing
                    -- Four 64-bit words: DMEM(0) & DMEM(4) & DMEM(8) & DMEM(12)
                    DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
               );
          end component;

          component registers is 
               port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); -- read 1
                    RR2      : in  STD_LOGIC_VECTOR (4 downto 0); -- read 2
                    WR       : in  STD_LOGIC_VECTOR (4 downto 0); -- write
                    WD       : in  STD_LOGIC_VECTOR (63 downto 0);-- write data
                    RegWrite : in  STD_LOGIC;                     -- write enable
                    Clock    : in  STD_LOGIC;                     -- clock; check if write on each clock cycle
                    RD1      : out STD_LOGIC_VECTOR (63 downto 0);-- read 1 data
                    RD2      : out STD_LOGIC_VECTOR (63 downto 0);-- read 2 data
                    --Probe ports used for testing.
                    -- Notice the width of the port means that you are
                    --      reading only part of the register file.
                    -- This is only for debugging
                    -- You are debugging a sebset of registers here
                    -- Temp registers: $X9 & $X10 & X11 & X12
                    -- 4 refers to number of registers you are debugging
                    DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
                    -- Saved Registers X19 & $X20 & X21 & X22
                    DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
               );
          end component;

     begin
          -- stuff from lab1
          AND2_comp : AND2 port map(and2_in0, and2_in1, and2_output);
     	MUX5_comp : MUX5 port map(mux5_in0, mux5_in1, mux5_sel, mux5_out);

          -- need 3 of these
          MUX64_1 : MUX64 port map(mux64_in0, mux64_in1, mux64_sel, mux64_out);
          MUX64_2 : MUX64 port map(mux642_in0, mux642_in1, mux642_sel, mux642_out);
          MUX64_3 : MUX64 port map(mux643_in0, mux643_in1, mux643_sel, mux643_out);
          signExtend_comp :  SignExtend port map(se_x, se_y);
          shiftLeft_comp :  ShiftLeft2 port map(sl2_x, sl2_y);
          pc_comp   :  PC port map (clk, pc_en, rst, AddressIn, AddressOut);
     
          -- stuff from lab2
          add1 :  ADD port map(add1_in0, add1_in1, add1_out);
          add2 :  ADD port map(add1_in0, add2_in1, add2_out);
          alu_comp  :  ALU port map(alu_in0, alu_in1, alu_op, alu_result, zero, overflow);
          aluControl_comp :  ALUControl port map(aluControl_aluOp, aluControl_opcode, aluControl_operation);
          cpuControl_comp :  CPUControl port map(cpuControl_opcode, cpuControl_reg2loc, cpuControl_CBranch, cpuControl_memRead, cpuControl_memtoReg, cpuControl_memWrite, cpuControl_ALUsrc, cpuControl_regWrite, cpuControl_UBranch, cpuControl_ALUOp);
          imem_comp :  IMEM port map(imem_address, imem_readData);                             
          dmem_comp :  DMEM port map(dmem_writeData, dmem_address, dmem_memRead, dmem_memWrite, dmem_clk, dmem_readData, dmem_debug_mem_contents);
     
          registers_comp :  registers port map(registers_rr1, registers_rr2, registers_wr, registers_wd, registers_regWrite, registers_clk, registers_rd1, registers_rd2, registers_debug_tmp_regs, registers_debug_saved_regs);
          
          -- or just port map clk instead of dmem_clk and registers_clk
          dmem_clk <= clk;
     
          -- following the figure in the specification we connect the signals in the following way
          cpuControl_opcode <= imem_readData(31 downto 21);
          imem_address <= AddressOut;
     
          mux5_in0 <= imem_readData(20 downto 16);
          mux5_in1 <= imem_readData(4 downto 0);
          mux5_sel <= cpuControl_reg2loc;
     
     
          -- register file
          registers_rr1 <= imem_readData(9 downto 5);
          registers_rr2 <= mux5_out;
          registers_wr <= imem_readData(4 downto 0);
          registers_wd <= mux64_out;
          registers_regWrite <= cpuControl_regWrite;
          registers_clk <= clk;
     
          se_x <= imem_readData(31 downto 0);
     
          -- alu control
          aluControl_aluOp <= cpuControl_ALUOp;
          aluControl_opcode <= imem_readData(31 downto 21);
     
          -- alu (this uses mux642 or the mux before the alu)
          alu_in0 <= registers_rd1; 
          alu_in1 <= mux642_out;
          alu_op  <= aluControl_operation;
     
          -- mux642 (the one before the alu)
          mux642_in0 <= registers_rd2;
          mux642_in1 <= se_y;
          mux642_sel <= cpuControl_ALUsrc;
          
          -- dmem
          dmem_writeData <= registers_rd2;
          dmem_address <= alu_result;
          dmem_memRead <= cpuControl_memRead;
          dmem_memWrite <= cpuControl_memWrite;
          dmem_clk <= clk;
     
          -- mux64 (the first one from the output of dmem)
          mux64_in0 <= alu_result;
          mux64_in1 <= dmem_readData;
          mux64_sel <= cpuControl_memtoReg;
          
          -- add1 (the add for pc + 4)
          add1_in0 <= AddressOut;
          add1_in1 <= x"0000000000000004";
          
          -- add2 (the add for pc + 4 if there is branching)
          add2_in1 <= sl2_y;
     
          --pc + 4 stuff
          pc_en <= '1';
          AddressIn <= mux643_out;
     
          -- mux643 (the mux that feeds back to the pc)
          mux643_in0 <= add1_out;
          mux643_in1 <= add2_out;
          mux643_sel <= cpuControl_UBranch or (cpuControl_CBranch and zero);
     
          sl2_x <= se_y;
          
          DEBUG_PC <= addressOut;
          DEBUG_INSTRUCTION <= imem_readData;
          DEBUG_TMP_REGS <= registers_debug_tmp_regs;
          DEBUG_SAVED_REGS <= registers_debug_saved_regs;
          DEBUG_MEM_CONTENTS <= dmem_debug_mem_contents;
     
     
     
     end structural;
