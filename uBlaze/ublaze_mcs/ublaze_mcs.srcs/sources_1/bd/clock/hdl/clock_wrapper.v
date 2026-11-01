//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Sun Nov  1 23:34:16 2026
//Host        : m-huzaifa-IdeaPad-Flex-5-14ALC7 running 64-bit Ubuntu 26.04.1 LTS
//Command     : generate_target clock_wrapper.bd
//Design      : clock_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_wrapper
   (CLK_IN1_D_0_clk_n,
    CLK_IN1_D_0_clk_p,
    clk_out1_0,
    locked_0,
    resetn_0);
  input CLK_IN1_D_0_clk_n;
  input CLK_IN1_D_0_clk_p;
  output clk_out1_0;
  output locked_0;
  input resetn_0;

  wire CLK_IN1_D_0_clk_n;
  wire CLK_IN1_D_0_clk_p;
  wire clk_out1_0;
  wire locked_0;
  wire resetn_0;

  clock clock_i
       (.CLK_IN1_D_0_clk_n(CLK_IN1_D_0_clk_n),
        .CLK_IN1_D_0_clk_p(CLK_IN1_D_0_clk_p),
        .clk_out1_0(clk_out1_0),
        .locked_0(locked_0),
        .resetn_0(resetn_0));
endmodule
