# uart-dft-atpg

# Scan-Based Design-for-Testability and ATPG Implementation for a UART Transmitter

This project implements a UART (Universal Asynchronous Receiver Transmitter) Transmitter with integrated scan-based Design-for-Testability (DFT) features using Verilog HDL. It leverages industry-standard EDA tools including ModelSim, Synopsys Design Compiler, and TetraMAX for simulation, synthesis, and test pattern generation.

## 📌 Project Highlights

- ✅ RTL design of a UART Transmitter in Verilog HDL.
- 🔁 Scan flip-flop integration to enable full scan chain for DFT.
- ⚙️ Synthesis using Synopsys Design Compiler (both scan and non-scan versions).
- 🧪 ATPG & test coverage analysis using Synopsys TetraMAX.
- 🧼 Gate-level simulation and waveform analysis using ModelSim.
- 📊 Fault coverage achieved: **82.16%** using scan-based ATPG.

## 📁 Folder Structure

```
/project-root
│
├── uart_tx.v                  # RTL design without scan
├── uart_tx_tb.v              # Testbench for original UART
├── uart_tx_scan.v           # RTL design with scan flip-flops
├── uart_tx_scan_tb.v       # Testbench for scan UART
├── scan_dff.v                # Custom scan flip-flop module
├── netlists/                 # Gate-level netlists for both designs
├── synthesis_reports/        # Area, timing, power reports
├── modelsim_waveforms/       # Simulation results and wave screenshots
├── patterns/                 # STIL test patterns from TetraMAX
└── README.md
```

## 🧪 Tools Used

| Tool             | Purpose                                      |
|------------------|----------------------------------------------|
| ModelSim         | RTL and gate-level simulation                |
| Synopsys DC      | RTL synthesis and report generation          |
| Synopsys TetraMAX| ATPG, scan insertion validation, fault coverage |
| Apporto Lab      | Cloud-based virtual lab environment          |

## 🔄 Design Flow

1. **RTL Design**: UART modeled with FSM, shift register, and counters.
2. **Functional Simulation**: RTL verification using ModelSim.
3. **Synthesis**: Netlist generation and performance analysis via Design Compiler.
4. **Scan Insertion**: Manual replacement of sequential elements with scan DFFs.
5. **ATPG & Coverage**: Test pattern generation and analysis using TetraMAX.

## ✅ Results

- **Area**: Improved efficiency in scan design
- **Power**: Reduced dynamic power in scan version
- **Timing**: Better critical path timing with scan
- **Testability**: 82.16% fault coverage with 0 aborted faults

## 📈 Future Work

- Multi-scan chain compression for faster testing
- Secure scan chain encryption
- FPGA deployment using Quartus/Vivado
- Built-In Self-Test (BIST) integration

## 👩‍💻 Author

**Bindu Sree Chandu**  
ECE-242: Digital Systems Testing and Testable Design  
California State University, Fresno  
*May 2025*

## 📄 References

- [Synopsys Design Compiler User Guide](https://www.synopsys.com/)
- [Synopsys TetraMAX ATPG Tool Docs](https://www.synopsys.com/)
- [ModelSim User Manual](https://www.mentor.com/)
