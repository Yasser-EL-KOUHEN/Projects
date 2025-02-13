package RV32i_pkg;

  // RV32I Instruction format
  // Register instructions (R)
  //___________________________________________________________________________
  // | 31   -   25 | 24  -  20 | 19  -  15 | 14  -  12 | 11   -   7 | 6  -  0 |
  //___________________________________________________________________________
  //     funct7         rs2         rs1       funct3         rd       opcode 
  //___________________________________________________________________________

  // Immediate instructions (I)
  //___________________________________________________________________________
  // | 31          -        20 | 19  -  15 | 14  -  12 | 11   -   7 | 6  -  0 |
  //___________________________________________________________________________
  //         Imm[11:0]            rs1       funct3           rd       opcode 
  //___________________________________________________________________________

  // Shift instructions (S)
  //___________________________________________________________________________
  // | 31   -   25 | 24  -  20 | 19  -  15 | 14  -  12 | 11   -   7 | 6  -  0 |
  //___________________________________________________________________________
  //   Imm[11:5]        rs2         rs1       funct3     Imm[4:0]     opcode 
  //___________________________________________________________________________

  // Branch instructions (B)
  //___________________________________________________________________________
  // | 31   -   25 | 24  -  20 | 19  -  15 | 14  -  12 | 11   -   7 | 6  -  0 |
  //___________________________________________________________________________
  //   Imm[12|10:5]     rs2         rs1       funct3     Imm[4:1|11]  opcode 
  //___________________________________________________________________________

  // Upper instructions (U)
  //___________________________________________________________________________
  // | 31                    -                      12 | 11   -   7 | 6  -  0 |
  //___________________________________________________________________________
  //                      Imm[31:12]                        rd        opcode 
  //___________________________________________________________________________

  // Jump instruction (J)
  //___________________________________________________________________________
  // | 31                    -                      12 | 11   -   7 | 6  -  0 |
  //___________________________________________________________________________
  //                 Imm[20|10:1|11|19:12]                  rd        opcode 
  //___________________________________________________________________________







  // RV32I opcodes
  // R instruction opcode
  const logic [6 : 0] RV32I_R_INSTR = 7'b0110011;

  // I instruction opcode
  const logic [6 : 0] RV32I_I_INSTR_JALR = 7'b1100111;
  const logic [6 : 0] RV32I_I_INSTR_LOAD = 7'b0000011;
  const logic [6 : 0] RV32I_I_INSTR_OPER = 7'b0010011;
  const logic [6 : 0] RV32I_I_INSTR_FENCE = 7'b0001111;
  const logic [6 : 0] RV32I_I_INSTR_ENVCSR = 7'b1110011;

  // S instruction opcode
  const logic [6 : 0] RV32I_S_INSTR = 7'b0100011;

  // B instruction opcode
  const logic [6 : 0] RV32I_B_INSTR = 7'b1100011;

  // U instruction opcode
  const logic [6 : 0] RV32I_U_INSTR_LUI = 7'b0110111;
  const logic [6 : 0] RV32I_U_INSTR_AUIPC = 7'b0010111;

  // J instruction opcode
  const logic [6 : 0] RV32I_J_INSTR = 7'b1101111;

  // Funct7 instruction definition for R instructions
  const logic [6 : 0] RV32I_FUNCT7_ADD = 7'b0000000;
  const logic [6 : 0] RV32I_FUNCT7_SUB = 7'b0100000;
  const logic [6 : 0] RV32I_FUNCT7_SLL = 7'b0000000;
  const logic [6 : 0] RV32I_FUNCT7_SLT = 7'b0000000;
  const logic [6 : 0] RV32I_FUNCT7_SLTU = 7'b0000000;
  const logic [6 : 0] RV32I_FUNCT7_XOR = 7'b0000000;
  const logic [6 : 0] RV32I_FUNCT7_SRL = 7'b0000000;
  const logic [6 : 0] RV32I_FUNCT7_SRA = 7'b0100000;
  const logic [6 : 0] RV32I_FUNCT7_OR = 7'b0000000;
  const logic [6 : 0] RV32I_FUNCT7_AND = 7'b0000000;


  // ALU operations 
  const logic [1 : 0] ALU_OP_COPY = 2'b11;  // copy RS1 content to ALU output
  const logic [1 : 0] ALU_OP_FUNCT = 2'b10;  // operations depend on funct7
  const logic [1 : 0] ALU_OP_SUB = 2'b01;  // operation is subtraction 
  const
  logic [1 : 0]
  ALU_OP_ADD = 2'b00;  // compute address calculation (Store and Load instructions]

  // Immediat Extender
  const logic [2 : 0] IMM12_SIGEXTD_I = 3'b000;
  const logic [2 : 0] IMM12_SIGEXTD_S = 3'b001;
  const logic [2 : 0] IMM12_SIGEXTD_SB = 3'b010;
  const logic [2 : 0] IMM20_UNSIGN_U = 3'b011;
  const logic [2 : 0] IMM20_UNSIGN_UJ = 3'b100;


  // Funct3 instruction definitions for I, R instructions
  const logic [2 : 0] RV32I_FUNCT3_ADD = 3'b000;
  const logic [2 : 0] RV32I_FUNCT3_JALR = 3'b000;
  const logic [2 : 0] RV32I_FUNCT3_SUB = 3'b000;
  const logic [2 : 0] RV32I_FUNCT3_SLL = 3'b001;
  const logic [2 : 0] RV32I_FUNCT3_SLT = 3'b010;
  const logic [2 : 0] RV32I_FUNCT3_SLTU = 3'b011;
  const logic [2 : 0] RV32I_FUNCT3_XOR = 3'b100;
  const logic [2 : 0] RV32I_FUNCT3_SR = 3'b101;
  const logic [2 : 0] RV32I_FUNCT3_OR = 3'b110;
  const logic [2 : 0] RV32I_FUNCT3_AND = 3'b111;

  // Funct3 instruction definitions for B instructions
  const logic [2 : 0] RV32I_FUNCT3_BEQ = 3'b000;
  const logic [2 : 0] RV32I_FUNCT3_BNE = 3'b001;
  const logic [2 : 0] RV32I_FUNCT3_BLT = 3'b100;
  const logic [2 : 0] RV32I_FUNCT3_BGE = 3'b101;
  const logic [2 : 0] RV32I_FUNCT3_BLTU = 3'b110;
  const logic [2 : 0] RV32I_FUNCT3_BGEU = 3'b111;

  // Funct3 instruction definitions for LOAD/STORE instructions
  const logic [2 : 0] RV32I_FUNCT3_LS_BYTE = 3'b000;
  const logic [2 : 0] RV32I_FUNCT3_LS_HALFWORD = 3'b001;
  const logic [2 : 0] RV32I_FUNCT3_LS_WORD = 3'b010;
  const logic [2 : 0] RV32I_FUNCT3_LBU = 3'b100;
  const logic [2 : 0] RV32I_FUNCT3_LHU = 3'b101;

  // Funct3 instruction definitions for FENCE and CSR instructions
  const logic [2 : 0] RV32I_FUNCT3_ENV = 3'b000;
  const logic [2 : 0] RV32I_FUNCT3_FENCE = 3'b000;
  const logic [2 : 0] RV32I_FUNCT3_FENCE_I = 3'b001;
  const logic [2 : 0] RV32I_FUNCT3_CSRRW = 3'b001;
  const logic [2 : 0] RV32I_FUNCT3_CSRRS = 3'b010;
  const logic [2 : 0] RV32I_FUNCT3_CSRRC = 3'b011;
  const logic [2 : 0] RV32I_FUNCT3_CSRRWI = 3'b101;
  const logic [2 : 0] RV32I_FUNCT3_CSRRSI = 3'b110;
  const logic [2 : 0] RV32I_FUNCT3_CSRRCI = 3'b111;

  //ALU opcodes
  const logic [3 : 0] ALU_ADD = 4'h1;
  const logic [3 : 0] ALU_SUB = 4'h2;
  const logic [3 : 0] ALU_AND = 4'h3;
  const logic [3 : 0] ALU_XOR = 4'h4;
  const logic [3 : 0] ALU_OR = 4'h5;
  const logic [3 : 0] ALU_SLT = 4'h6;
  const logic [3 : 0] ALU_SLTU = 4'h7;
  const logic [3 : 0] ALU_SLLV = 4'h8;
  const logic [3 : 0] ALU_SRLV = 4'h9;
  const logic [3 : 0] ALU_SRAV = 4'hA;
  const logic [3 : 0] ALU_COPY_RS1 = 4'hB;
  const logic [3 : 0] ALU_X = 4'h0;

  // Alu operand1 selector
  const logic [1 : 0] SEL_OP1_RS1 = 2'b00;
  const logic [1 : 0] SEL_OP1_IMM = 2'b01;
  const logic [1 : 0] SEL_OP1_PC = 2'b10;
  const logic [1 : 0] SEL_OP1_X = 2'b11;


  // Alu operand2 selector
  const logic SEL_OP2_RS2 = 1'b0;
  const logic SEL_OP2_IMM = 1'b1;


  //WB selector
  const logic [1 : 0] SEL_WB_ALU = 2'b00;
  const logic [1 : 0] SEL_WB_MEM = 2'b01;
  const logic [1 : 0] SEL_WB_PC_PLUS_4  = 2'b10;

  // Alu/Mem/PC+4/CSR selector
  const logic [1 : 0] SEL_ALU_TO_REG = 2'b00;
  const logic [1 : 0] SEL_MEM_TO_REG = 2'b01;
  const logic [1 : 0] SEL_PC_PLUS4_TO_REG = 2'b10;
  const logic [1 : 0] SEL_CSR_TO_REG = 2'b11;

  // Branch selector
  const logic [2 : 0] SEL_PC_PLUS_4 = 3'b000; // PC += 4
  const logic [2 : 0] SEL_PC_JAL = 3'b001;    // PC += IMM
  const logic [2 : 0] SEL_PC_JALR = 3'b010;   // PC += RS1 + IMM ~ !0x1 (JALR instruction]
  const logic [2 : 0] SEL_PC_BRANCH = 3'b011; // PC += IMM
  const logic [2 : 0] SEL_PC_EXCEPTION = 3'b111;  // PC =  0x1C090000

  //WE
  const logic WE_0 = 1'b0;
  const logic WE_1 = 1'b1;

  //RE
  const logic RE_0 = 1'b0;
  const logic RE_1 = 1'b1;

endpackage
