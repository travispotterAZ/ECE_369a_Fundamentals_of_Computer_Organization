# ECE-369 Lab 7 — Pipelined MIPS Processor

A fully pipelined 32-bit MIPS processor implemented in Verilog, featuring a 5-stage pipeline with hazard detection, data forwarding stalls, branch resolution, and jump support. Synthesized for the Nexys4 DDR FPGA board.

---

## Overview

This project implements a classic 5-stage MIPS pipeline:

```
IF  →  ID  →  EX  →  MEM  →  WB
```

The processor supports a subset of the MIPS ISA including arithmetic, logical, memory, branch, and jump instructions. Hazards are handled by the `HazardUnit`, which issues stalls for load-use conflicts and flushes the pipeline on taken branches and jumps. Branch resolution is performed early in the ID stage to minimize branch penalty. Results are displayed in hexadecimal on the Nexys4's 8-digit 7-segment display — the left four digits show the current PC and the right four show the most recent write-back data.

---

## File Structure

```
ECE-369-Lab-7/
├── Top_Level_Datapath.v     # Top-level: wires all pipeline stages together
├── ProgramCounter.v         # PC register with stall (PCWrite) support
├── PCAdder.v                # PC + 4 adder
├── InstructionMemory.v      # 1K-word instruction memory (loaded from .mem)
├── IF_ID.v                  # IF/ID pipeline register
├── MainControl.v            # Instruction decode and control signal generation
├── RegisterFile.v           # 32 × 32-bit register file
├── SignExtension.v          # 16→32-bit sign/zero extender
├── BranchResolution.v       # Early branch condition evaluation (ID stage)
├── ID_EX.v                  # ID/EX pipeline register
├── ALU32Bit.v               # 32-bit ALU
├── EX_MEM.v                 # EX/MEM pipeline register
├── DataMemory.v             # 1K-word data memory with byte/half/word access
├── MEM_WB.v                 # MEM/WB pipeline register
├── HazardUnit.v             # Stall and flush control logic
├── Mux32Bit2To1.v           # Generic 32-bit 2-to-1 multiplexer
├── ClkDiv.v                 # 100 MHz → ~2.5 Hz clock divider
├── SevenSegment.v           # 4-bit to 7-segment decoder
├── Two4DigitDisplay.v       # 8-digit hex display multiplexer
├── TopLevel_tb.v            # Simulation testbench
├── InstructionMemory.mem    # MIPS machine code program
├── DataMemory.mem           # Initial data memory contents
└── Two4DigitDisplay.xdc     # FPGA pin constraints for Nexys4 DDR
```

---

## Supported Instructions

| Category | Instructions |
|----------|-------------|
| Arithmetic | `add`, `addi`, `sub`, `mul` |
| Logical | `and`, `andi`, `or`, `ori`, `xor`, `xori`, `nor` |
| Shift | `sll`, `srl` |
| Comparison | `slt`, `slti` |
| Memory | `lw`, `sw`, `lb`, `sb`, `lh`, `sh` |
| Branch | `beq`, `bne`, `bgtz`, `blez`, `bgez`, `bltz` |
| Jump | `j`, `jal`, `jr` |

---

## Pipeline Architecture

### Stage Modules

**IF — Instruction Fetch**
`ProgramCounter` holds the current PC. `PCAdder` computes PC+4. `InstructionMemory` outputs the instruction at the current PC. `IF_ID` latches both into the ID stage.

**ID — Instruction Decode**
`MainControl` decodes the instruction opcode and funct field to generate all control signals. `RegisterFile` reads up to two source registers. `SignExtension` extends the 16-bit immediate. `BranchResolution` evaluates the branch condition and computes the branch target entirely in the ID stage, reducing branch penalty to one cycle. `ID_EX` latches everything into the EX stage.

**EX — Execute**
Two `Mux32Bit2To1` instances select ALU inputs (handling `ALUSrc` for immediate operands and the `sll`/`srl` swap). `ALU32Bit` performs the operation. A third mux selects the write-back register (`Rt` vs `Rd`). `EX_MEM` latches results into the MEM stage.

**MEM — Memory Access**
`DataMemory` performs load or store operations with byte (`lb`/`sb`), halfword (`lh`/`sh`), and word (`lw`/`sw`) granularity using signed extension on reads. `MEM_WB` latches results into the WB stage.

**WB — Write Back**
A mux selects between memory read data and ALU result (`MemtoReg`). `jal` support: the final write register is forced to `$ra` (register 31) and the write data is set to PC+4 when `JumpLink` is active.

---

### Hazard Unit

`HazardUnit` handles three classes of control hazards:

| Condition | Action |
|-----------|--------|
| Load-use data hazard (`EX_MemRead` + register match) | Stall: freeze PC and IF/ID, flush ID/EX (insert bubble) |
| Branch taken or jump (`j`, `jal`) | Flush IF/ID |
| Jump-register (`jr`) | Flush IF/ID |

`ID_rs_Flag` and `ID_rt_Flag` from `MainControl` tell the hazard unit which source registers a given instruction actually uses, preventing false stalls.

---

### Branch Resolution

Branches are resolved in the **ID stage** using `BranchResolution`, which evaluates `beq`, `bne`, `bgtz`, `blez`, `bgez`, and `bltz` by comparing register values directly. This means a taken branch costs only **one flush cycle** (the instruction already fetched in IF is discarded).

---

## Display Output (Nexys4 DDR)

The 8-digit 7-segment display is split into two groups:

| Digits | Content |
|--------|---------|
| Left 4 (AN[7:4]) | Lower 16 bits of the current PC in the WB stage |
| Right 4 (AN[3:0]) | Lower 16 bits of the most recent write-back data |

All values are shown in hexadecimal. The display runs at ~95 Hz using the full 100 MHz clock, independent of the divided datapath clock.

---

## Clock

`ClkDiv` divides the 100 MHz board clock to ~2.5 Hz (`DivVal = 20000000`) so pipeline state changes are visible one step at a time on the display. For simulation the `DivVal` parameter can be reduced.

---

## How to Run

### Prerequisites
- Xilinx Vivado 2020.x or later
- Nexys4 DDR board (Artix-7)

### Simulation

1. Open Vivado and create a new project, adding all `.v` files as sources
2. Add `TopLevel_tb.v` as a simulation source
3. Ensure `InstructionMemory.mem` and `DataMemory.mem` are in the simulation working directory
4. Run Behavioral Simulation — the testbench holds reset for 20 ns then runs for 50 ms of simulated time

### Synthesis & Implementation

1. Add all `.v` files as design sources and `Two4DigitDisplay.xdc` as the constraint file
2. Set `Top_Level_Datapath` as the top module
3. Run Synthesis → Implementation → Generate Bitstream
4. Program the board via Vivado Hardware Manager

---

## Memory Files

Both `.mem` files use `$readmemh` hex format and are reloaded on reset.

- **`InstructionMemory.mem`** — contains the MIPS machine code program. Each line is one 32-bit instruction word in hex.
- **`DataMemory.mem`** — contains initial data values used by load instructions in the program.
