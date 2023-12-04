library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity PipelinedCPU1 is
  port(
  clk :in std_logic;
  rst :in std_logic;
  --Probe ports used for testing
  -- Forwarding control signals
  DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
  DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
  --The current address (AddressOut from the PC)
  DEBUG_PC : out std_logic_vector(63 downto 0);
  --Value of PC.write_enable
  DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
  --The current instruction (Instruction output of IMEM)
  DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
  --DEBUG ports from other components
  DEBUG_TMP_REGS : out std_logic_vector(64*4-1 downto 0);
  DEBUG_SAVED_REGS : out std_logic_vector(64*4-1 downto 0);
  DEBUG_MEM_CONTENTS : out std_logic_vector(64*4-1 downto 0)
  );
  end PipelinedCPU1;
  


architecture structural of PipelinedCPU1 is
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
     
     --IF/ID
     signal IF_ID_pc_in     : std_logic_vector(63 downto 0);
     signal IF_ID_addr_in   : std_logic_vector(31 downto 0);
     signal IF_ID_Write     : std_logic;
      --------------------------------------------------
     signal IF_ID_pc_out    : std_logic_vector(63 downto 0);
     signal IF_ID_addr_out  : std_logic_vector(31 downto 0);
     ---------------------------------------------------
     --Not Portmapped, but used to specify elements Rn, Rm, and Rd
     signal IF_ID_registerRn : std_logic_vector(4 downto 0);
     signal IF_ID_registerRm : std_logic_vector(4 downto 0);
     signal IF_ID_registerRd : std_logic_vector(4 downto 0);

     --ID_EX
     signal ID_EX_regWrite_in   :  std_logic;
     signal ID_EX_memToReg_in   :  std_logic;
     signal ID_EX_Ubranch_in    :  std_logic;
     signal ID_EX_Branch_in     :  std_logic;
     signal ID_EX_memRead_in    :  std_logic;
     signal ID_EX_memWrite_in   :  std_logic;
     signal ID_EX_ALUOp_in      :  std_logic_vector(1 downto 0);
     signal ID_EX_ALUSrc_in     :  std_logic;
     signal ID_EX_pc_in         :  std_logic_vector(63 downto 0);
     signal ID_EX_rd1_in        :  std_logic_vector(63 downto 0);
     signal ID_EX_rd2_in        :  std_logic_vector(63 downto 0);
     signal ID_EX_se_in         :  std_logic_vector(63 downto 0);
     signal ID_EX_opcode_in     :  std_logic_vector(10 downto 0);
     signal ID_EX_RegisterRn_in :  std_logic_vector(4 downto 0);
     signal ID_EX_RegisterRm_in :  std_logic_vector(4 downto 0);
     signal ID_EX_RegisterRd_in :  std_logic_vector(4 downto 0);
     --------------------------------
     signal ID_EX_regWrite_out   :  std_logic;
     signal ID_EX_memToReg_out   :  std_logic;
     signal ID_EX_Ubranch_out    :  std_logic;
     signal ID_EX_Branch_out     :  std_logic;
     signal ID_EX_memRead_out    :  std_logic;
     signal ID_EX_memWrite_out   :  std_logic;
     signal ID_EX_ALUOp_out      :  std_logic_vector(1 downto 0);
     signal ID_EX_ALUSrc_out     :  std_logic;
     signal ID_EX_pc_out         :  std_logic_vector(63 downto 0);
     signal ID_EX_rd1_out        :  std_logic_vector(63 downto 0);
     signal ID_EX_rd2_out        :  std_logic_vector(63 downto 0);
     signal ID_EX_se_out         :  std_logic_vector(63 downto 0);
     signal ID_EX_opcode_out     :  std_logic_vector(10 downto 0);
     signal ID_EX_RegisterRn_out :  std_logic_vector(4 downto 0);
     signal ID_EX_RegisterRm_out :  std_logic_vector(4 downto 0);
     signal ID_EX_RegisterRd_out :  std_logic_vector(4 downto 0);

     --EX/MEM
     signal ex_mem_regwrite_in  :  std_logic;
     signal ex_mem_memtoreg_in  :  std_logic;     
     signal ex_mem_ubranch_in   :  std_logic;
     signal ex_mem_branch_in    :  std_logic;
     signal ex_mem_memread_in   :  std_logic;
     signal ex_mem_memwrite_in  :  std_logic;
     signal ex_mem_add2_in      :  std_logic_vector(63 downto 0);
     signal ex_mem_zero_in      :  std_logic;
     signal ex_mem_aluresult_in :  std_logic_vector(63 downto 0);
     signal ex_mem_id_ex_rd2_in :  std_logic_vector(63 downto 0);
     signal ex_mem_Rd_in        :  std_logic_vector(4 downto 0);
     ----------------------------------------------------
     signal ex_mem_regwrite_out  :  std_logic;
     signal ex_mem_memtoreg_out  :  std_logic;     
     signal ex_mem_ubranch_out   :  std_logic;
     signal ex_mem_branch_out    :  std_logic;
     signal ex_mem_memread_out   :  std_logic;
     signal ex_mem_memwrite_out  :  std_logic;
     signal ex_mem_add2_out      :  std_logic_vector(63 downto 0);
     signal ex_mem_zero_out      :  std_logic;
     signal ex_mem_aluresult_out :  std_logic_vector(63 downto 0);
     signal ex_mem_id_ex_rd2_out :  std_logic_vector(63 downto 0);
     signal ex_mem_Rd_out        :  std_logic_vector(4 downto 0);

     --MEM/WB
     signal mem_wb_regwrite_in          :  std_logic;
     signal mem_wb_memtoreg_in          :  std_logic;
     signal mem_wb_dmem_rd_in           :  std_logic_vector(63 downto 0);
     signal mem_wb_ex_mem_alu_result_in :  std_logic_vector(63 downto 0);
     signal mem_wb_Rd_in         :  std_logic_vector(4 downto 0);
     -----------------------------------------------------------
     signal mem_wb_regwrite_out          :  std_logic;
     signal mem_wb_memtoreg_out          :  std_logic;
     signal mem_wb_dmem_rd_out           :  std_logic_vector(63 downto 0);
     signal mem_wb_ex_mem_alu_result_out :  std_logic_vector(63 downto 0);
     signal mem_wb_Rd_out         :  std_logic_vector(4 downto 0);

     -- HDU
     signal HDU_ID_EX_memRead      : std_logic;
     signal HDU_ID_EX_registerRd   : std_logic_vector (4 downto 0);  
     signal HDU_IF_ID_registerRn1  : std_logic_vector (4 downto 0);   
     signal HDU_IF_ID_registerRm2  : std_logic_vector (4 downto 0);  
     -------------------------------------------------------------- 
     signal HDU_PCWrite_out        : std_logic;
     signal HDU_IF_ID_write_out    : std_logic;
     signal HDU_muxControl_out     : std_logic;
     
     -- forwarding Unit
     signal FU_EX_MEM_regWrite     : std_logic; 
     signal FU_EX_MEM_RegisterRd   : std_logic_vector(4 downto 0);   
     signal FU_ID_EX_RegisterRn1   : std_logic_vector(4 downto 0);   
     signal FU_ID_EX_RegisterRm2   : std_logic_vector(4 downto 0);   
     signal FU_MEM_WB_regWrite     : std_logic;
     signal FU_MEM_WB_RegisterRd   : std_logic_vector(4 downto 0); 
     -------------------------------------------------------  
     signal ForwardA        : std_logic_vector(1 downto 0);
     signal ForwardB        : std_logic_vector(1 downto 0);
     
     -- ALUMux1 -- mux2to3
     signal aluMux1_in0      : STD_LOGIC_VECTOR(63 downto 0);
     signal aluMux1_in1      : STD_LOGIC_VECTOR(63 downto 0);
     signal aluMux1_in2      : STD_LOGIC_VECTOR(63 downto 0);
     signal aluMux1_sel      : STD_LOGIC_VECTOR(1 downto 0);
     --------------------------------------------------------
     signal aluMux1_out      : STD_LOGIC_VECTOR(63 downto 0);

     -- ALUMux2 -- mux2to3
     signal aluMux2_in0      : STD_LOGIC_VECTOR(63 downto 0);
     signal aluMux2_in1      : STD_LOGIC_VECTOR(63 downto 0);
     signal aluMux2_in2      : STD_LOGIC_VECTOR(63 downto 0);
     signal aluMux2_sel      : STD_LOGIC_VECTOR(1 downto 0);
     --------------------------------------------------------
     signal aluMux2_out      : STD_LOGIC_VECTOR(63 downto 0);

     -- muxCPU
     signal mux_sel          : STD_LOGIC;  
     signal mux_CBranch_in   : STD_LOGIC;    
     signal mux_MemRead_in   : STD_LOGIC;    
     signal mux_MemtoReg_in  : STD_LOGIC;     
     signal mux_MemWrite_in  : STD_LOGIC;     
     signal mux_ALUSrc_in    : STD_LOGIC;   
     signal mux_RegWrite_in  : STD_LOGIC;     
     signal mux_UBranch_in   : STD_LOGIC;    
     signal mux_ALUOp_in     : STD_LOGIC_VECTOR(1 downto 0);  
     --------------------------------------------------------
     signal mux_CBranch_out  : STD_LOGIC;  
     signal mux_MemRead_out  : STD_LOGIC;
     signal mux_MemtoReg_out : STD_LOGIC;
     signal mux_MemWrite_out : STD_LOGIC;
     signal mux_ALUSrc_out   : STD_LOGIC;
     signal mux_RegWrite_out : STD_LOGIC;
     signal mux_UBranch_out  : STD_LOGIC;  
     signal mux_ALUOp_out    : STD_LOGIC_VECTOR(1 downto 0);


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
     component IF_ID is 
          port(
                --Inputs
                clk             : in std_logic;
                rst             : in std_logic;
                IF_ID_pc_in     : in std_logic_vector(63 downto 0);
                IF_ID_addr_in   : in std_logic_vector(31 downto 0);
                IF_ID_Write     : in std_logic;
                --Outputs
                IF_ID_pc_out    : out std_logic_vector(63 downto 0);
                IF_ID_addr_out  : out std_logic_vector(31 downto 0)
          );
     end component;
     component ID_EX is 
       port(
           --Inputs
           clk                    : in std_logic;
           rst                    : in std_logic;
           ID_EX_regWrite_in      : in std_logic;
           ID_EX_memToReg_in      : in std_logic;
           ID_EX_UBranch_in       : in std_logic;
           ID_EX_Branch_in        : in std_logic;
           ID_EX_memRead_in       : in std_logic;
           ID_EX_memWrite_in      : in std_logic;
           ID_EX_ALUOp_in         : in std_logic_vector(1 downto 0);
           ID_EX_ALUSrc_in        : in std_logic;
           ID_EX_pc_in            : in std_logic_vector(63 downto 0);
           ID_EX_rd1_in           : in std_logic_vector(63 downto 0);
           ID_EX_rd2_in           : in std_logic_vector(63 downto 0);
           ID_EX_se_in            : in std_logic_vector(63 downto 0);
           ID_EX_opcode_in        : in std_logic_vector(10 downto 0);
           ID_EX_RegisterRn_in    : in std_logic_vector(4 downto 0);
           ID_EX_RegisterRm_in    : in std_logic_vector(4 downto 0);
           ID_EX_RegisterRd_in    : in std_logic_vector(4 downto 0);
           --Outputs
           ID_EX_regWrite_out     : out std_logic;
           ID_EX_memToReg_out     : out std_logic;
           ID_EX_UBranch_out      : out std_logic;
           ID_EX_Branch_out       : out std_logic;
           ID_EX_memRead_out      : out std_logic;
           ID_EX_memWrite_out     : out std_logic;
           ID_EX_ALUOp_out        : out std_logic_vector(1 downto 0);
           ID_EX_ALUSrc_out       : out std_logic;
           ID_EX_pc_out           : out std_logic_vector(63 downto 0);
           ID_EX_rd1_out          : out std_logic_vector(63 downto 0);
           ID_EX_rd2_out          : out std_logic_vector(63 downto 0);
           ID_EX_se_out           : out std_logic_vector(63 downto 0);
           ID_EX_opcode_out       : out std_logic_vector(10 downto 0);
           ID_EX_RegisterRn_out   : out std_logic_vector(4 downto 0);
           ID_EX_RegisterRm_out   : out std_logic_vector(4 downto 0);
           ID_EX_RegisterRd_out   : out std_logic_vector(4 downto 0)
       );
     end component;
     component EX_MEM is 
       port(
         --Inputs
         clk                     : in std_logic;
         rst                     : in std_logic;
         EX_MEM_regWrite_in      : in std_logic;
         EX_MEM_memToReg_in      : in std_logic;
         EX_MEM_UBranch_in       : in std_logic;
         EX_MEM_Branch_in        : in std_logic;
         EX_MEM_memRead_in       : in std_logic;
         EX_MEM_memWrite_in      : in std_logic;
         EX_MEM_add2_in          : in std_logic_vector(63 downto 0);
         EX_MEM_zero_in          : in std_logic;
         EX_MEM_ALUResult_in     : in std_logic_vector(63 downto 0);
         EX_MEM_rd2_in           : in std_logic_vector(63 downto 0);
         EX_MEM_Rd_in            : in std_logic_vector(4 downto 0);
         --Outputs
         EX_MEM_regWrite_out      : out std_logic;
         EX_MEM_memToReg_out      : out std_logic;
         EX_MEM_UBranch_out       : out std_logic;
         EX_MEM_Branch_out        : out std_logic;
         EX_MEM_memRead_out       : out std_logic;
         EX_MEM_memWrite_out      : out std_logic;
         EX_MEM_add2_out          : out std_logic_vector(63 downto 0);
         EX_MEM_zero_out          : out std_logic;
         EX_MEM_ALUResult_out     : out std_logic_vector(63 downto 0);
         EX_MEM_rd2_out           : out std_logic_vector(63 downto 0);
         EX_MEM_Rd_out            : out std_logic_vector(4 downto 0)
     );
     end component;
     component MEM_WB is 
       port(
           --Inputs
           clk                     : in std_logic;
           rst                     : in std_logic;
           MEM_WB_regWrite_in      : in std_logic;
           MEM_WB_memToReg_in      : in std_logic;
           MEM_WB_DMEM_rd_in       : in std_logic_vector(63 downto 0);  
           MEM_WB_ALUResult_in     : in std_logic_vector(63 downto 0);
           MEM_WB_Rd_in            : in std_logic_vector(4 downto 0);
           --Outputs
           MEM_WB_regWrite_out      : out std_logic;
           MEM_WB_memToReg_out      : out std_logic;
           MEM_WB_DMEM_rd_out       : out std_logic_vector(63 downto 0);  
           MEM_WB_ALUResult_out     : out std_logic_vector(63 downto 0);
           MEM_WB_Rd_out            : out std_logic_vector(4 downto 0)
                 
       );
     end component;

     component mux2to3 is 
        port(
            in0    : in STD_LOGIC_VECTOR(63 downto 0); 
            in1    : in STD_LOGIC_VECTOR(63 downto 0); 
            in2    : in STD_LOGIC_VECTOR(63 downto 0); 
            sel    : in STD_LOGIC_VECTOR(1 downto 0); 
            output : out STD_LOGIC_VECTOR(63 downto 0)
        );
      end component;

      component muxCPU is
        port(
            
             sel         : in STD_LOGIC;
             CBranch_in  : in STD_LOGIC;  
             MemRead_in  : in STD_LOGIC;
             MemtoReg_in : in STD_LOGIC;
             MemWrite_in : in STD_LOGIC;
             ALUSrc_in   : in STD_LOGIC;
             RegWrite_in : in STD_LOGIC;
             UBranch_in  : in STD_LOGIC; 
             ALUOp_in    : in STD_LOGIC_VECTOR(1 downto 0);
             ----------------------------------------------
             CBranch_out  : out STD_LOGIC;  
             MemRead_out  : out STD_LOGIC;
             MemtoReg_out : out STD_LOGIC;
             MemWrite_out : out STD_LOGIC;
             ALUSrc_out   : out STD_LOGIC;
             RegWrite_out : out STD_LOGIC;
             UBranch_out  : out STD_LOGIC;  
             ALUOp_out    : out STD_LOGIC_VECTOR(1 downto 0)
        );
        end component;


        component hdu is
          port(
              ID_EX_memRead        : in std_logic;
              ID_EX_registerRd     : in std_logic_vector(4 downto 0); -- this is ID_EX_Rd_out  
              IF_ID_registerRn1    : in std_logic_vector(4 downto 0);
              IF_ID_registerRm2    : in std_logic_vector(4 downto 0);
              -------------------------------------------------------
              PCWrite     : out std_logic;
              IF_ID_write : out std_logic;
              muxControl  : out std_logic
          );
        end component;

        component forwardingUnit is
          port(
              EX_MEM_regWrite     : in std_logic;
              EX_MEM_RegisterRd   : in std_logic_vector(4 downto 0);
              ID_EX_RegisterRn1   : in std_logic_vector(4 downto 0);
              ID_EX_RegisterRm2   : in std_logic_vector(4 downto 0);
              MEM_WB_regWrite     : in std_logic;
              MEM_WB_RegisterRd   : in std_logic_vector(4 downto 0);
              ------------------------------------------------------
              forwardA            : out std_logic_vector(1 downto 0);
              forwardB            : out std_logic_vector(1 downto 0)
          );
        end component;

     begin
          -- stuff from lab1
          AND2_comp : AND2 port map(and2_in0, and2_in1, and2_output);
     	    MUX5_comp : MUX5 port map(mux5_in0, mux5_in1, mux5_sel, mux5_out);

          -- MUXs
          MUX64_1_comp : MUX64 port map(mux64_in0, mux64_in1, mux64_sel, mux64_out);
          MUX64_2_comp : MUX64 port map(mux642_in0, mux642_in1, mux642_sel, mux642_out);
          MUX64_3_comp : MUX64 port map(mux643_in0, mux643_in1, mux643_sel, mux643_out);

          -- SignExtend, ShiftLeft, PC
          signExtend_comp :  SignExtend port map(se_x, se_y);
          shiftLeft_comp :  ShiftLeft2 port map(sl2_x, sl2_y);
          pc_comp   :  PC port map (clk, pc_en, rst, AddressIn, AddressOut);
     
          -- stuff from lab2
          -- ADD, ALU, CPU, IMEM, DMEM
          add1_comp :  ADD port map(add1_in0, add1_in1, add1_out);
          add2_comp :  ADD port map(add1_in0, add2_in1, add2_out);
          alu_comp  :  ALU port map(alu_in0, alu_in1, alu_op, alu_result, zero, overflow);
          aluControl_comp :  ALUControl port map(aluControl_aluOp, aluControl_opcode, aluControl_operation);
          cpuControl_comp :  CPUControl port map(cpuControl_opcode, cpuControl_reg2loc, cpuControl_CBranch, cpuControl_memRead, cpuControl_memtoReg, cpuControl_memWrite, cpuControl_ALUsrc, cpuControl_regWrite, cpuControl_UBranch, cpuControl_ALUOp);
          imem_comp :  IMEM port map(imem_address, imem_readData);                             
          dmem_comp :  DMEM port map(dmem_writeData, dmem_address, dmem_memRead, dmem_memWrite, clk, dmem_readData, dmem_debug_mem_contents);

          -- Registers
          registers_comp :  registers port map(registers_rr1, registers_rr2, registers_wr, registers_wd, registers_regWrite, clk, registers_rd1, registers_rd2, registers_debug_tmp_regs, registers_debug_saved_regs);
          
          --IF/ID
          IF_ID_comp     : IF_ID port map(clk, rst, if_id_pc_in, if_id_addr_in, if_id_write, if_id_pc_out, if_id_addr_out);

          --ID/EX
          ID_EX_comp     : ID_EX port map(clk, rst, id_ex_regwrite_in, id_ex_memtoreg_in, id_ex_ubranch_in, id_ex_branch_in, id_ex_memread_in, id_ex_memwrite_in, id_ex_aluop_in,
                         id_ex_alusrc_in, id_ex_pc_in, id_ex_rd1_in, id_ex_rd2_in, id_ex_se_in, id_ex_opcode_in, ID_EX_RegisterRn_in, ID_EX_RegisterRm_in, ID_EX_RegisterRd_in, id_ex_regwrite_out, id_ex_memtoreg_out,
                         id_ex_ubranch_out, id_ex_branch_out, id_ex_memread_out, id_ex_memwrite_out, id_ex_aluop_out, id_ex_alusrc_out, id_ex_pc_out, id_ex_rd1_out, id_ex_rd2_out,
                         id_ex_se_out, id_ex_opcode_out, ID_EX_RegisterRn_out, ID_EX_RegisterRm_out, ID_EX_RegisterRd_out);
          --EX/MEM
          EX_MEM_comp    : EX_MEM port map(clk, rst, ex_mem_regwrite_in, ex_mem_memtoreg_in, ex_mem_ubranch_in, ex_mem_branch_in, ex_mem_memread_in, ex_mem_memwrite_in, ex_mem_add2_in,
                         ex_mem_zero_in, ex_mem_aluresult_in, ex_mem_id_ex_rd2_in, ex_mem_Rd_in, ex_mem_regwrite_out, ex_mem_memtoreg_out, ex_mem_ubranch_out, ex_mem_branch_out,
                         ex_mem_memread_out, ex_mem_memwrite_out, ex_mem_add2_out, ex_mem_zero_out, ex_mem_aluresult_out, ex_mem_id_ex_rd2_out, ex_mem_Rd_out);
          --Mem/WB 
          MEM_WB_comp    : MEM_WB port map(clk, rst, mem_wb_regwrite_in, mem_wb_memtoreg_in, mem_wb_dmem_rd_in, mem_wb_ex_mem_alu_result_in, mem_wb_Rd_in, mem_wb_regwrite_out,
                         mem_wb_memtoreg_out, mem_wb_dmem_rd_out, mem_wb_ex_mem_alu_result_out, mem_wb_Rd_out);

          -- New Lab 5 Items
          -- 2to3 MUXs
          mux2to3_1       : mux2to3 port map(aluMux1_in0, aluMux1_in1, aluMux1_in2, aluMux1_sel, aluMux1_out);
          mux2to3_2       : mux2to3 port map(aluMux2_in0, aluMux2_in1, aluMux2_in2, aluMux2_sel, aluMux2_out);

          -- HDU
          HDU_comp        : hdu port map (HDU_ID_EX_memRead, HDU_ID_EX_registerRd, HDU_IF_ID_registerRn1, HDU_IF_ID_registerRm2, 
                                          HDU_PCWrite_out, HDU_IF_ID_write_out, HDU_muxControl_out);

          -- FU
          forwarding_comp  : forwardingUnit port map(FU_EX_MEM_regWrite, FU_EX_MEM_RegisterRd, FU_ID_EX_RegisterRn1, FU_ID_EX_RegisterRm2, 
                                                    FU_MEM_WB_regWrite, FU_MEM_WB_RegisterRd, ForwardA, ForwardB);

          -- CPU MUX
          mux_cpu_comp     : muxCPU port map(mux_sel, mux_CBranch_in, mux_MemRead_in, mux_MemtoReg_in, mux_MemWrite_in, mux_ALUSrc_in, mux_RegWrite_in, mux_UBranch_in, mux_ALUOp_in,
                                           mux_CBranch_out, mux_MemRead_out, mux_MemtoReg_out, mux_MemWrite_out, mux_ALUSrc_out, mux_RegWrite_out, mux_UBranch_out, mux_ALUOp_out);

          -- NOT PORTMAPPED (USED TO SPECIFY Rn, Rm, Rd)
          IF_ID_registerRn  <= if_id_addr_out(9 downto 5);
          IF_ID_registerRm  <= if_id_addr_out(20 downto 16);
          IF_ID_registerRd  <= if_id_addr_out(4 downto 0);

           
          ----------------------------------------------------------------------
          -----------------              MUXs        ---------------------------
          ----------------------------------------------------------------------
          -- Mux b4 reg fie
          mux5_in0 <= IF_ID_registerRm;
          mux5_in1 <= IF_ID_registerRd;
          mux5_sel <= if_id_addr_out(28);

          -- mux64 (the first one from the output of dmem) = CHECK
          mux64_in0 <= mem_wb_ex_mem_alu_result_out;
          mux64_in1 <= mem_wb_dmem_rd_out;
          mux64_sel <= mem_wb_memtoreg_out;

          -- mux642 (the one before the alu) == CHECK 
          mux642_in0 <= aluMux2_out;
          mux642_in1 <= id_ex_se_out;
          mux642_sel <= id_ex_alusrc_out;
          
          -- mux643 (the mux that feeds back to the pc) = CHECK
          mux643_in0 <= add1_out;
          mux643_in1 <= ex_mem_add2_out;
          mux643_sel <= ex_mem_branch_out and ex_mem_zero_out; -- see diagram

          ----------------------------------------------------------------------
          --                   SignExtend, ShiftLeft, PC                      --
          ----------------------------------------------------------------------
          -- SignExtend
          se_x <= if_id_addr_out;
          -- ShiftLeft
          sl2_x <= id_ex_se_out;
          --pc + 4 stuff
          pc_en <= '1';
          AddressIn <= mux643_out;

          ----------------------------------------------------------------------
          --                   ADD, ALU, CPU, IMEM, DMEM                      --
          ----------------------------------------------------------------------
     
         -- alu control = CHECK
          aluControl_aluOp <= id_ex_aluop_out;
          aluControl_opcode <= id_ex_opcode_out;

          -- alu (this uses mux642 or the mux before the alu) = CHECK 
          alu_in0 <= aluMux1_out; 
          alu_in1 <= mux642_out;
          alu_op  <= aluControl_operation;

          -- dmem = CHECK
          dmem_writeData <= ex_mem_id_ex_rd2_out;
          dmem_address <= ex_mem_aluresult_out;
          dmem_memRead <= ex_mem_memread_out;
          dmem_memWrite <= ex_mem_memwrite_out;

          -- add1 (the add for pc + 4) = CHECK
          add1_in0 <= AddressOut;
          add1_in1 <= x"0000000000000004";

          -- add2 (the add for pc + 4 if there is branching) = CHECK
          add2_in0 <= id_ex_pc_out;
          add2_in1 <= sl2_y;

          -- CPU Control 
          cpuControl_opcode <= if_id_addr_out(31 downto 21);

          -- IMEM
          imem_address <= AddressOut;


          ----------------------------------------------------------------------
          --                           Registers                              --
          ----------------------------------------------------------------------
          -- register file
          registers_rr1 <= IF_ID_registerRn;
          registers_rr2 <= mux5_out;
          registers_wr <= mem_wb_Rd_out;
          registers_wd <= mux64_out;
          registers_regWrite <= mem_wb_regwrite_out;
     
          
          ----------------------------------------------------------------------
          --                             IF/ID                                --
          ----------------------------------------------------------------------

          -- the IF_ID register = CHECK
          if_id_pc_in     <= addressOut;
          if_id_addr_in   <= imem_readData; 
          if_id_write     <= HDU_IF_ID_write_out;

          ----------------------------------------------------------------------
          --                             ID/EX                                --
          ----------------------------------------------------------------------

          -- the ID_EX register = CHECK
          id_ex_regwrite_in   <= mux_RegWrite_out;
          id_ex_memtoreg_in   <= mux_MemtoReg_out;
          id_ex_ubranch_in    <= mux_UBranch_out;
          id_ex_branch_in     <= mux_CBranch_out;
          id_ex_memread_in    <= mux_MemRead_out;
          id_ex_memwrite_in   <= mux_MemWrite_out;
          id_ex_aluop_in      <= mux_ALUOp_out;
          id_ex_alusrc_in     <= mux_ALUSrc_out;
          id_ex_pc_in         <= if_id_pc_out;
          id_ex_rd1_in        <= registers_rd1;
          id_ex_rd2_in        <= registers_rd2;
          id_ex_se_in         <= se_y;
          id_ex_opcode_in     <= if_id_addr_out(31 downto 21); -- called opcode after this
          id_ex_RegisterRn_in <= IF_ID_registerRn;
          id_ex_RegisterRm_in <= IF_ID_registerRm;
          id_ex_RegisterRd_in <= IF_ID_registerRd; -- called Rd after this

          ----------------------------------------------------------------------
          --                            EX/MEM                                --
          ----------------------------------------------------------------------

          -- the EX/MEM register = CHECK
          ex_mem_regwrite_in      <= id_ex_regwrite_out;
          ex_mem_memtoreg_in      <= id_ex_memtoreg_out;
          ex_mem_ubranch_in       <= id_ex_ubranch_out;
          ex_mem_branch_in        <= id_ex_branch_out;
          ex_mem_memread_in       <= id_ex_memread_out;
          ex_mem_memwrite_in      <= id_ex_memwrite_out;
          ex_mem_add2_in          <= add2_out;
          ex_mem_zero_in          <= zero;
          ex_mem_aluresult_in     <= alu_result;
          ex_mem_id_ex_rd2_in     <= aluMux2_out;
          ex_mem_Rd_in      <= id_ex_RegisterRd_out;

          ----------------------------------------------------------------------
          --                           MEM/WB                                 --
          ----------------------------------------------------------------------

          -- the MEM_WB register = CHECK
          mem_wb_regwrite_in          <= ex_mem_regwrite_out;
          mem_wb_memtoreg_in          <= ex_mem_memtoreg_out;
          mem_wb_dmem_rd_in           <= dmem_readData;
          mem_wb_ex_mem_alu_result_in <= ex_mem_aluresult_out;
          mem_wb_Rd_in         <= ex_mem_Rd_out;

          ----------------------------------------------------------------------
          --                        2to3 MUXs                                 --
          ----------------------------------------------------------------------
          aluMux1_in0          <=  id_ex_rd1_out;
          aluMux1_in1          <=  mux64_out;
          aluMux1_in2          <=  ex_mem_aluresult_out;
          aluMux1_sel          <=  ForwardA;
          aluMux1_out          <=  aluMux1_out;

          aluMux2_in0          <=  id_ex_rd2_out;
          aluMux2_in1          <=  mux64_out;
          aluMux2_in2          <=  ex_mem_aluresult_out;
          aluMux2_sel          <=  ForwardB;
          aluMux2_out          <=  aluMux2_out;
          
          ----------------------------------------------------------------------
          --                           HDU                                    --
          ----------------------------------------------------------------------
          HDU_ID_EX_memRead       <=   id_ex_memread_out;
          HDU_ID_EX_registerRd    <=   id_ex_registerRd_out;   
          HDU_IF_ID_registerRn1   <=   IF_ID_registerRn;    
          HDU_IF_ID_registerRm2   <=   IF_ID_registerRm;     

          ----------------------------------------------------------------------
          --                            FU                                    --
          ----------------------------------------------------------------------
          FU_EX_MEM_regWrite      <=   ex_mem_regwrite_out; 
          FU_EX_MEM_RegisterRd    <=   ex_mem_Rd_out;   
          FU_ID_EX_RegisterRn1    <=   id_ex_registerRn_out;   
          FU_ID_EX_RegisterRm2    <=   id_ex_registerRm_out;   
          FU_MEM_WB_regWrite      <=   mem_wb_regwrite_out; 
          FU_MEM_WB_RegisterRd    <=   mem_wb_Rd_out;   

          ----------------------------------------------------------------------
          --                            CPUMux                                --
          ----------------------------------------------------------------------
          mux_sel                 <=   HDU_muxControl_out;
          mux_CBranch_in          <=   cpuControl_CBranch;       
          mux_MemRead_in          <=   cpuControl_memRead;       
          mux_MemtoReg_in         <=   cpuControl_memtoReg;        
          mux_MemWrite_in         <=   cpuControl_memWrite;        
          mux_ALUSrc_in           <=   cpuControl_ALUsrc;      
          mux_RegWrite_in         <=   cpuControl_regWrite;        
          mux_UBranch_in          <=   cpuControl_UBranch;       
          mux_ALUOp_in            <=   cpuControl_ALUOp;     

          -- DEBUGGING--
          DEBUG_FORWARDA <= ForwardA;
          DEBUG_FORWARDB <= ForwardB;
          DEBUG_PC_WRITE_ENABLE <= HDU_PCWrite_out;
          DEBUG_PC <= addressOut;
          DEBUG_INSTRUCTION <= imem_readData;
          DEBUG_TMP_REGS <= registers_debug_tmp_regs;
          DEBUG_SAVED_REGS <= registers_debug_saved_regs;
          DEBUG_MEM_CONTENTS <= dmem_debug_mem_contents;
     
     end structural;
     