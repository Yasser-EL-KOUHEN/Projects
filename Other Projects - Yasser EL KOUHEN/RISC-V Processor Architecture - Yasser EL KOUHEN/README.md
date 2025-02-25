# RISC-V Pipelined Processor and Cache Implementation

## Project Overview
This project explores the architecture of a pipelined RISC-V processor, its hazard management, and the implementation of an instruction cache. It is divided into three practical sessions (TDs):

1. **TD1: Study of the Pipelined RISC-V Processor**
2. **TD2: Dependency Management and Multiplication Program Correction**
3. **TD3: Implementation of an Instruction Cache**

The implementation includes SystemVerilog files for the processor core, memory hierarchy, and cache mechanisms. The project also includes a detailed report explaining the methodology, analysis, and results of each TD.

## Repository Structure

```
.
├── TD1
│   ├── RV32i_monocycle_controlpath.sv
│   ├── RV32i_pipeline_top.sv
│   ├── RV32i_soc.sv
│   ├── Report (see root folder)
│   └── README (this file)
│
├── TD2
│   ├── Dependency Management
│   ├── Hazard Handling Implementation
│   ├── Forwarding Mechanism
│   └── Stall Management
│
├── TD3
│   ├── Cache Implementation
│   │   ├── direct_cache.S
│   │   ├── direct_cache.sv
│   │   ├── two_way_cache.sv
│   │   ├── wsync_mem_o128.sv
│   │   ├── cache_template.sv
│   │   ├── build.sh
│   │   └── README (this file)
│
├── Documentation
│   ├── Rapport Architecture des Processeurs II - Yasser EL KOUHEN.pdf
│   └── Additional Resources
```

## Description of Each Practical Session

### TD1: Study of the Pipelined RISC-V Processor
- Analysis of the processor's SoC architecture.
- Study of the pipeline structure (IF, ID, EX, MEM, WB stages).
- Memory hierarchy and interface exploration.
- Hazard detection and resolution.
- Simulations using ModelSim.

### TD2: Dependency Management and Multiplication Program Correction
- Identification of pipeline hazards (RAW, control hazards, structural hazards).
- Implementation of software-based solutions (NOP insertion).
- Implementation of hardware-based solutions (stall and forwarding mechanisms).
- Modification of `stall_w` equation to optimize hazard management.

### TD3: Implementation of an Instruction Cache
- Implementation of a direct-mapped instruction cache.
- Extension to a two-way associative cache with LRU replacement.
- Validation using SystemVerilog testbenches.
- Analysis of cache hit/miss behavior.

## How to Run the Project

### Prerequisites
- ModelSim or any compatible SystemVerilog simulator.
- RISC-V GCC toolchain.
- Bash shell (for `build.sh` script execution).

### Simulation
To simulate the project:
```bash
source build.sh
vsim -do "run -all"
```

### Compilation
For the RISC-V assembly programs:
```bash
riscv32-unknown-elf-gcc -o program.elf program.S
riscv32-unknown-elf-objdump -D program.elf > program.dump
```

## Report
A detailed report (`Rapport Architecture des Processeurs II - Yasser EL KOUHEN.pdf`) is included in the `Documentation` folder, covering all analyses, implementation details, and results.

## Authors
- **Yasser EL KOUHEN**
- Mines Saint-Etienne, ISMIN 2A

For any questions, feel free to reach out.

