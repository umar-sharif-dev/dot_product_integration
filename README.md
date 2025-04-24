# dot_product_integration

# Dot Product Engine (DPE) – Pipelined FPGA Implementation

## Overview
This repository contains a scalable and pipelined implementation of a Dot Product Engine (DPE) on FPGA, designed for high-throughput vector dot products. It supports 64-element INT8 × FP32 multiplications followed by FP32 accumulation using a tree of pipelined floating-point adders.

---

## 📁 Files

| File Name                        | Description                               |
|----------------------------------|-------------------------------------------|
| `dot_product_engine_v3.v`        | Top-level DPE module                      |
| `dotpe_controller.v`             | FSM-based controller for sequencing       |
| `int8_to_fp32_rom_hardcoded.sv`  | Lookup-based INT8 to FP32 converter (ROM) |
| `regn.sv`                        | Generic register with enable/reset        |
| `tb_dotpe.v`                     | SystemVerilog testbench                   |
| `Dot Product Engine (DPE) - v3.pdf` | Detailed architecture documentation    |

---

## ✅ Features
- **Fully Pipelined**: Latency = `log2(N) + 1` for `N=64`
- **DSP48 Usage**: Up to 64 multipliers and 63 adders (depends on optimization)
- **ROM-based INT8 → FP32 Conversion**: Optional for resource savings
- **Testbench Provided**: Cycle-accurate verification with random inputs

---

## 📊 Target FPGA
- Board: **AX7325B**
- Device: **Xilinx Kintex-7 XC7K325T**
- DSP Available: 840  
- BRAM Available: 445 blocks (18Kb each)

---

## 🚀 TODOs (Phase II)
- [ ] Functional Simulation using Vivado Simulator
- [ ] Test Vector Generation for Co-simulation
- [ ] DSP Optimization Analysis & Reporting
- [ ] Integration with DDR + DMA Interface
- [ ] Controller Update for DDR Flow Control
- [ ] GitHub Release & Documentation Finalization

---

## 👨‍💻 Contributors
- Malik Umar Sharif
- Farhan (Testbench & Integration)
- Younas (Technical Support)
- Usman (Project Management)

---
