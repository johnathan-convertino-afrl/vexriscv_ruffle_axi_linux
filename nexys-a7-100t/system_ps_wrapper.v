//******************************************************************************
/// @FILE    system_ps_wrapper.v
/// @AUTHOR  JAY CONVERTINO
/// @DATE    2024.07.30
/// @BRIEF   System wrapper for ps.
///
/// @LICENSE MIT
///  Copyright 2024 Jay Convertino
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to
///  deal in the Software without restriction, including without limitation the
///  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
///  sell copies of the Software, and to permit persons to whom the Software is
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in
///  all copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
///  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
//******************************************************************************
`timescale 1ns/100ps

module system_ps_wrapper
     (
          output    [12:0]    DDR_addr,
          output    [ 2:0]    DDR_ba,
          output              DDR_cas_n,
          output    [ 0:0]    DDR_ck_n,
          output    [ 0:0]    DDR_ck_p,
          output    [ 0:0]    DDR_cke,
          output    [ 0:0]    DDR_cs_n,
          output    [ 1:0]    DDR_dm,
          inout     [15:0]    DDR_dq,
          inout     [ 1:0]    DDR_dqs_n,
          inout     [ 1:0]    DDR_dqs_p,
          output    [ 0:0]    DDR_odt,
          output              DDR_ras_n,
          output              DDR_we_n,
          input     [ 2:0]    IRQ,
          output              MDIO_mdc,
          inout               MDIO_mdio_io,
          input               MII_col,
          input               MII_crs,
          output              MII_rst_n,
          input               MII_rx_clk,
          input               MII_rx_dv,
          input               MII_rx_er,
          input     [ 3:0]    MII_rxd,
          input               MII_tx_clk,
          output              MII_tx_en,
          output    [ 3:0]    MII_txd,
          output    [31:0]    M_AXI_araddr,
          output    [ 2:0]    M_AXI_arprot,
          input               M_AXI_arready,
          output              M_AXI_arvalid,
          output    [31:0]    M_AXI_awaddr,
          output    [ 2:0]    M_AXI_awprot,
          input               M_AXI_awready,
          output              M_AXI_awvalid,
          output              M_AXI_bready,
          input     [ 1:0]    M_AXI_bresp,
          input               M_AXI_bvalid,
          input     [31:0]    M_AXI_rdata,
          output              M_AXI_rready,
          input     [ 1:0]    M_AXI_rresp,
          input               M_AXI_rvalid,
          output    [31:0]    M_AXI_wdata,
          input               M_AXI_wready,
          output    [ 3:0]    M_AXI_wstrb,
          output              M_AXI_wvalid,
          inout               QSPI_0_io0_io,
          inout               QSPI_0_io1_io,
          inout               QSPI_0_io2_io,
          inout               QSPI_0_io3_io,
          inout     [ 0:0]    QSPI_0_ss_io,
          input               UART_rxd,
          output              UART_txd,
          input     [31:0]    gpio_io_i,
          output    [31:0]    gpio_io_o,
          output    [31:0]    gpio_io_t,
          input               io_s_axi_dma_arstn,
          output              s_axi_clk,
          input               s_axi_dma_aclk,
          input     [31:0]    s_axi_dma_araddr,
          input     [ 3:0]    s_axi_dma_arcache,
          input     [ 7:0]    s_axi_dma_arlen,
          input     [ 2:0]    s_axi_dma_arprot,
          output              s_axi_dma_arready,
          input     [ 2:0]    s_axi_dma_arsize,
          input               s_axi_dma_arvalid,
          input     [31:0]    s_axi_dma_awaddr,
          input     [ 3:0]    s_axi_dma_awcache,
          input     [ 7:0]    s_axi_dma_awlen,
          input     [ 2:0]    s_axi_dma_awprot,
          output              s_axi_dma_awready,
          input     [ 2:0]    s_axi_dma_awsize,
          input               s_axi_dma_awvalid,
          input               s_axi_dma_bready,
          output              s_axi_dma_bvalid,
          output    [31:0]    s_axi_dma_rdata,
          output              s_axi_dma_rlast,
          input               s_axi_dma_rready,
          output              s_axi_dma_rvalid,
          input     [31:0]    s_axi_dma_wdata,
          input               s_axi_dma_wlast,
          output              s_axi_dma_wready,
          input     [ 3:0]    s_axi_dma_wstrb,
          input               s_axi_dma_wvalid,
          input               spi_io0_i,
          output              spi_io0_o,
          output              spi_io0_t,
          input               spi_io1_i,
          output              spi_io1_o,
          output              spi_io1_t,
          input               spi_sck_i,
          output              spi_sck_o,
          output              spi_sck_t,
          input     [ 0:0]    spi_ss_i,
          output    [ 0:0]    spi_ss_o,
          output              spi_ss_t,
          input               sys_clk,
          input               sys_rstn
     );

     //ethernet buf signals
     wire           MDIO_mdio_i;
     wire           MDIO_mdio_o;
     wire           MDIO_mdio_t;

     //quad spi buf signals
     wire           QSPI_0_io0_i;
     wire           QSPI_0_io0_io;
     wire           QSPI_0_io0_o;
     wire           QSPI_0_io0_t;
     wire           QSPI_0_io1_i;
     wire           QSPI_0_io1_io;
     wire           QSPI_0_io1_o;
     wire           QSPI_0_io1_t;
     wire           QSPI_0_io2_i;
     wire           QSPI_0_io2_io;
     wire           QSPI_0_io2_o;
     wire           QSPI_0_io2_t;
     wire           QSPI_0_io3_i;
     wire           QSPI_0_io3_io;
     wire           QSPI_0_io3_o;
     wire           QSPI_0_io3_t;
     wire [ 0:0]    QSPI_0_ss_i_0;
     wire [ 0:0]    QSPI_0_ss_io_0;
     wire [ 0:0]    QSPI_0_ss_o_0;

     //clocks
     wire           clk_wiz_1_clk_out1;
     wire           clk_wiz_1_clk_out2;

     //resets
     wire [ 0:0]    ddr_rstgen_peripheral_aresetn;
     wire [ 0:0]    sys_rstgen_interconnect_aresetn;
     wire [ 0:0]    sys_rstgen_peripheral_aresetn;

     //ddr signals and clocks
     wire           axi_ddr_ctrl_mmcm_locked;
     wire           axi_ddr_ctrl_ui_clk;
     wire           axi_ddr_ctrl_ui_clk_sync_rst;

     //irq
     wire           axi_uartlite_irq;
     wire           axi_ethernet_irq;
     wire           axi_quad_spi_irq;

     //axi lite ethernet
     wire [31:0]    inst_ruffle_m_axi_eth_ARADDR;
     wire           inst_ruffle_m_axi_eth_ARREADY;
     wire           inst_ruffle_m_axi_eth_ARVALID;
     wire [31:0]    inst_ruffle_m_axi_eth_AWADDR;
     wire           inst_ruffle_m_axi_eth_AWREADY;
     wire           inst_ruffle_m_axi_eth_AWVALID;
     wire           inst_ruffle_m_axi_eth_BREADY;
     wire [ 1:0]    inst_ruffle_m_axi_eth_BRESP;
     wire           inst_ruffle_m_axi_eth_BVALID;
     wire [31:0]    inst_ruffle_m_axi_eth_RDATA;
     wire           inst_ruffle_m_axi_eth_RREADY;
     wire [ 1:0]    inst_ruffle_m_axi_eth_RRESP;
     wire           inst_ruffle_m_axi_eth_RVALID;
     wire [31:0]    inst_ruffle_m_axi_eth_WDATA;
     wire           inst_ruffle_m_axi_eth_WREADY;
     wire [ 3:0]    inst_ruffle_m_axi_eth_WSTRB;
     wire           inst_ruffle_m_axi_eth_WVALID;

     //axi lite gpio
     wire [31:0]    inst_ruffle_m_axi_gpio_ARADDR;
     wire           inst_ruffle_m_axi_gpio_ARREADY;
     wire           inst_ruffle_m_axi_gpio_ARVALID;
     wire [31:0]    inst_ruffle_m_axi_gpio_AWADDR;
     wire           inst_ruffle_m_axi_gpio_AWREADY;
     wire           inst_ruffle_m_axi_gpio_AWVALID;
     wire           inst_ruffle_m_axi_gpio_BREADY;
     wire [ 1:0]    inst_ruffle_m_axi_gpio_BRESP;
     wire           inst_ruffle_m_axi_gpio_BVALID;
     wire [31:0]    inst_ruffle_m_axi_gpio_RDATA;
     wire           inst_ruffle_m_axi_gpio_RREADY;
     wire [ 1:0]    inst_ruffle_m_axi_gpio_RRESP;
     wire           inst_ruffle_m_axi_gpio_RVALID;
     wire [31:0]    inst_ruffle_m_axi_gpio_WDATA;
     wire           inst_ruffle_m_axi_gpio_WREADY;
     wire [ 3:0]    inst_ruffle_m_axi_gpio_WSTRB;
     wire           inst_ruffle_m_axi_gpio_WVALID;

     //axi4 w/ID memory bus (ibus/dbus path)
     wire [31:0]    inst_ruffle_m_axi_mbus_ARADDR;
     wire [ 1:0]    inst_ruffle_m_axi_mbus_ARBURST;
     wire [ 3:0]    inst_ruffle_m_axi_mbus_ARCACHE;
     wire [ 3:0]    inst_ruffle_m_axi_mbus_ARID;
     wire [ 7:0]    inst_ruffle_m_axi_mbus_ARLEN;
     wire [ 2:0]    inst_ruffle_m_axi_mbus_ARPROT;
     wire           inst_ruffle_m_axi_mbus_ARREADY;
     wire [ 2:0]    inst_ruffle_m_axi_mbus_ARSIZE;
     wire           inst_ruffle_m_axi_mbus_ARVALID;
     wire [31:0]    inst_ruffle_m_axi_mbus_AWADDR;
     wire [ 1:0]    inst_ruffle_m_axi_mbus_AWBURST;
     wire [ 3:0]    inst_ruffle_m_axi_mbus_AWCACHE;
     wire [ 3:0]    inst_ruffle_m_axi_mbus_AWID;
     wire [ 7:0]    inst_ruffle_m_axi_mbus_AWLEN;
     wire [ 2:0]    inst_ruffle_m_axi_mbus_AWPROT;
     wire           inst_ruffle_m_axi_mbus_AWREADY;
     wire [ 2:0]    inst_ruffle_m_axi_mbus_AWSIZE;
     wire           inst_ruffle_m_axi_mbus_AWVALID;
     wire [ 3:0]    inst_ruffle_m_axi_mbus_BID;
     wire           inst_ruffle_m_axi_mbus_BREADY;
     wire           inst_ruffle_m_axi_mbus_BVALID;
     wire [31:0]    inst_ruffle_m_axi_mbus_RDATA;
     wire [ 3:0]    inst_ruffle_m_axi_mbus_RID;
     wire           inst_ruffle_m_axi_mbus_RLAST;
     wire           inst_ruffle_m_axi_mbus_RREADY;
     wire           inst_ruffle_m_axi_mbus_RVALID;
     wire [31:0]    inst_ruffle_m_axi_mbus_WDATA;
     wire           inst_ruffle_m_axi_mbus_WLAST;
     wire           inst_ruffle_m_axi_mbus_WREADY;
     wire [ 3:0]    inst_ruffle_m_axi_mbus_WSTRB;
     wire           inst_ruffle_m_axi_mbus_WVALID;

     //axi lite qspi
     wire [31:0]    inst_ruffle_m_axi_qspi_ARADDR;
     wire           inst_ruffle_m_axi_qspi_ARREADY;
     wire           inst_ruffle_m_axi_qspi_ARVALID;
     wire [31:0]    inst_ruffle_m_axi_qspi_AWADDR;
     wire           inst_ruffle_m_axi_qspi_AWREADY;
     wire           inst_ruffle_m_axi_qspi_AWVALID;
     wire           inst_ruffle_m_axi_qspi_BREADY;
     wire [ 1:0]    inst_ruffle_m_axi_qspi_BRESP;
     wire           inst_ruffle_m_axi_qspi_BVALID;
     wire [31:0]    inst_ruffle_m_axi_qspi_RDATA;
     wire           inst_ruffle_m_axi_qspi_RREADY;
     wire [ 1:0]    inst_ruffle_m_axi_qspi_RRESP;
     wire           inst_ruffle_m_axi_qspi_RVALID;
     wire [31:0]    inst_ruffle_m_axi_qspi_WDATA;
     wire           inst_ruffle_m_axi_qspi_WREADY;
     wire [ 3:0]    inst_ruffle_m_axi_qspi_WSTRB;
     wire           inst_ruffle_m_axi_qspi_WVALID;

     //axi lite spi
     wire [31:0]    inst_ruffle_m_axi_spi_ARADDR;
     wire           inst_ruffle_m_axi_spi_ARREADY;
     wire           inst_ruffle_m_axi_spi_ARVALID;
     wire [31:0]    inst_ruffle_m_axi_spi_AWADDR;
     wire           inst_ruffle_m_axi_spi_AWREADY;
     wire           inst_ruffle_m_axi_spi_AWVALID;
     wire           inst_ruffle_m_axi_spi_BREADY;
     wire [ 1:0]    inst_ruffle_m_axi_spi_BRESP;
     wire           inst_ruffle_m_axi_spi_BVALID;
     wire [31:0]    inst_ruffle_m_axi_spi_RDATA;
     wire           inst_ruffle_m_axi_spi_RREADY;
     wire [ 1:0]    inst_ruffle_m_axi_spi_RRESP;
     wire           inst_ruffle_m_axi_spi_RVALID;
     wire [31:0]    inst_ruffle_m_axi_spi_WDATA;
     wire           inst_ruffle_m_axi_spi_WREADY;
     wire [ 3:0]    inst_ruffle_m_axi_spi_WSTRB;
     wire           inst_ruffle_m_axi_spi_WVALID;

     //axi lite uart
     wire [31:0]    inst_ruffle_m_axi_uart_ARADDR;
     wire           inst_ruffle_m_axi_uart_ARREADY;
     wire           inst_ruffle_m_axi_uart_ARVALID;
     wire [31:0]    inst_ruffle_m_axi_uart_AWADDR;
     wire           inst_ruffle_m_axi_uart_AWREADY;
     wire           inst_ruffle_m_axi_uart_AWVALID;
     wire           inst_ruffle_m_axi_uart_BREADY;
     wire [ 1:0]    inst_ruffle_m_axi_uart_BRESP;
     wire           inst_ruffle_m_axi_uart_BVALID;
     wire [31:0]    inst_ruffle_m_axi_uart_RDATA;
     wire           inst_ruffle_m_axi_uart_RREADY;
     wire [ 1:0]    inst_ruffle_m_axi_uart_RRESP;
     wire           inst_ruffle_m_axi_uart_RVALID;
     wire [31:0]    inst_ruffle_m_axi_uart_WDATA;
     wire           inst_ruffle_m_axi_uart_WREADY;
     wire [ 3:0]    inst_ruffle_m_axi_uart_WSTRB;
     wire           inst_ruffle_m_axi_uart_WVALID;

     //distribute clock for axi and assign to output for m_axi_acc
     assign s_axi_clk = clk_wiz_1_clk_out1;

     //MDIO ETH BUF
     IOBUF MDIO_mdio_iobuf
       (.I(MDIO_mdio_o),
        .IO(MDIO_mdio_io),
        .O(MDIO_mdio_i),
        .T(MDIO_mdio_t));

     //QUAD SPI BUFS
     IOBUF QSPI_0_io0_iobuf
          (.I(QSPI_0_io0_o),
          .IO(QSPI_0_io0_io),
          .O(QSPI_0_io0_i),
          .T(QSPI_0_io0_t));

     IOBUF QSPI_0_io1_iobuf
          (.I(QSPI_0_io1_o),
          .IO(QSPI_0_io1_io),
          .O(QSPI_0_io1_i),
          .T(QSPI_0_io1_t));

     IOBUF QSPI_0_io2_iobuf
          (.I(QSPI_0_io2_o),
          .IO(QSPI_0_io2_io),
          .O(QSPI_0_io2_i),
          .T(QSPI_0_io2_t));

     IOBUF QSPI_0_io3_iobuf
          (.I(QSPI_0_io3_o),
          .IO(QSPI_0_io3_io),
          .O(QSPI_0_io3_i),
          .T(QSPI_0_io3_t));

     IOBUF QSPI_0_ss_iobuf_0
          (.I(QSPI_0_ss_o_0),
          .IO(QSPI_0_ss_io[0]),
          .O(QSPI_0_ss_i_0),
          .T(QSPI_0_ss_t));

     axi_ddr_ctrl inst_axi_ddr_ctrl
          (
               .aresetn(ddr_rstgen_peripheral_aresetn),
               .ddr2_addr(DDR_addr),
               .ddr2_ba(DDR_ba),
               .ddr2_cas_n(DDR_cas_n),
               .ddr2_ck_n(DDR_ck_n),
               .ddr2_ck_p(DDR_ck_p),
               .ddr2_cke(DDR_cke),
               .ddr2_cs_n(DDR_cs_n),
               .ddr2_dm(DDR_dm),
               .ddr2_dq(DDR_dq[15:0]),
               .ddr2_dqs_n(DDR_dqs_n[1:0]),
               .ddr2_dqs_p(DDR_dqs_p[1:0]),
               .ddr2_odt(DDR_odt),
               .ddr2_ras_n(DDR_ras_n),
               .ddr2_we_n(DDR_we_n),
               .mmcm_locked(axi_ddr_ctrl_mmcm_locked),
               .s_axi_araddr(inst_ruffle_m_axi_mbus_ARADDR),
               .s_axi_arburst(inst_ruffle_m_axi_mbus_ARBURST),
               .s_axi_arcache(inst_ruffle_m_axi_mbus_ARCACHE),
               .s_axi_arid(inst_ruffle_m_axi_mbus_ARID),
               .s_axi_arlen(inst_ruffle_m_axi_mbus_ARLEN),
               .s_axi_arlock(1'b0),
               .s_axi_arprot(inst_ruffle_m_axi_mbus_ARPROT),
               .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
               .s_axi_arready(inst_ruffle_m_axi_mbus_ARREADY),
               .s_axi_arsize(inst_ruffle_m_axi_mbus_ARSIZE),
               .s_axi_arvalid(inst_ruffle_m_axi_mbus_ARVALID),
               .s_axi_awaddr(inst_ruffle_m_axi_mbus_AWADDR),
               .s_axi_awburst(inst_ruffle_m_axi_mbus_AWBURST),
               .s_axi_awcache(inst_ruffle_m_axi_mbus_AWCACHE),
               .s_axi_awid(inst_ruffle_m_axi_mbus_AWID),
               .s_axi_awlen(inst_ruffle_m_axi_mbus_AWLEN),
               .s_axi_awlock(1'b0),
               .s_axi_awprot(inst_ruffle_m_axi_mbus_AWPROT),
               .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
               .s_axi_awready(inst_ruffle_m_axi_mbus_AWREADY),
               .s_axi_awsize(inst_ruffle_m_axi_mbus_AWSIZE),
               .s_axi_awvalid(inst_ruffle_m_axi_mbus_AWVALID),
               .s_axi_bid(inst_ruffle_m_axi_mbus_BID),
               .s_axi_bready(inst_ruffle_m_axi_mbus_BREADY),
               .s_axi_bvalid(inst_ruffle_m_axi_mbus_BVALID),
               .s_axi_rdata(inst_ruffle_m_axi_mbus_RDATA),
               .s_axi_rid(inst_ruffle_m_axi_mbus_RID),
               .s_axi_rlast(inst_ruffle_m_axi_mbus_RLAST),
               .s_axi_rready(inst_ruffle_m_axi_mbus_RREADY),
               .s_axi_rvalid(inst_ruffle_m_axi_mbus_RVALID),
               .s_axi_wdata(inst_ruffle_m_axi_mbus_WDATA),
               .s_axi_wlast(inst_ruffle_m_axi_mbus_WLAST),
               .s_axi_wready(inst_ruffle_m_axi_mbus_WREADY),
               .s_axi_wstrb(inst_ruffle_m_axi_mbus_WSTRB),
               .s_axi_wvalid(inst_ruffle_m_axi_mbus_WVALID),
               .sys_clk_i(clk_wiz_1_clk_out2),
               .sys_rst(sys_rstn),
               .ui_clk(axi_ddr_ctrl_ui_clk),
               .ui_clk_sync_rst(axi_ddr_ctrl_ui_clk_sync_rst)
          );

     axi_ethernet inst_axi_ethernet
          (
               .ip2intc_irpt(axi_ethernet_irq),
               .phy_col(MII_col),
               .phy_crs(MII_crs),
               .phy_dv(MII_rx_dv),
               .phy_mdc(MDIO_mdc),
               .phy_mdio_i(MDIO_mdio_i),
               .phy_mdio_o(MDIO_mdio_o),
               .phy_mdio_t(MDIO_mdio_t),
               .phy_rst_n(MII_rst_n),
               .phy_rx_clk(MII_rx_clk),
               .phy_rx_data(MII_rxd),
               .phy_rx_er(MII_rx_er),
               .phy_tx_clk(MII_tx_clk),
               .phy_tx_data(MII_txd),
               .phy_tx_en(MII_tx_en),
               .s_axi_aclk(clk_wiz_1_clk_out1),
               .s_axi_araddr(inst_ruffle_m_axi_eth_ARADDR[12:0]),
               .s_axi_aresetn(sys_rstgen_peripheral_aresetn),
               .s_axi_arready(inst_ruffle_m_axi_eth_ARREADY),
               .s_axi_arvalid(inst_ruffle_m_axi_eth_ARVALID),
               .s_axi_awaddr(inst_ruffle_m_axi_eth_AWADDR[12:0]),
               .s_axi_awready(inst_ruffle_m_axi_eth_AWREADY),
               .s_axi_awvalid(inst_ruffle_m_axi_eth_AWVALID),
               .s_axi_bready(inst_ruffle_m_axi_eth_BREADY),
               .s_axi_bresp(inst_ruffle_m_axi_eth_BRESP),
               .s_axi_bvalid(inst_ruffle_m_axi_eth_BVALID),
               .s_axi_rdata(inst_ruffle_m_axi_eth_RDATA),
               .s_axi_rready(inst_ruffle_m_axi_eth_RREADY),
               .s_axi_rresp(inst_ruffle_m_axi_eth_RRESP),
               .s_axi_rvalid(inst_ruffle_m_axi_eth_RVALID),
               .s_axi_wdata(inst_ruffle_m_axi_eth_WDATA),
               .s_axi_wready(inst_ruffle_m_axi_eth_WREADY),
               .s_axi_wstrb(inst_ruffle_m_axi_eth_WSTRB),
               .s_axi_wvalid(inst_ruffle_m_axi_eth_WVALID)
          );

     axi_gpio32 inst_axi_gpio32
          (
               .gpio_io_i(gpio_io_i),
               .gpio_io_o(gpio_io_o),
               .gpio_io_t(gpio_io_t),
               .s_axi_aclk(clk_wiz_1_clk_out1),
               .s_axi_araddr(inst_ruffle_m_axi_gpio_ARADDR[8:0]),
               .s_axi_aresetn(sys_rstgen_peripheral_aresetn),
               .s_axi_arready(inst_ruffle_m_axi_gpio_ARREADY),
               .s_axi_arvalid(inst_ruffle_m_axi_gpio_ARVALID),
               .s_axi_awaddr(inst_ruffle_m_axi_gpio_AWADDR[8:0]),
               .s_axi_awready(inst_ruffle_m_axi_gpio_AWREADY),
               .s_axi_awvalid(inst_ruffle_m_axi_gpio_AWVALID),
               .s_axi_bready(inst_ruffle_m_axi_gpio_BREADY),
               .s_axi_bresp(inst_ruffle_m_axi_gpio_BRESP),
               .s_axi_bvalid(inst_ruffle_m_axi_gpio_BVALID),
               .s_axi_rdata(inst_ruffle_m_axi_gpio_RDATA),
               .s_axi_rready(inst_ruffle_m_axi_gpio_RREADY),
               .s_axi_rresp(inst_ruffle_m_axi_gpio_RRESP),
               .s_axi_rvalid(inst_ruffle_m_axi_gpio_RVALID),
               .s_axi_wdata(inst_ruffle_m_axi_gpio_WDATA),
               .s_axi_wready(inst_ruffle_m_axi_gpio_WREADY),
               .s_axi_wstrb(inst_ruffle_m_axi_gpio_WSTRB),
               .s_axi_wvalid(inst_ruffle_m_axi_gpio_WVALID)
          );

     axi_spix4 inst_axi_spix4
          (
               .ext_spi_clk(clk_wiz_1_clk_out1),
               .io0_i(QSPI_0_io0_i),
               .io0_o(QSPI_0_io0_o),
               .io0_t(QSPI_0_io0_t),
               .io1_i(QSPI_0_io1_i),
               .io1_o(QSPI_0_io1_o),
               .io1_t(QSPI_0_io1_t),
               .io2_i(QSPI_0_io2_i),
               .io2_o(QSPI_0_io2_o),
               .io2_t(QSPI_0_io2_t),
               .io3_i(QSPI_0_io3_i),
               .io3_o(QSPI_0_io3_o),
               .io3_t(QSPI_0_io3_t),
               .ip2intc_irpt(axi_quad_spi_irq),
               .s_axi_aclk(clk_wiz_1_clk_out1),
               .s_axi_araddr(inst_ruffle_m_axi_qspi_ARADDR[6:0]),
               .s_axi_aresetn(sys_rstgen_interconnect_aresetn),
               .s_axi_arready(inst_ruffle_m_axi_qspi_ARREADY),
               .s_axi_arvalid(inst_ruffle_m_axi_qspi_ARVALID),
               .s_axi_awaddr(inst_ruffle_m_axi_qspi_AWADDR[6:0]),
               .s_axi_awready(inst_ruffle_m_axi_qspi_AWREADY),
               .s_axi_awvalid(inst_ruffle_m_axi_qspi_AWVALID),
               .s_axi_bready(inst_ruffle_m_axi_qspi_BREADY),
               .s_axi_bresp(inst_ruffle_m_axi_qspi_BRESP),
               .s_axi_bvalid(inst_ruffle_m_axi_qspi_BVALID),
               .s_axi_rdata(inst_ruffle_m_axi_qspi_RDATA),
               .s_axi_rready(inst_ruffle_m_axi_qspi_RREADY),
               .s_axi_rresp(inst_ruffle_m_axi_qspi_RRESP),
               .s_axi_rvalid(inst_ruffle_m_axi_qspi_RVALID),
               .s_axi_wdata(inst_ruffle_m_axi_qspi_WDATA),
               .s_axi_wready(inst_ruffle_m_axi_qspi_WREADY),
               .s_axi_wstrb(inst_ruffle_m_axi_qspi_WSTRB),
               .s_axi_wvalid(inst_ruffle_m_axi_qspi_WVALID),
               .ss_i(QSPI_0_ss_i_0),
               .ss_o(QSPI_0_ss_o_0),
               .ss_t(QSPI_0_ss_t_0)
          );

     axi_spix1 inst_axi_spix1
          (
               .ext_spi_clk(clk_wiz_1_clk_out1),
               .io0_i(spi_io0_i),
               .io0_o(spi_io0_o),
               .io0_t(spi_io0_t),
               .io1_i(spi_io1_i),
               .io1_o(spi_io1_o),
               .io1_t(spi_io1_t),
               .ip2intc_irpt(axi_spi_irq),
               .s_axi_aclk(clk_wiz_1_clk_out1),
               .s_axi_araddr(inst_ruffle_m_axi_spi_ARADDR[6:0]),
               .s_axi_aresetn(sys_rstgen_peripheral_aresetn),
               .s_axi_arready(inst_ruffle_m_axi_spi_ARREADY),
               .s_axi_arvalid(inst_ruffle_m_axi_spi_ARVALID),
               .s_axi_awaddr(inst_ruffle_m_axi_spi_AWADDR[6:0]),
               .s_axi_awready(inst_ruffle_m_axi_spi_AWREADY),
               .s_axi_awvalid(inst_ruffle_m_axi_spi_AWVALID),
               .s_axi_bready(inst_ruffle_m_axi_spi_BREADY),
               .s_axi_bresp(inst_ruffle_m_axi_spi_BRESP),
               .s_axi_bvalid(inst_ruffle_m_axi_spi_BVALID),
               .s_axi_rdata(inst_ruffle_m_axi_spi_RDATA),
               .s_axi_rready(inst_ruffle_m_axi_spi_RREADY),
               .s_axi_rresp(inst_ruffle_m_axi_spi_RRESP),
               .s_axi_rvalid(inst_ruffle_m_axi_spi_RVALID),
               .s_axi_wdata(inst_ruffle_m_axi_spi_WDATA),
               .s_axi_wready(inst_ruffle_m_axi_spi_WREADY),
               .s_axi_wstrb(inst_ruffle_m_axi_spi_WSTRB),
               .s_axi_wvalid(inst_ruffle_m_axi_spi_WVALID),
               .sck_i(spi_sck_i),
               .sck_o(spi_sck_o),
               .sck_t(spi_sck_t),
               .ss_i(spi_ss_i),
               .ss_o(spi_ss_o),
               .ss_t(spi_ss_t)
          );

     axi_uart inst_axi_uart
          (
               .interrupt(axi_uartlite_irq),
               .rx(UART_rxd),
               .s_axi_aclk(clk_wiz_1_clk_out1),
               .s_axi_araddr(inst_ruffle_m_axi_uart_ARADDR[3:0]),
               .s_axi_aresetn(sys_rstgen_peripheral_aresetn),
               .s_axi_arready(inst_ruffle_m_axi_uart_ARREADY),
               .s_axi_arvalid(inst_ruffle_m_axi_uart_ARVALID),
               .s_axi_awaddr(inst_ruffle_m_axi_uart_AWADDR[3:0]),
               .s_axi_awready(inst_ruffle_m_axi_uart_AWREADY),
               .s_axi_awvalid(inst_ruffle_m_axi_uart_AWVALID),
               .s_axi_bready(inst_ruffle_m_axi_uart_BREADY),
               .s_axi_bresp(inst_ruffle_m_axi_uart_BRESP),
               .s_axi_bvalid(inst_ruffle_m_axi_uart_BVALID),
               .s_axi_rdata(inst_ruffle_m_axi_uart_RDATA),
               .s_axi_rready(inst_ruffle_m_axi_uart_RREADY),
               .s_axi_rresp(inst_ruffle_m_axi_uart_RRESP),
               .s_axi_rvalid(inst_ruffle_m_axi_uart_RVALID),
               .s_axi_wdata(inst_ruffle_m_axi_uart_WDATA),
               .s_axi_wready(inst_ruffle_m_axi_uart_WREADY),
               .s_axi_wstrb(inst_ruffle_m_axi_uart_WSTRB),
               .s_axi_wvalid(inst_ruffle_m_axi_uart_WVALID),
               .tx(UART_txd)
          );

     clk_wiz_1 inst_clk_wiz_1
          (
               .clk_in1(sys_clk),
               .clk_out1(clk_wiz_1_clk_out1),
               .clk_out2(clk_wiz_1_clk_out2)
          );

     ddr_rstgen inst_ddr_rstgen
          (
               .aux_reset_in(axi_ddr_ctrl_ui_clk_sync_rst),
               .dcm_locked(axi_ddr_ctrl_mmcm_locked),
               .ext_reset_in(sys_rstn),
               .mb_debug_sys_rst(1'b0),
               .peripheral_aresetn(ddr_rstgen_peripheral_aresetn),
               .slowest_sync_clk(axi_ddr_ctrl_ui_clk)
          );

     Ruffle inst_ruffle
          (
               .io_aclk(clk_wiz_1_clk_out1),
               .io_arstn(sys_rstgen_peripheral_aresetn),
               .io_ddr_clk(axi_ddr_ctrl_ui_clk),
               .io_irq({{32-7{1'b0}},axi_quad_spi_irq, axi_spi_irq, axi_ethernet_irq, axi_uartlite_irq, IRQ}),
               .io_s_axi_dma0_aclk(s_axi_dma_aclk),
               .io_s_axi_dma0_arstn(io_s_axi_dma_arstn),
               .io_s_axi_dma1_aclk(1'b0),
               .io_s_axi_dma1_arstn(1'b0),
               .m_axi_acc_araddr(M_AXI_araddr),
               .m_axi_acc_arprot(M_AXI_arprot),
               .m_axi_acc_arready(M_AXI_arready),
               .m_axi_acc_arvalid(M_AXI_arvalid),
               .m_axi_acc_awaddr(M_AXI_awaddr),
               .m_axi_acc_awprot(M_AXI_awprot),
               .m_axi_acc_awready(M_AXI_awready),
               .m_axi_acc_awvalid(M_AXI_awvalid),
               .m_axi_acc_bready(M_AXI_bready),
               .m_axi_acc_bresp(M_AXI_bresp),
               .m_axi_acc_bvalid(M_AXI_bvalid),
               .m_axi_acc_rdata(M_AXI_rdata),
               .m_axi_acc_rready(M_AXI_rready),
               .m_axi_acc_rresp(M_AXI_rresp),
               .m_axi_acc_rvalid(M_AXI_rvalid),
               .m_axi_acc_wdata(M_AXI_wdata),
               .m_axi_acc_wready(M_AXI_wready),
               .m_axi_acc_wstrb(M_AXI_wstrb),
               .m_axi_acc_wvalid(M_AXI_wvalid),
               .m_axi_eth_araddr(inst_ruffle_m_axi_eth_ARADDR),
               .m_axi_eth_arready(inst_ruffle_m_axi_eth_ARREADY),
               .m_axi_eth_arvalid(inst_ruffle_m_axi_eth_ARVALID),
               .m_axi_eth_awaddr(inst_ruffle_m_axi_eth_AWADDR),
               .m_axi_eth_awready(inst_ruffle_m_axi_eth_AWREADY),
               .m_axi_eth_awvalid(inst_ruffle_m_axi_eth_AWVALID),
               .m_axi_eth_bready(inst_ruffle_m_axi_eth_BREADY),
               .m_axi_eth_bresp(inst_ruffle_m_axi_eth_BRESP),
               .m_axi_eth_bvalid(inst_ruffle_m_axi_eth_BVALID),
               .m_axi_eth_rdata(inst_ruffle_m_axi_eth_RDATA),
               .m_axi_eth_rready(inst_ruffle_m_axi_eth_RREADY),
               .m_axi_eth_rresp(inst_ruffle_m_axi_eth_RRESP),
               .m_axi_eth_rvalid(inst_ruffle_m_axi_eth_RVALID),
               .m_axi_eth_wdata(inst_ruffle_m_axi_eth_WDATA),
               .m_axi_eth_wready(inst_ruffle_m_axi_eth_WREADY),
               .m_axi_eth_wstrb(inst_ruffle_m_axi_eth_WSTRB),
               .m_axi_eth_wvalid(inst_ruffle_m_axi_eth_WVALID),
               .m_axi_gpio_araddr(inst_ruffle_m_axi_gpio_ARADDR),
               .m_axi_gpio_arready(inst_ruffle_m_axi_gpio_ARREADY),
               .m_axi_gpio_arvalid(inst_ruffle_m_axi_gpio_ARVALID),
               .m_axi_gpio_awaddr(inst_ruffle_m_axi_gpio_AWADDR),
               .m_axi_gpio_awready(inst_ruffle_m_axi_gpio_AWREADY),
               .m_axi_gpio_awvalid(inst_ruffle_m_axi_gpio_AWVALID),
               .m_axi_gpio_bready(inst_ruffle_m_axi_gpio_BREADY),
               .m_axi_gpio_bresp(inst_ruffle_m_axi_gpio_BRESP),
               .m_axi_gpio_bvalid(inst_ruffle_m_axi_gpio_BVALID),
               .m_axi_gpio_rdata(inst_ruffle_m_axi_gpio_RDATA),
               .m_axi_gpio_rready(inst_ruffle_m_axi_gpio_RREADY),
               .m_axi_gpio_rresp(inst_ruffle_m_axi_gpio_RRESP),
               .m_axi_gpio_rvalid(inst_ruffle_m_axi_gpio_RVALID),
               .m_axi_gpio_wdata(inst_ruffle_m_axi_gpio_WDATA),
               .m_axi_gpio_wready(inst_ruffle_m_axi_gpio_WREADY),
               .m_axi_gpio_wstrb(inst_ruffle_m_axi_gpio_WSTRB),
               .m_axi_gpio_wvalid(inst_ruffle_m_axi_gpio_WVALID),
               .m_axi_mbus_araddr(inst_ruffle_m_axi_mbus_ARADDR),
               .m_axi_mbus_arburst(inst_ruffle_m_axi_mbus_ARBURST),
               .m_axi_mbus_arcache(inst_ruffle_m_axi_mbus_ARCACHE),
               .m_axi_mbus_arid(inst_ruffle_m_axi_mbus_ARID),
               .m_axi_mbus_arlen(inst_ruffle_m_axi_mbus_ARLEN),
               .m_axi_mbus_arprot(inst_ruffle_m_axi_mbus_ARPROT),
               .m_axi_mbus_arready(inst_ruffle_m_axi_mbus_ARREADY),
               .m_axi_mbus_arsize(inst_ruffle_m_axi_mbus_ARSIZE),
               .m_axi_mbus_arvalid(inst_ruffle_m_axi_mbus_ARVALID),
               .m_axi_mbus_awaddr(inst_ruffle_m_axi_mbus_AWADDR),
               .m_axi_mbus_awburst(inst_ruffle_m_axi_mbus_AWBURST),
               .m_axi_mbus_awcache(inst_ruffle_m_axi_mbus_AWCACHE),
               .m_axi_mbus_awid(inst_ruffle_m_axi_mbus_AWID),
               .m_axi_mbus_awlen(inst_ruffle_m_axi_mbus_AWLEN),
               .m_axi_mbus_awprot(inst_ruffle_m_axi_mbus_AWPROT),
               .m_axi_mbus_awready(inst_ruffle_m_axi_mbus_AWREADY),
               .m_axi_mbus_awsize(inst_ruffle_m_axi_mbus_AWSIZE),
               .m_axi_mbus_awvalid(inst_ruffle_m_axi_mbus_AWVALID),
               .m_axi_mbus_bid(inst_ruffle_m_axi_mbus_BID),
               .m_axi_mbus_bready(inst_ruffle_m_axi_mbus_BREADY),
               .m_axi_mbus_bvalid(inst_ruffle_m_axi_mbus_BVALID),
               .m_axi_mbus_rdata(inst_ruffle_m_axi_mbus_RDATA),
               .m_axi_mbus_rid(inst_ruffle_m_axi_mbus_RID),
               .m_axi_mbus_rlast(inst_ruffle_m_axi_mbus_RLAST),
               .m_axi_mbus_rready(inst_ruffle_m_axi_mbus_RREADY),
               .m_axi_mbus_rvalid(inst_ruffle_m_axi_mbus_RVALID),
               .m_axi_mbus_wdata(inst_ruffle_m_axi_mbus_WDATA),
               .m_axi_mbus_wlast(inst_ruffle_m_axi_mbus_WLAST),
               .m_axi_mbus_wready(inst_ruffle_m_axi_mbus_WREADY),
               .m_axi_mbus_wstrb(inst_ruffle_m_axi_mbus_WSTRB),
               .m_axi_mbus_wvalid(inst_ruffle_m_axi_mbus_WVALID),
               .m_axi_qspi_araddr(inst_ruffle_m_axi_qspi_ARADDR),
               .m_axi_qspi_arready(inst_ruffle_m_axi_qspi_ARREADY),
               .m_axi_qspi_arvalid(inst_ruffle_m_axi_qspi_ARVALID),
               .m_axi_qspi_awaddr(inst_ruffle_m_axi_qspi_AWADDR),
               .m_axi_qspi_awready(inst_ruffle_m_axi_qspi_AWREADY),
               .m_axi_qspi_awvalid(inst_ruffle_m_axi_qspi_AWVALID),
               .m_axi_qspi_bready(inst_ruffle_m_axi_qspi_BREADY),
               .m_axi_qspi_bresp(inst_ruffle_m_axi_qspi_BRESP),
               .m_axi_qspi_bvalid(inst_ruffle_m_axi_qspi_BVALID),
               .m_axi_qspi_rdata(inst_ruffle_m_axi_qspi_RDATA),
               .m_axi_qspi_rready(inst_ruffle_m_axi_qspi_RREADY),
               .m_axi_qspi_rresp(inst_ruffle_m_axi_qspi_RRESP),
               .m_axi_qspi_rvalid(inst_ruffle_m_axi_qspi_RVALID),
               .m_axi_qspi_wdata(inst_ruffle_m_axi_qspi_WDATA),
               .m_axi_qspi_wready(inst_ruffle_m_axi_qspi_WREADY),
               .m_axi_qspi_wstrb(inst_ruffle_m_axi_qspi_WSTRB),
               .m_axi_qspi_wvalid(inst_ruffle_m_axi_qspi_WVALID),
               .m_axi_spi_araddr(inst_ruffle_m_axi_spi_ARADDR),
               .m_axi_spi_arready(inst_ruffle_m_axi_spi_ARREADY),
               .m_axi_spi_arvalid(inst_ruffle_m_axi_spi_ARVALID),
               .m_axi_spi_awaddr(inst_ruffle_m_axi_spi_AWADDR),
               .m_axi_spi_awready(inst_ruffle_m_axi_spi_AWREADY),
               .m_axi_spi_awvalid(inst_ruffle_m_axi_spi_AWVALID),
               .m_axi_spi_bready(inst_ruffle_m_axi_spi_BREADY),
               .m_axi_spi_bresp(inst_ruffle_m_axi_spi_BRESP),
               .m_axi_spi_bvalid(inst_ruffle_m_axi_spi_BVALID),
               .m_axi_spi_rdata(inst_ruffle_m_axi_spi_RDATA),
               .m_axi_spi_rready(inst_ruffle_m_axi_spi_RREADY),
               .m_axi_spi_rresp(inst_ruffle_m_axi_spi_RRESP),
               .m_axi_spi_rvalid(inst_ruffle_m_axi_spi_RVALID),
               .m_axi_spi_wdata(inst_ruffle_m_axi_spi_WDATA),
               .m_axi_spi_wready(inst_ruffle_m_axi_spi_WREADY),
               .m_axi_spi_wstrb(inst_ruffle_m_axi_spi_WSTRB),
               .m_axi_spi_wvalid(inst_ruffle_m_axi_spi_WVALID),
               .m_axi_uart_araddr(inst_ruffle_m_axi_uart_ARADDR),
               .m_axi_uart_arready(inst_ruffle_m_axi_uart_ARREADY),
               .m_axi_uart_arvalid(inst_ruffle_m_axi_uart_ARVALID),
               .m_axi_uart_awaddr(inst_ruffle_m_axi_uart_AWADDR),
               .m_axi_uart_awready(inst_ruffle_m_axi_uart_AWREADY),
               .m_axi_uart_awvalid(inst_ruffle_m_axi_uart_AWVALID),
               .m_axi_uart_bready(inst_ruffle_m_axi_uart_BREADY),
               .m_axi_uart_bresp(inst_ruffle_m_axi_uart_BRESP),
               .m_axi_uart_bvalid(inst_ruffle_m_axi_uart_BVALID),
               .m_axi_uart_rdata(inst_ruffle_m_axi_uart_RDATA),
               .m_axi_uart_rready(inst_ruffle_m_axi_uart_RREADY),
               .m_axi_uart_rresp(inst_ruffle_m_axi_uart_RRESP),
               .m_axi_uart_rvalid(inst_ruffle_m_axi_uart_RVALID),
               .m_axi_uart_wdata(inst_ruffle_m_axi_uart_WDATA),
               .m_axi_uart_wready(inst_ruffle_m_axi_uart_WREADY),
               .m_axi_uart_wstrb(inst_ruffle_m_axi_uart_WSTRB),
               .m_axi_uart_wvalid(inst_ruffle_m_axi_uart_WVALID),
               .m_axi_sd_awvalid(),
               .m_axi_sd_awready(1'b0),
               .m_axi_sd_awaddr(),
               .m_axi_sd_awprot(),
               .m_axi_sd_wvalid(),
               .m_axi_sd_wready(1'b0),
               .m_axi_sd_wdata(),
               .m_axi_sd_wstrb(),
               .m_axi_sd_bvalid(1'b0),
               .m_axi_sd_bready(),
               .m_axi_sd_bresp(0),
               .m_axi_sd_arvalid(),
               .m_axi_sd_arready(1'b0),
               .m_axi_sd_araddr(),
               .m_axi_sd_arprot(),
               .m_axi_sd_rvalid(1'b0),
               .m_axi_sd_rready(),
               .m_axi_sd_rdata(0),
               .m_axi_sd_rresp(0),
               .s_axi_dma0_araddr(s_axi_dma_araddr),
               .s_axi_dma0_arcache(s_axi_dma_arcache),
               .s_axi_dma0_arlen(s_axi_dma_arlen),
               .s_axi_dma0_arprot(s_axi_dma_arprot),
               .s_axi_dma0_arready(s_axi_dma_arready),
               .s_axi_dma0_arsize(s_axi_dma_arsize),
               .s_axi_dma0_arvalid(s_axi_dma_arvalid),
               .s_axi_dma0_awaddr(s_axi_dma_awaddr),
               .s_axi_dma0_awcache(s_axi_dma_awcache),
               .s_axi_dma0_awlen(s_axi_dma_awlen),
               .s_axi_dma0_awprot(s_axi_dma_awprot),
               .s_axi_dma0_awready(s_axi_dma_awready),
               .s_axi_dma0_awsize(s_axi_dma_awsize),
               .s_axi_dma0_awvalid(s_axi_dma_awvalid),
               .s_axi_dma0_bready(s_axi_dma_bready),
               .s_axi_dma0_bvalid(s_axi_dma_bvalid),
               .s_axi_dma0_rdata(s_axi_dma_rdata),
               .s_axi_dma0_rlast(s_axi_dma_rlast),
               .s_axi_dma0_rready(s_axi_dma_rready),
               .s_axi_dma0_rvalid(s_axi_dma_rvalid),
               .s_axi_dma0_wdata(s_axi_dma_wdata),
               .s_axi_dma0_wlast(s_axi_dma_wlast),
               .s_axi_dma0_wready(s_axi_dma_wready),
               .s_axi_dma0_wstrb(s_axi_dma_wstrb),
               .s_axi_dma0_wvalid(s_axi_dma_wvalid),
               .s_axi_dma1_araddr(0),
               .s_axi_dma1_arcache(0),
               .s_axi_dma1_arlen(0),
               .s_axi_dma1_arprot(0),
               .s_axi_dma1_arready(),
               .s_axi_dma1_arsize(0),
               .s_axi_dma1_arvalid(1'b0),
               .s_axi_dma1_awaddr(0),
               .s_axi_dma1_awcache(0),
               .s_axi_dma1_awlen(0),
               .s_axi_dma1_awprot(0),
               .s_axi_dma1_awready(),
               .s_axi_dma1_awsize(0),
               .s_axi_dma1_awvalid(1'b0),
               .s_axi_dma1_bready(1'b0),
               .s_axi_dma1_bvalid(),
               .s_axi_dma1_rdata(),
               .s_axi_dma1_rlast(),
               .s_axi_dma1_rready(1'b0),
               .s_axi_dma1_rvalid(),
               .s_axi_dma1_wdata(0),
               .s_axi_dma1_wlast(1'b0),
               .s_axi_dma1_wready(),
               .s_axi_dma1_wstrb(0),
               .s_axi_dma1_wvalid(1'b0)
          );

     sys_rstgen inst_sys_rstgen
          (
               .aux_reset_in(axi_ddr_ctrl_ui_clk_sync_rst),
               .dcm_locked(axi_ddr_ctrl_mmcm_locked),
               .ext_reset_in(sys_rstn),
               .interconnect_aresetn(sys_rstgen_interconnect_aresetn),
               .mb_debug_sys_rst(1'b0),
               .peripheral_aresetn(sys_rstgen_peripheral_aresetn),
               .slowest_sync_clk(clk_wiz_1_clk_out1)
          );
endmodule
