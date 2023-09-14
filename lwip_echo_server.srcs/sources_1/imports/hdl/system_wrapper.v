`timescale 1 ps / 1 ps

module system_wrapper(
inout  [14:0]  DDR_addr    ,
inout  [2:0]   DDR_ba      ,
inout          DDR_cas_n   ,
inout          DDR_ck_n    ,
inout          DDR_ck_p    ,
inout          DDR_cke     ,
inout          DDR_cs_n    ,
inout  [3:0]   DDR_dm      ,
inout  [31:0]  DDR_dq      ,
inout  [3:0]   DDR_dqs_n   ,
inout  [3:0]   DDR_dqs_p   ,
inout          DDR_odt     ,
inout          DDR_ras_n   ,
inout          DDR_reset_n ,
inout          DDR_we_n    ,

inout          FIXED_IO_ddr_vrn  ,
inout          FIXED_IO_ddr_vrp  ,
inout  [53:0]  FIXED_IO_mio      ,
inout          FIXED_IO_ps_clk   ,
inout          FIXED_IO_ps_porb  ,
inout          FIXED_IO_ps_srstb
);


wire gpio_rtl_0_tri_o;

wire FCLK_CLK0;
wire peripheral_aresetn;

wire [127:0] S_AXIS_tdata;
wire [15:0]  S_AXIS_tkeep;
wire         S_AXIS_tlast;
wire         S_AXIS_tready;
wire         S_AXIS_tvalid;



reg   [127:0]   adc_data_i ;
adc_to_axistream u_adc_to_axistream(
.clk_i                (FCLK_CLK0                            ),
.reset_n              (peripheral_aresetn                   ),
.adc_capture_en_i     (gpio_rtl_0_tri_o                     ),
.adc_data_i           (128'hAABBCCDDEEFF11223344556677889900),
.s_axis_adc_tready    (S_AXIS_tready                        ),
.s_axis_adc_tvalid    (S_AXIS_tvalid                        ),
.s_axis_adc_tdata     (S_AXIS_tdata                         ),
.s_axis_adc_tkeep     (S_AXIS_tkeep                         ),
.s_axis_adc_tlast     (S_AXIS_tlast                         )
);


// 128'hAABBCCDDEEFF11223344556677889900
//hBBAADDCCFFEE22334411665588770099
// always @(FCLK_CLK0)begin
//   if (!peripheral_aresetn)
//      adc_data_i  <= 0;
//   else
//     adc_data_i <= adc_data_i + 1 ;
// end




  system system_i(
    .DDR_addr           (DDR_addr),
    .DDR_ba             (DDR_ba),
    .DDR_cas_n          (DDR_cas_n),
    .DDR_ck_n           (DDR_ck_n),
    .DDR_ck_p           (DDR_ck_p),
    .DDR_cke            (DDR_cke),
    .DDR_cs_n           (DDR_cs_n),
    .DDR_dm             (DDR_dm),
    .DDR_dq             (DDR_dq),
    .DDR_dqs_n          (DDR_dqs_n),
    .DDR_dqs_p          (DDR_dqs_p),
    .DDR_odt            (DDR_odt),
    .DDR_ras_n          (DDR_ras_n),
    .DDR_reset_n        (DDR_reset_n),
    .DDR_we_n           (DDR_we_n),
    .FCLK_CLK0          (FCLK_CLK0),
    .FIXED_IO_ddr_vrn   (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp   (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio       (FIXED_IO_mio),
    .FIXED_IO_ps_clk    (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb   (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb  (FIXED_IO_ps_srstb),

    .S_AXIS_tdata       (S_AXIS_tdata),
    .S_AXIS_tkeep       (S_AXIS_tkeep),
    .S_AXIS_tlast       (S_AXIS_tlast),
    .S_AXIS_tready      (S_AXIS_tready),
    .S_AXIS_tvalid      (S_AXIS_tvalid),
    .peripheral_aresetn (peripheral_aresetn),
    .gpio_rtl_0_tri_o   (    )
  );




vio_0 u_vio_0  (
.clk         ( FCLK_CLK0           ),
.probe_in0   ( S_AXIS_tlast        ),
.probe_out0  ( gpio_rtl_0_tri_o    )
);

endmodule
