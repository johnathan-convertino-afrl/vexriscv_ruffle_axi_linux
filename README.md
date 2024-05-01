# Ruffle VexRiscv AXI FPGA Project
### Contains core files and scripts to generate a Ruffle VexRiscv AXI bus platform using fusesoc.
---

   author: Jay Convertino

   date: 2024.04.01

   details: Generate Vexriscv FPGA image for various targets. See fusesoc section for targets available.

   license: MIT

---

### Version
#### Current
  - none

#### Previous
  - none

### Dependencies
#### Build
  - AFRL:utility:digilent_nexys-a7-100t_board_base_ddr_cfg:1.0.0
  - AFRL:utility:digilent_nexys-a7-100t_board_base_constr:1.0.0
  - AD:ethernet:util_mii_to_rmii:1.0.0
  - spinalhdl:cpu:ruffle_axi_bscane:1.0.0
  - AFRL:utility:helper:1.0.0
  - AFRL:utility:tcl_helper_check:1.0.0

#### Simulation
  - none, not implimented.

### COMPONENTS
#### common/xilinx
  - system_gen_vexriscv.tcl

#### nexys-a7-100t:
  - system_constr.xdc
  - system_gen_ps.tcl
  - system_wrapper.v

### fusesoc

* fusesoc_info.core created.
* Simulation not available

#### TARGETS

* RUN WITH: (fusesoc run --target=nexys-a7-100t AFRL:project:ruffle_axi_linux:1.0.0)
* -- target can be one of the below.
  - nexys-a7-100t : Build for nexys-a7-100t digilent development board.
  - default       : Default target, do not use.

