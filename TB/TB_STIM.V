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
// Module Name: TB_STIM                                                                                              //
// Date: 2021.03.20                                                                                                  //
// Engineer: Dawid Szulc                                                                                             //
// Dependencies: Verilog Hardware Description Language (IEEE Std 1364-2001)                                          //
// Target Devices: FPGA                                                                                              //
// Description: TestBench stimulator                                                                                 //
//                                                                                                                   //
// Version: 1.0                                                                                                      //
// Revision 0.01 - File Created                                                                                      //
// Revision 1.00 - Stimulator                                                                                        //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps // Timescale for following modules

module TB_STIM
(
    clk, rst,
    data, valid, ready
);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Parameters declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    parameter DATA_WIDTH   = 8;  // The width of the write data bus and the read data bus

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ports declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    input clk; // Clock
    input rst; // Reset

    output [DATA_WIDTH - 1 : 0] data;  // Write data in the first pipeline stage
    output                      valid; // Write valid in the first pipeline stage
    output                      ready; // Read ready in the last pipeline stage

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Port signals declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    wire                      sig_rst;   // rst signal
    reg  [DATA_WIDTH - 1 : 0] reg_data;  // data signal
    reg                       reg_valid; // valid signal
    reg                       reg_ready; // ready signal

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Port signals rewriting
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    assign sig_rst   =     rst;   // rst rewriting
    assign     data  = reg_data;  // data rewriting
    assign     valid = reg_valid; // valid rewriting
    assign     ready = reg_ready; // ready rewriting

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data signal stimulator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        reg_data = {DATA_WIDTH{1'b 0}};
        @(posedge sig_rst);
        forever begin
            @(posedge clk);
            reg_data = {$random};
        end
    end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Valid signal stimulator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        reg_valid = 1'b 0;
        @(posedge sig_rst);
        forever begin
            @(posedge clk);
            reg_valid = {$random};
        end
    end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ready signal stimulator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        reg_ready = 1'b 0;
        @(posedge sig_rst);
        forever begin
            @(posedge clk);
            reg_ready = {$random};
        end
    end

endmodule
