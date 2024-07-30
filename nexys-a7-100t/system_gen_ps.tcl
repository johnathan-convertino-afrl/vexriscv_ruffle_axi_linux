
set_msg_config -id "Common 17-55" -new_severity WARNING

ip_vlvn_version_check "xilinx.com:ip:clk_wiz:6.0"

# create a pll clock IP with a 100 MHz clock
create_ip -vlnv xilinx.com:ip:clk_wiz:6.0 -module_name clk_wiz_1
set_property CONFIG.PRIMITIVE MMCM [get_ips clk_wiz_1]
set_property CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 100 [get_ips clk_wiz_1]
set_property CONFIG.USE_LOCKED false [get_ips clk_wiz_1]
set_property CONFIG.PRIM_IN_FREQ 100.000 [get_ips clk_wiz_1]
set_property CONFIG.USE_RESET false [get_ips clk_wiz_1]
set_property CONFIG.CLKOUT2_USED {true} [get_ips clk_wiz_1]
set_property CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} [get_ips clk_wiz_1]

set_property generate_synth_checkpoint false [get_files clk_wiz_1.xci]

ip_vlvn_version_check "xilinx.com:ip:proc_sys_reset:5.0"

# create a system reset
create_ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 -module_name sys_rstgen
set_property CONFIG.RESET_BOARD_INTERFACE Custom [get_ips sys_rstgen]
set_property CONFIG.C_EXT_RST_WIDTH 1 [get_ips sys_rstgen]
set_property CONFIG.C_AUX_RST_WIDTH 1 [get_ips sys_rstgen]
set_property CONFIG.C_EXT_RESET_HIGH 0 [get_ips sys_rstgen]
set_property CONFIG.C_AUX_RESET_HIGH 1 [get_ips sys_rstgen]

set_property generate_synth_checkpoint false [get_files sys_rstgen.xci]

# create a ddr reset
ip_vlvn_version_check "xilinx.com:ip:proc_sys_reset:5.0"

create_ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 -module_name ddr_rstgen

set_property generate_synth_checkpoint false [get_files ddr_rstgen.xci]

# create uart lite
ip_vlvn_version_check "xilinx.com:ip:axi_uartlite:2.0"

create_ip -vlnv xilinx.com:ip:axi_uartlite:2.0 -module_name axi_uart
set_property CONFIG.C_BAUDRATE {115200} [get_ips axi_uart]

set_property generate_synth_checkpoint false [get_files axi_uart.xci]

#create gpio
ip_vlvn_version_check "xilinx.com:ip:axi_gpio:2.0"

create_ip -vlnv xilinx.com:ip:axi_gpio:2.0 -module_name axi_gpio32

set_property generate_synth_checkpoint false [get_files axi_gpio32.xci]

#create quad spi as single spi
ip_vlvn_version_check "xilinx.com:ip:axi_quad_spi:3.2"

create_ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 -module_name axi_spix1
set_property CONFIG.C_USE_STARTUP {0} [get_ips axi_spix1]

set_property generate_synth_checkpoint false [get_files axi_spix1.xci]

#create quad spi for flash
ip_vlvn_version_check "xilinx.com:ip:axi_quad_spi:3.2"

create_ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 -module_name axi_spix4
set_property CONFIG.C_SPI_MEMORY {3} [get_ips axi_spix4]
set_property CONFIG.C_SPI_MODE {2} [get_ips axi_spix4]
set_property CONFIG.C_USE_STARTUP {1} [get_ips axi_spix4]

set_property generate_synth_checkpoint false [get_files axi_spix4.xci]

#create ethernet controller
ip_vlvn_version_check "xilinx.com:ip:axi_ethernetlite:3.0"

create_ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 -module_name axi_ethernet

set_property generate_synth_checkpoint false [get_files axi_ethernet.xci]

#create ddr controller
ip_vlvn_version_check "xilinx.com:ip:mig_7series:4.2"

create_ip -vlnv xilinx.com:ip:mig_7series:4.2 -module_name axi_ddr_ctrl
set axi_ddr_cntrl_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name [get_ips axi_ddr_ctrl]]]]
file copy -force ddr_mig.prj "$axi_ddr_cntrl_dir/"
set_property CONFIG.XML_INPUT_FILE ddr_mig.prj [get_ips axi_ddr_ctrl]

set_property generate_synth_checkpoint false [get_files axi_ddr_ctrl.xci]

generate_target all [get_ips]
