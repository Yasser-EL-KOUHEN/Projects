# ASCON128 Hardware Design Project

This project implements the ASCON128 encryption algorithm using hardware description language (SystemVerilog). The ASCON128 algorithm is optimized for lightweight cryptographic applications and focuses on the design and simulation of essential hardware components such as the Finite State Machine (FSM), permutation layers, counters, and XOR operations.

The project includes SystemVerilog files for each module, along with testbenches for each component. The goal is to design, simulate, and test the ASCON128 encryption algorithm's hardware implementation.

## Table of Contents

- [Introduction](#introduction)
- [Project Structure](#project-structure)
- [How to Navigate the Documents](#how-to-navigate-the-documents)
- [Key Files and Their Purpose](#key-files-and-their-purpose)
  - [Main Modules](#main-modules)
  - [Testbenches](#testbenches)
  - [Supporting Files](#supporting-files)
- [Simulation and Compilation](#simulation-and-compilation)
- [ASCON128 Encryption Algorithm](#ascon128-encryption-algorithm)

## Introduction

ASCON128 is a symmetric encryption algorithm designed for lightweight cryptographic applications, especially for devices with limited computational resources. The ASCON128 encryption process relies on a combination of permutation operations, XORing with key data, and state transformations. This project simulates the complete ASCON128 algorithm in hardware using SystemVerilog, with modules for the Finite State Machine (FSM), permutation, substitution layer, and more.

## Project Structure

### Directory Structure:
- **SRC/RTL**: Contains all the SystemVerilog RTL (Register Transfer Level) modules that make up the ASCON128 design.
- **SRC/BENCH**: Contains the testbenches for the individual modules.
- **LIB_RTL**: Contains the compiled versions of the RTL files.
- **LIB_BENCH**: Contains the compiled versions of the testbenches.
- **Documentation**: Contains the ASCON Hardware Design Report.

## How to Navigate the Documents

- **If you want to understand the project design**: Start by reading the [ASCON Hardware Design Report](./Documentation/ASCON%20Hardware%20Design%20Report%20-%20Yasser%20EL%20KOUHEN.pdf).
- **If you are looking for the source code**: Explore the `SRC/RTL` directory, which contains all the SystemVerilog modules.
- **If you need to test the implementation**: Use the testbenches found in `SRC/BENCH`, which are associated with each core module.
- **If you want to simulate the project**: Follow the [Simulation and Compilation](#simulation-and-compilation) steps below.

## Key Files and Their Purpose

### Main Modules
These are the primary SystemVerilog files implementing the core components of ASCON128:
- **`SRC/RTL/ascon_pack.sv`**: Defines constants and `type_state`, which is a 320-bit state used throughout the encryption process.
- **`SRC/RTL/ascon_sbox.sv`**: Implements the S-box for the substitution layer.
- **`SRC/RTL/ascon_top.sv`**: The top-level module integrating all components of the ASCON128 design.
- **`SRC/RTL/ascon_top_init.sv`**: Initialization module for the ASCON128 design.
- **`SRC/RTL/compteur_double_init.sv`**: A double counter used to track rounds during encryption.
- **`SRC/RTL/compteur_simple_init.sv`**: A simpler counter initialization module.
- **`SRC/RTL/constant_addition.sv`**: Implements the constant addition (XORing a round constant) as part of the encryption process.
- **`SRC/RTL/diffusion_lin.sv`**: Implements the linear diffusion operation.
- **`SRC/RTL/FSM.sv`**: The Finite State Machine (FSM) that controls the encryption process.
- **`SRC/RTL/FSM_init.sv`**: Initialization logic for the FSM module.

### Testbenches
Each of these testbenches simulates and verifies a specific module:
- **`SRC/BENCH/ascon_sbox_tb.sv`**: Testbench for the S-box (`ascon_sbox.sv`).
- **`SRC/BENCH/constant_addition_tb.sv`**: Testbench for the constant addition operation (`constant_addition.sv`).
- **`SRC/BENCH/diffusion_lin_tb.sv`**: Testbench for the linear diffusion operation (`diffusion_lin.sv`).
- **`SRC/BENCH/substitution_layer_tb.sv`**: Testbench for the substitution layer (`substitution_layer.sv`).
- **`SRC/BENCH/permutation_xor_tb.sv`**: Testbench for the permutation and XOR operations (`permutation_xor.sv`).
- **`SRC/BENCH/ascon_top_tb.sv`**: Testbench for the top-level ASCON module (`ascon_top.sv`).

### Supporting Files
- **`init_modelsim.txt`**: Used to configure ModelSim for compiling and simulating the design.
- **`compile.txt`**: A script that compiles the necessary modules and starts the simulation process.

## Simulation and Compilation

### Steps to Set Up the Simulation:
1. **Set up your environment** by running:
   ```bash
   source init_modelsim.txt
   ```

2. **Compile the modules** by running:
   ```bash
   source compile.txt
   ```

3. **Run the simulation**:
   - After compilation, simulate specific modules by modifying the `compile.txt` file.
   - Inside ModelSim, select signals you want to analyze by adding them to the waveform viewer using `Ctrl + W`.

4. **View simulation results**:
   - Check waveforms and debug by adding relevant signals to the waveform viewer.

5. **Test each module** using the corresponding testbench to ensure it works as expected.

## ASCON128 Encryption Algorithm

ASCON128 is a block cipher that operates on a 320-bit state and employs a series of transformations:
- **Permutation**: The state is permuted through multiple rounds using XOR operations and the application of the S-box.
- **Substitution Layer**: The S-box is applied to each 5-bit column of the state.
- **Linear Diffusion**: Ensures that changes in the state propagate across the entire block.
- **XOR Operations**: Data is XORed with constants or keys during encryption.

The ASCON128 design is modular, and the encryption steps are controlled by the FSM, which orchestrates the operations based on the round and block counters.

