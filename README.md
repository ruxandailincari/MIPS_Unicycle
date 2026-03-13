# MIPS Processor (Single-Cycle Implementation)
A complete 32-bit MIPS processor implemented in VHDL using a Single-Cycle Architecture. This project demonstrates the fundamental principles of computer architecture, including the Fetch, Decode, Execute, Memory and Write-Back stages, all executed within a single clock cycle.

## Overview
This implementation executes a custom assembly program that processes an array of numbers (transforming odd numbers to even and summing those divisible by 4). The design focuses on clarity and correctness, ensuring that every instruction completes in exactly one clock cycle, determined by the critical path in the datapath.

## Key Features
- Single-Cycle Datapath: All instructions (R-type, I-type, J-type) execute in one clock cycle
- Custom Assembly Program: Implements a specific algorithm for array manipulation
- Real-Time Debugging: Integrated 7-segment display and LED indicators for visualizing output data
- Modular Design: Separated components for IF, ID, EX, MEM, and WB stages

## Technologies Used
- Language: VHDL
- Tools: Vivado

## Architecture Components
- IF (Instruction Fetch): Program Counter (PC) and Instruction Memory (ROM)
- ID (Instruction Decode): Register File and Control Unit
- EX (Execute): ALU
- MEM (Memory): Data Memory (RAM) for Load/Store operations
- WB (Write Back): Multiplexer to write results back to the Register File
