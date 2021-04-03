///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PIPE_REG - Pipeline register                                                                                      //
// Copyright (C) 2021  Dawid Szulc                                                                                   //
//                                                                                                                   //
// This program is free software: you can redistribute it and/or modify                                              //
// it under the terms of the GNU General Public License as published by                                              //
// the Free Software Foundation, either version 3 of the License, or                                                 //
// (at your option) any later version.                                                                               //
//                                                                                                                   //
// This program is distributed in the hope that it will be useful,                                                   //
// but WITHOUT ANY WARRANTY; without even the implied warranty of                                                    //
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                                     //
// GNU General Public License for more details.                                                                      //
//                                                                                                                   //
// You should have received a copy of the GNU General Public License                                                 //
// along with this program.  If not, see <https://www.gnu.org/licenses/>.                                            //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name: PIPE                                                                                                //
// Module Name: TB_PIPE_REG                                                                                          //
// Date: 2021.03.20                                                                                                  //
// Engineer: Dawid Szulc                                                                                             //
// Dependencies: Verilog Hardware Description Language (IEEE Std 1364-2001)                                          //
// Target Devices: FPGA                                                                                              //
// Description: TestBench top module                                                                                 //
//                                                                                                                   //
// Version: 1.0                                                                                                      //
// Revision 0.01 - File Created                                                                                      //
// Revision 1.00 - Pipeline TestBench with parameterized pipeline depth                                              //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps  // Timescale for following modules

module TB_PIPE_REG();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Parameters declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    parameter DATA_WIDTH   = 32;  // The width of the write data bus and the read data bus
    parameter PIPE_DEPTH   = 2;   // The number of stages in the pipeline
    parameter STIM_VECTORS = 100; // Amount of stimulation vectors

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Internal signals declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    wire sig_clk; // Clock
    wire sig_rst; // Reset

    genvar i; // Generate variable

    wire [DATA_WIDTH - 1 : 0] sig_data  [0 : PIPE_DEPTH]; // Data between stimulator, all PIPE_REG and comparator
    wire                      sig_valid [0 : PIPE_DEPTH]; // Valid between stimulator, all PIPE_REG and comparator
    wire                      sig_ready [0 : PIPE_DEPTH]; // Ready between stimulator, all PIPE_REG and comparator

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Clock generator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TB_CLKGEN TB_CLKGEN(
        .clk(sig_clk)
    );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Reset generator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TB_RSTGEN TB_RSTGEN(
        .rst(sig_rst)
    );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Stimulator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TB_STIM #(
        .DATA_WIDTH(DATA_WIDTH)
    ) TB_STIM (
        .clk  (sig_clk              ),
        .rst  (sig_rst              ),
        .data (sig_data[0]          ),
        .valid(sig_valid[0]         ),
        .ready(sig_ready[PIPE_DEPTH])
    );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PIPE_DEPTH stages of PIPE_REG
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    generate
        for (i = 0; i < PIPE_DEPTH; i = i + 1) begin
            PIPE_REG #(
                .DATA_WIDTH(DATA_WIDTH)
            ) PIPE_REG (
                .clk   (sig_clk         ),
                .rst   (sig_rst         ),
                .wdata (sig_data[i]     ),
                .wvalid(sig_valid[i]    ),
                .wready(sig_ready[i]    ),
                .rdata (sig_data[i + 1] ),
                .rvalid(sig_valid[i + 1]),
                .rready(sig_ready[i + 1])
            );
        end
    endgenerate

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Comparator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TB_CMP #(
        .DATA_WIDTH  (DATA_WIDTH  ),
        .STIM_VECTORS(STIM_VECTORS)
    ) TB_CMP (
        .clk   (sig_clk              ),
        .rst   (sig_rst              ),
        .fdata (sig_data[0]          ),
        .fvalid(sig_valid[0]         ),
        .fready(sig_ready[0]         ),
        .ldata (sig_data[PIPE_DEPTH] ),
        .lvalid(sig_valid[PIPE_DEPTH]),
        .lready(sig_ready[PIPE_DEPTH])
    );

endmodule
