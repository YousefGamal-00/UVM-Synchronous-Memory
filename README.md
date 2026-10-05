# Synchronous Memory: UVM Verification Environment

A parameterized synchronous memory (`MEM`) with a registered read-valid output, verified by a UVM testbench using constrained-random stimulus, a cycle-accurate scoreboard model, and functional + code coverage. The included reports show 100% functional and code coverage with zero mismatches over 100,000 random transactions.

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Design Under Test](#design-under-test)
- [UVM Testbench](#uvm-testbench)
- [Running the Simulation](#running-the-simulation)
- [Results](#results)
- [Author](#author)

---

## Overview

| Item | Details |
|---|---|
| DUT | `MEM`: synchronous write, synchronous read with valid flag |
| Parameters | `DEPTH`, `WIDTH` (testbench uses `DEPTH = 8`, `WIDTH = 16`) |
| Methodology | UVM (agent, scoreboard, coverage subscriber), constrained-random |
| Stimulus | 100,000 random transactions after an initial reset |
| Tool used | QuestaSim 2021.1 with UVM 1.1d |

---

## Repository Structure

The project is flat: design, testbench and generated reports sit in one directory.

```
.
├── Mem.sv              # DUT
├── MEM_if.sv           # Interface with driver / monitor clocking blocks
├── MEM_pkg.sv          # Package: NUM_TEST, DEPTH, WIDTH, VIF typedef, class includes
├── top.sv              # Testbench top: clock, DUT, interface, run_test
├── src_file.list       # Compile order: Mem.sv, MEM_if.sv, MEM_pkg.sv, top.sv
├── run.do              # Questa script: compile, simulate, coverage reports
│
├── seq_item.svh        # Transaction + randomization constraints
├── sequence.svh        # Reset item followed by NUM_TEST random items
├── sequencer.svh
├── driver.svh
├── monitor.svh
├── agent.svh
├── config_obj.svh      # Config object carrying the virtual interface
├── scoreboard.svh      # Reference model + checker
├── subscriber.svh      # Functional coverage (MEM_CVG)
├── env.svh
├── test.svh            # MEM_test
│
├── wave.do             # Waveform setup
├── transcript          # Simulation log
├── FC_cov_rprt.txt     # Functional coverage report
├── CC_SVA_cov_rprt.txt # Code coverage report (detailed)
├── Summary_Report.txt  # Combined coverage summary
└── MEM.ucdb            # Coverage database
```

---

## Design Under Test

`MEM` is a single-port synchronous memory.

| Signal | Dir | Description |
|---|---|---|
| `clk` | in | Clock |
| `rst` | in | **Active-low**, asynchronous reset |
| `wr_rd_n` | in | `1` = write, `0` = read |
| `Data_in[WIDTH-1:0]` | in | Write data |
| `Address[$clog2(DEPTH)-1:0]` | in | Memory address |
| `data_out[WIDTH-1:0]` | out | Registered read data |
| `Valid_out` | out | Registered; high when `data_out` holds fresh read data |

Behaviour:

- **Read** (`wr_rd_n = 0`): `data_out` and `Valid_out = 1` are registered on the next clock edge (one-cycle latency).
- **Write** (`wr_rd_n = 1`): the memory array is updated on the clock edge, `Valid_out` goes to `0`, and `data_out` keeps the value from the last read.
- **Reset**: clears the memory array, `data_out` and `Valid_out`.

---

## UVM Testbench

### Architecture

```
 MEM_test
   └── MEM_env
         ├── MEM_agent
         │     ├── sequencer ──► driver ──► MEM_if ──► DUT
         │     └── monitor  ◄── MEM_if
         │            │ (analysis port)
         ├────────────┼──► MEM_scoreboard
         └────────────┴──► MEM_CVG
```

`DEPTH`, `WIDTH` and `NUM_TEST` are defined once in `MEM_pkg.sv`; the interface type, DUT and all classes derive from those values so they cannot drift apart.

### Stimulus (`seq_item.svh`)

| Field | Distribution |
|---|---|
| `rst` | 95% deasserted, 5% asserted |
| `wr_rd_n` | 60% write, 40% read |
| `Address` | Corner-biased: address `0` and `DEPTH-1` weighted heavily, middle addresses less |
| `Data_in` | Includes explicit weight for all-zeros and all-ones, remainder random |

### Scoreboard

A transaction-level reference model mirrors the memory: reset clears the model, writes update it, reads return the stored word with `Valid_out_ref = 1`. Each monitored transaction is compared with `!==` on both `data_out` and `Valid_out`, so X/Z mismatches are caught. Totals are printed in the report phase.

### Functional Coverage (`MEM_CVG`)

- `wr_rd_cp`: WR, RD, and the four transitions (WR→RD, RD→WR, WR→WR, RD→RD)
- `address_cp`: first address, last address, each middle address
- `data_cp`: all-zeros, all-ones, others
- `rst_cp`: asserted / deasserted
- Crosses: `wr_rd × address`, `wr_rd × rst`

---

## Running the Simulation

> Prerequisites: QuestaSim (or another UVM-capable simulator; `run.do` uses Questa commands).

```bash
vsim -c -do run.do
```

`run.do` compiles with coverage enabled, runs the simulation, saves `MEM.ucdb`, and writes the three coverage reports (`FC_cov_rprt.txt`, `CC_SVA_cov_rprt.txt`, `Summary_Report.txt`). Verbosity is `UVM_LOW`; set `+UVM_VERBOSITY=UVM_HIGH` to see per-transaction monitor and scoreboard messages.

---

## Results

From the included `transcript` and coverage reports:

| Metric | Result |
|---|---|
| Scoreboard | 100,000 matches, 0 mismatches |
| UVM severity counts | 0 warnings, 0 errors, 0 fatals |
| Functional coverage | 100% (78 / 78 bins) |
| Branch coverage | 100% (6 / 6) |
| Statement coverage | 100% (9 / 9) |
| Toggle coverage | 100% (112 / 112) |

---

## Author

**Yousef Gamal**
