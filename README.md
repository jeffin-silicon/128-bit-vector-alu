# 128-bit-vector-alu
128-bit Vector/SIMD ALU with four parallel 32-bit lanes, developed in SystemVerilog and taken through a complete 45nm RTL-to-GDSII ASIC flow using Cadence Genus, Innovus, and Conformal.
# 128-bit Vector/SIMD ALU

A 128-bit Vector/SIMD Arithmetic Logic Unit designed in SystemVerilog and taken through a complete ASIC RTL-to-GDSII implementation flow using industry-standard EDA tools.

The architecture is organized as **four parallel 32-bit SIMD lanes**, enabling independent operations across the 128-bit datapath. The design was synthesized and physically implemented in a **45 nm standard-cell technology**.

---

## Project Overview

This project demonstrates an end-to-end digital ASIC implementation flow, starting from synthesizable RTL and progressing through logic synthesis, equivalence checking, floorplanning, placement, clock-tree synthesis, routing, physical verification, timing/power analysis, and final GDSII stream-out.

### Key Specifications

| Parameter               | Value                   |
| ----------------------- | ----------------------- |
| Architecture            | 128-bit Vector/SIMD ALU |
| SIMD Organization       | 4 × 32-bit lanes        |
| RTL                     | SystemVerilog           |
| Technology              | 45 nm                   |
| Synthesis               | Cadence Genus           |
| Physical Design         | Cadence Innovus         |
| RTL/Formal Verification | Conformal LEC           |
| Front-end Processing    | Verific                 |
| Final Layout            | GDSII                   |

---

## Architecture

The 128-bit datapath is divided into four independent 32-bit SIMD lanes:

```text
                  128-bit Vector ALU
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
      ┌────────┐     ┌────────┐     ┌────────┐
      │ Lane 0 │     │ Lane 1 │ ... │ Lane 3 │
      │ 32-bit │     │ 32-bit │     │ 32-bit │
      └────────┘     └────────┘     └────────┘
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                  128-bit Result
```

Each 32-bit lane can perform the corresponding ALU operation in parallel, providing SIMD-style datapath processing.

---

## ASIC Implementation Flow

The complete implementation follows the standard ASIC design flow:

```text
SystemVerilog RTL
       │
       ▼
   RTL Analysis
    / Verific
       │
       ▼
   Logic Synthesis
    / Genus
       │
       ▼
   Formal Equivalence
    / Conformal
       │
       ▼
    Floorplanning
       │
       ▼
     Placement
       │
       ▼
 Clock Tree Synthesis
       │
       ▼
      Routing
       │
       ▼
Physical Verification
       │
       ├── DRC
       ├── Connectivity
       └── Antenna
       │
       ▼
Post-Layout Analysis
       │
       ├── Timing
       └── Power
       │
       ▼
     GDSII
```

---

## Implementation Results

The design successfully completed physical implementation with the following post-layout results.

### Timing

| Metric                     |        Result |
| -------------------------- | ------------: |
| Setup WNS                  | **+1.780 ns** |
| Setup TNS                  |      **0 ns** |
| Failing Endpoints          |         **0** |
| Max Transition Violations  |         **0** |
| Max Capacitance Violations |         **0** |
| Max Fanout Violations      |         **0** |

The positive post-layout setup WNS of **+1.780 ns** indicates that the reported setup timing requirement was met with positive timing margin.

---

### Power

| Metric                  |         Result |
| ----------------------- | -------------: |
| Total Post-Layout Power | **≈ 0.400 mW** |

---

### Physical Verification

| Check                                  |            Result |
| -------------------------------------- | ----------------: |
| DRC Violations                         |             **0** |
| Connectivity Violations                |             **0** |
| Connectivity Warnings                  |             **0** |
| Antenna Violations                     |             **0** |
| Horizontal Early Global Route Overflow |         **0.00%** |
| Vertical Early Global Route Overflow   |         **0.00%** |
| Normalized Congestion Hotspot          | **None reported** |

---

### Formal Equivalence

**Conformal LEC Compare Result: PASS**

The implemented design successfully passed the reported formal equivalence comparison.

---

## Key Project Highlights

* **128-bit Vector/SIMD ALU** implemented using four parallel **32-bit SIMD lanes**.
* Complete **RTL-to-GDSII ASIC implementation flow**.
* **45 nm standard-cell technology** implementation.
* **+1.780 ns post-layout setup WNS** with **TNS = 0 ns**.
* **Zero failing timing endpoints**.
* Zero reported **max-transition, max-capacitance, and max-fanout violations**.
* Approximately **0.400 mW total post-layout power**.
* **Zero DRC violations**.
* **Zero connectivity violations and warnings**.
* **Zero antenna violations**.
* **0.00% horizontal and vertical early-global-route overflow**.
* No normalized congestion hotspot reported.
* **Conformal LEC: PASS**.
* Successful **GDSII stream-out**.

---

## Tools & Technologies

### RTL / Front-End

* SystemVerilog
* Verific

### Logic Synthesis

* Cadence Genus

### Physical Design

* Cadence Innovus
* Floorplanning
* Placement
* Clock Tree Synthesis
* Routing

### Verification

* Cadence Conformal LEC
* DRC
* Connectivity verification
* Antenna verification
* Post-layout timing analysis
* Post-layout power analysis

### Technology

* 45 nm standard-cell technology

---

## Repository Structure

```text
128-bit-vector-alu/
│
├── README.md
├── LICENSE
│
├── rtl/
│   └── ...
│
├── verification/
│   └── ...
│
├── synthesis/
│   ├── genus.tcl
│   ├── constraints/
│   └── reports/
│
├── pnr/
│   ├── innovus.tcl
│   └── reports/
│
├── lec/
│   └── ...
│
├── results/
│   ├── timing/
│   ├── area/
│   ├── power/
│   ├── drc/
│   └── connectivity/
│
└── docs/
    ├── architecture.png
    ├── synthesis.png
    ├── floorplan.png
    ├── placement.png
    ├── routing.png
    └── gdsii.png
```

---

## Project Objective

The objective of this project is to demonstrate the design and implementation of a **128-bit SIMD datapath at the ASIC level**, with emphasis on synthesizable RTL, timing closure, physical implementation, verification, and final layout generation.

Rather than stopping at RTL simulation, the design was taken through the complete implementation flow up to **GDSII stream-out**.

---

## Final Status

**RTL → Synthesis → LEC → Floorplan → Placement → CTS → Routing → Physical Verification → Post-Layout Analysis → GDSII**

### **Implementation Status: COMPLETE**

**Timing:** PASS
**Power:** ~0.400 mW
**DRC:** 0 violations
**Connectivity:** 0 violations
**Antenna:** 0 violations
**LEC:** PASS
**GDSII:** Successfully generated

---

## Author

**Jeffin**

128-bit Vector/SIMD ALU — ASIC Design & Physical Implementation
