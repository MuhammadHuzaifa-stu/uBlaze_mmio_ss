//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Sun Nov  1 23:31:36 2026
//Host        : m-huzaifa-IdeaPad-Flex-5-14ALC7 running 64-bit Ubuntu 26.04.1 LTS
//Command     : generate_target cpu_wrapper.bd
//Design      : cpu_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module cpu_wrapper
   (Clk_0,
    IO_0_addr_strobe,
    IO_0_address,
    IO_0_byte_enable,
    IO_0_read_data,
    IO_0_read_strobe,
    IO_0_ready,
    IO_0_write_data,
    IO_0_write_strobe,
    Reset_0);
  input Clk_0;
  output IO_0_addr_strobe;
  output [31:0]IO_0_address;
  output [3:0]IO_0_byte_enable;
  input [31:0]IO_0_read_data;
  output IO_0_read_strobe;
  input IO_0_ready;
  output [31:0]IO_0_write_data;
  output IO_0_write_strobe;
  input Reset_0;

  wire Clk_0;
  wire IO_0_addr_strobe;
  wire [31:0]IO_0_address;
  wire [3:0]IO_0_byte_enable;
  wire [31:0]IO_0_read_data;
  wire IO_0_read_strobe;
  wire IO_0_ready;
  wire [31:0]IO_0_write_data;
  wire IO_0_write_strobe;
  wire Reset_0;

  cpu cpu_i
       (.Clk_0(Clk_0),
        .IO_0_addr_strobe(IO_0_addr_strobe),
        .IO_0_address(IO_0_address),
        .IO_0_byte_enable(IO_0_byte_enable),
        .IO_0_read_data(IO_0_read_data),
        .IO_0_read_strobe(IO_0_read_strobe),
        .IO_0_ready(IO_0_ready),
        .IO_0_write_data(IO_0_write_data),
        .IO_0_write_strobe(IO_0_write_strobe),
        .Reset_0(Reset_0));
endmodule
