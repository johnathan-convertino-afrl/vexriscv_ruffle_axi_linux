# create board base ips

set_msg_config -id "Common 17-55" -new_severity WARNING

#BD METHOD
create_bd_design "system_ps"
update_compile_order -fileset sources_1

ip_vlvn_version_check "xilinx.com:ip:clk_wiz:6.0"

# create a pll clock IP with a 100 MHz clock
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1
set_property CONFIG.PRIMITIVE MMCM [get_bd_cells clk_wiz_1]
set_property CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 100 [get_bd_cells clk_wiz_1]
set_property CONFIG.USE_LOCKED false [get_bd_cells clk_wiz_1]
set_property CONFIG.PRIM_IN_FREQ 100.000 [get_bd_cells clk_wiz_1]
set_property CONFIG.USE_RESET false [get_bd_cells clk_wiz_1]
set_property CONFIG.CLKOUT2_USED {true} [get_bd_cells clk_wiz_1]
set_property CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} [get_bd_cells clk_wiz_1]

ip_vlvn_version_check "xilinx.com:ip:proc_sys_reset:5.0"

# create a system reset
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen
set_property CONFIG.RESET_BOARD_INTERFACE Custom [get_bd_cells sys_rstgen]
set_property CONFIG.C_EXT_RST_WIDTH 8 [get_bd_cells sys_rstgen]
set_property CONFIG.C_AUX_RST_WIDTH 8 [get_bd_cells sys_rstgen]
set_property CONFIG.C_EXT_RESET_HIGH 0 [get_bd_cells sys_rstgen]
set_property CONFIG.C_AUX_RESET_HIGH 1 [get_bd_cells sys_rstgen]

#create ddr reset
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr_rstgen

create_bd_cell -type module -reference Ruffle inst_ruffle
set_property CONFIG.POLARITY ACTIVE_LOW [get_bd_pins /inst_ruffle/io_arstn]

ip_vlvn_version_check "xilinx.com:ip:axi_uartlite:2.0"

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite
set_property CONFIG.C_BAUDRATE {115200} [get_bd_cells axi_uartlite]

ip_vlvn_version_check "xilinx.com:ip:axi_gpio:2.0"

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio

ip_vlvn_version_check "xilinx.com:ip:axi_quad_spi:3.2"

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_spi
set_property CONFIG.C_USE_STARTUP {0} [get_bd_cells axi_spi]

ip_vlvn_version_check "xilinx.com:ip:axi_ethernetlite:3.0"

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite

ip_vlvn_version_check "xilinx.com:ip:xlconcat:2.1"

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_concat
set_property CONFIG.IN0_WIDTH {3} [get_bd_cells irq_concat]
set_property CONFIG.NUM_PORTS {30} [get_bd_cells irq_concat]

ip_vlvn_version_check "xilinx.com:ip:mig_7series:4.2"

create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 axi_ddr_ctrl
set axi_ddr_cntrl_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name [get_bd_cells axi_ddr_ctrl]]]]
file copy -force ddr_mig.prj "$axi_ddr_cntrl_dir/"
set_property CONFIG.XML_INPUT_FILE ddr_mig.prj [get_bd_cells axi_ddr_ctrl]

ip_vlvn_version_check "xilinx.com:ip:xlconstant:1.1"

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property CONFIG.CONST_VAL {0} [get_bd_cells xlconstant_0]

ip_vlvn_version_check "xilinx.com:ip:axi_quad_spi:3.2"

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi
set_property CONFIG.C_SPI_MEMORY {3} [get_bd_cells axi_quad_spi]
set_property CONFIG.C_SPI_MODE {2} [get_bd_cells axi_quad_spi]
set_property CONFIG.C_USE_STARTUP {1} [get_bd_cells axi_quad_spi]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR
connect_bd_intf_net [get_bd_intf_pins axi_ddr_ctrl/DDR*] [get_bd_intf_ports DDR]

create_bd_port -dir I -type clk -freq_hz 100000000 sys_clk
connect_bd_net [get_bd_pins /clk_wiz_1/clk_in1] [get_bd_ports sys_clk]

create_bd_port -dir I -type clk -freq_hz 100000000 s_axi_dma_aclk
connect_bd_net [get_bd_pins /inst_ruffle/io_s_axi_dma_aclk] [get_bd_ports s_axi_dma_aclk]

create_bd_port -dir O -type clk s_axi_clk
connect_bd_net [get_bd_pins /clk_wiz_1/clk_out1] [get_bd_ports s_axi_clk]

create_bd_port -dir I -type rst sys_rstn
connect_bd_net [get_bd_pins /sys_rstgen/ext_reset_in] [get_bd_ports sys_rstn]

create_bd_port -dir I -type rst io_s_axi_dma_arstn
connect_bd_net [get_bd_pins /inst_ruffle/io_s_axi_dma_arstn] [get_bd_ports io_s_axi_dma_arstn]

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dma
set_property -dict [list CONFIG.HAS_BURST [get_property CONFIG.HAS_BURST [get_bd_intf_pins inst_ruffle/s_axi_dma]] CONFIG.HAS_LOCK [get_property CONFIG.HAS_LOCK [get_bd_intf_pins inst_ruffle/s_axi_dma]] CONFIG.HAS_QOS [get_property CONFIG.HAS_QOS [get_bd_intf_pins inst_ruffle/s_axi_dma]] CONFIG.HAS_REGION [get_property CONFIG.HAS_REGION [get_bd_intf_pins inst_ruffle/s_axi_dma]] CONFIG.HAS_BRESP [get_property CONFIG.HAS_BRESP [get_bd_intf_pins inst_ruffle/s_axi_dma]] CONFIG.HAS_RRESP [get_property CONFIG.HAS_RRESP [get_bd_intf_pins inst_ruffle/s_axi_dma]] CONFIG.NUM_READ_OUTSTANDING [get_property CONFIG.NUM_READ_OUTSTANDING [get_bd_intf_pins inst_ruffle/s_axi_dma]] CONFIG.NUM_WRITE_OUTSTANDING [get_property CONFIG.NUM_WRITE_OUTSTANDING [get_bd_intf_pins inst_ruffle/s_axi_dma]]] [get_bd_intf_ports s_axi_dma]
connect_bd_intf_net [get_bd_intf_pins inst_ruffle/s_axi_dma] [get_bd_intf_ports s_axi_dma]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART
connect_bd_intf_net [get_bd_intf_pins axi_uartlite/UART] [get_bd_intf_ports UART]

create_bd_port -dir I -from 31 -to 0 gpio_io_i
connect_bd_net [get_bd_pins /axi_gpio/gpio_io_i] [get_bd_ports gpio_io_i]

create_bd_port -dir O -from 31 -to 0 gpio_io_o
connect_bd_net [get_bd_pins /axi_gpio/gpio_io_o] [get_bd_ports gpio_io_o]

create_bd_port -dir O -from 31 -to 0 gpio_io_t
connect_bd_net [get_bd_pins /axi_gpio/gpio_io_t] [get_bd_ports gpio_io_t]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mii_rtl:1.0 MII
connect_bd_intf_net [get_bd_intf_pins axi_ethernetlite/MII] [get_bd_intf_ports MII]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 MDIO
connect_bd_intf_net [get_bd_intf_pins axi_ethernetlite/MDIO] [get_bd_intf_ports MDIO]

create_bd_port -dir I spi_io0_i
connect_bd_net [get_bd_pins /axi_spi/io0_i] [get_bd_ports spi_io0_i]

create_bd_port -dir O spi_io0_o
connect_bd_net [get_bd_pins /axi_spi/io0_o] [get_bd_ports spi_io0_o]

create_bd_port -dir O spi_io0_t
connect_bd_net [get_bd_pins /axi_spi/io0_t] [get_bd_ports spi_io0_t]

create_bd_port -dir I spi_io1_i
connect_bd_net [get_bd_pins /axi_spi/io1_i] [get_bd_ports spi_io1_i]

create_bd_port -dir O spi_io1_o
connect_bd_net [get_bd_pins /axi_spi/io1_o] [get_bd_ports spi_io1_o]

create_bd_port -dir O spi_io1_t
connect_bd_net [get_bd_pins /axi_spi/io1_t] [get_bd_ports spi_io1_t]

create_bd_port -dir I spi_sck_i
connect_bd_net [get_bd_pins /axi_spi/sck_i] [get_bd_ports spi_sck_i]

create_bd_port -dir O spi_sck_o
connect_bd_net [get_bd_pins /axi_spi/sck_o] [get_bd_ports spi_sck_o]

create_bd_port -dir O spi_sck_t
connect_bd_net [get_bd_pins /axi_spi/sck_t] [get_bd_ports spi_sck_t]

create_bd_port -dir I -from 0 -to 0 spi_ss_i
connect_bd_net [get_bd_pins /axi_spi/ss_i] [get_bd_ports spi_ss_i]

create_bd_port -dir O -from 0 -to 0 spi_ss_o
connect_bd_net [get_bd_pins /axi_spi/ss_o] [get_bd_ports spi_ss_o]

create_bd_port -dir O spi_ss_t
connect_bd_net [get_bd_pins /axi_spi/ss_t] [get_bd_ports spi_ss_t]

connect_bd_net [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins sys_rstgen/slowest_sync_clk]

connect_bd_net [get_bd_pins inst_ruffle/io_arstn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net [get_bd_pins inst_ruffle/io_aclk] [get_bd_pins clk_wiz_1/clk_out1]

connect_bd_net [get_bd_pins axi_uartlite/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1]
connect_bd_net [get_bd_pins axi_uartlite/s_axi_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_intf_net [get_bd_intf_pins axi_uartlite/S_AXI] [get_bd_intf_pins inst_ruffle/m_axi_uart]

connect_bd_net [get_bd_pins axi_gpio/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1]
connect_bd_net [get_bd_pins axi_gpio/s_axi_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_intf_net [get_bd_intf_pins axi_gpio/S_AXI] [get_bd_intf_pins inst_ruffle/m_axi_gpio]

connect_bd_net [get_bd_pins axi_spi/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1]
connect_bd_net [get_bd_pins axi_spi/s_axi_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net [get_bd_pins axi_spi/ext_spi_clk] [get_bd_pins clk_wiz_1/clk_out1]
connect_bd_intf_net [get_bd_intf_pins axi_spi/AXI_LITE] [get_bd_intf_pins inst_ruffle/m_axi_spi]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
set_property CONFIG.PROTOCOL AXI4LITE [get_bd_intf_ports /M_AXI]
connect_bd_intf_net [get_bd_intf_ports M_AXI] [get_bd_intf_pins inst_ruffle/m_axi_acc]

connect_bd_net [get_bd_pins axi_ethernetlite/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1]
connect_bd_net [get_bd_pins axi_ethernetlite/s_axi_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_intf_net [get_bd_intf_pins axi_ethernetlite/S_AXI] [get_bd_intf_pins inst_ruffle/m_axi_eth]

connect_bd_net [get_bd_pins axi_quad_spi/ext_spi_clk] [get_bd_pins clk_wiz_1/clk_out1]
# create_bd_intf_port -mode Master -vlnv xilinx.com:display_startup_io:startup_io_rtl:1.0 QSPI_STARTUP_IO
# connect_bd_intf_net [get_bd_intf_pins axi_quad_spi/STARTUP_IO] [get_bd_intf_ports QSPI_STARTUP_IO]
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 QSPI_0
connect_bd_intf_net [get_bd_intf_pins axi_quad_spi/SPI_0] [get_bd_intf_ports QSPI_0]
connect_bd_net [get_bd_pins axi_quad_spi/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1]
connect_bd_net [get_bd_pins axi_quad_spi/s_axi_aresetn] [get_bd_pins sys_rstgen/interconnect_aresetn]
connect_bd_net [get_bd_pins axi_quad_spi/ip2intc_irpt] [get_bd_pins irq_concat/In4]
connect_bd_intf_net [get_bd_intf_pins axi_quad_spi/AXI_LITE] [get_bd_intf_pins inst_ruffle/m_axi_qspi]

create_bd_port -dir I -from 2 -to 0 -type intr IRQ_F2P
connect_bd_net [get_bd_ports IRQ_F2P] [get_bd_pins irq_concat/In0]

connect_bd_net [get_bd_pins axi_uartlite/interrupt] [get_bd_pins irq_concat/In1]
connect_bd_net [get_bd_pins axi_ethernetlite/ip2intc_irpt] [get_bd_pins irq_concat/In2]
connect_bd_net [get_bd_pins axi_spi/ip2intc_irpt] [get_bd_pins irq_concat/In3]

connect_bd_net [get_bd_pins irq_concat/In29] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In28] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In27] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In26] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In25] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In24] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In23] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In22] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In21] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In20] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In19] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In18] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In17] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In16] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In15] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In14] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In13] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In12] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In11] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In10] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In9]  [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In8]  [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In7]  [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In6]  [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins irq_concat/In5]  [get_bd_pins xlconstant_0/dout]

connect_bd_net [get_bd_pins irq_concat/dout] [get_bd_pins inst_ruffle/io_irq]

# set_property CONFIG.ASSOCIATED_BUSIF {S_AXI} [get_bd_ports /s_axi_clk]
set_property CONFIG.ASSOCIATED_BUSIF {S_AXI:M_AXI} [get_bd_ports /s_axi_clk]

connect_bd_net [get_bd_pins axi_ddr_ctrl/ui_clk_sync_rst] [get_bd_pins sys_rstgen/aux_reset_in]
connect_bd_net [get_bd_pins axi_ddr_ctrl/mmcm_locked] [get_bd_pins sys_rstgen/dcm_locked]
connect_bd_net [get_bd_pins clk_wiz_1/clk_out2] [get_bd_pins axi_ddr_ctrl/sys_clk_i]
connect_bd_net [get_bd_ports sys_rstn] [get_bd_pins axi_ddr_ctrl/sys_rst]
connect_bd_intf_net [get_bd_intf_pins axi_ddr_ctrl/S_AXI] [get_bd_intf_pins inst_ruffle/m_axi_mbus]

connect_bd_net [get_bd_pins axi_ddr_ctrl/ui_clk] [get_bd_pins ddr_rstgen/slowest_sync_clk]
connect_bd_net [get_bd_pins ddr_rstgen/peripheral_aresetn] [get_bd_pins axi_ddr_ctrl/aresetn]
connect_bd_net [get_bd_pins axi_ddr_ctrl/mmcm_locked] [get_bd_pins ddr_rstgen/dcm_locked]
connect_bd_net [get_bd_ports sys_rstn] [get_bd_pins ddr_rstgen/ext_reset_in]
connect_bd_net [get_bd_pins ddr_rstgen/aux_reset_in] [get_bd_pins axi_ddr_ctrl/ui_clk_sync_rst]

connect_bd_net [get_bd_pins inst_ruffle/io_ddr_clk] [get_bd_pins axi_ddr_ctrl/ui_clk]


# assign_bd_address
# exclude_bd_addr_seg [get_bd_addr_segs axi_ddr_ctrl/memmap/memaddr] -target_address_space [get_bd_addr_spaces inst_ruffle_axi_bscane/m_axi_ibus]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_axi_ethernetlite_Reg]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_axi_gpio_Reg]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_axi_spi_Reg]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_axi_uartlite_Reg]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_inst_ruffle_axi_bscane_reg0]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_inst_ruffle_axi_bscane_reg0_1]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_M_AXI_Reg]
# exclude_bd_addr_seg [get_bd_addr_segs inst_ruffle_axi_bscane/m_axi_ibus/SEG_axi_quad_spi_Reg]

set_property CONFIG.CLK_DOMAIN /clk_wiz_1_clk_out1 [get_bd_intf_pins /inst_ruffle/m_axi_*]

set_property CONFIG.CLK_DOMAIN system_ps_axi_ddr_ctrl_0_ui_clk [get_bd_intf_pins /inst_ruffle/m_axi_mbus]

set_property CONFIG.CLK_DOMAIN system_ps_s_axi_dma_aclk [get_bd_intf_pins /inst_ruffle/s_axi_dma]

set_property CONFIG.ASSOCIATED_BUSIF {s_axi_dma} [get_bd_ports /s_axi_dma_aclk]

set_property CONFIG.ASSOCIATED_BUSIF {M_AXI} [get_bd_ports /s_axi_clk]

regenerate_bd_layout

save_bd_design

make_wrapper -files [get_files system_ps.bd] -top -import -fileset sources_1

set_property synth_checkpoint_mode None [get_files system_ps.bd]

update_compile_order -fileset sources_1
