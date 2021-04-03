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
// Module Name: TB_CMP                                                                                               //
// Date: 2021.03.20                                                                                                  //
// Engineer: Dawid Szulc                                                                                             //
// Dependencies: Verilog Hardware Description Language (IEEE Std 1364-2001)                                          //
// Target Devices: FPGA                                                                                              //
// Description: TestBench comparator                                                                                 //
//                                                                                                                   //
// Version: 1.0                                                                                                      //
// Revision 0.01 - File Created                                                                                      //
// Revision 1.00 - Comparator                                                                                        //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps // Timescale for following modules

module TB_CMP
(
    clk, rst,
    fdata, fvalid, fready,
    ldata, lvalid, lready
);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Parameters declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    parameter DATA_WIDTH   = 8;  // The width of the write data bus and the read data bus
    parameter STIM_VECTORS = 50; // Amount of stimulation vectors

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ports declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    input clk; // Clock
    input rst; // Reset

    input [DATA_WIDTH - 1 : 0] fdata ; // First data
    input                      fvalid; // First valid
    input                      fready; // First ready
    input [DATA_WIDTH - 1 : 0] ldata ; // Last data
    input                      lvalid; // Last valid
    input                      lready; // Last ready

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Port signals declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    wire                      sig_rst;    // rst signal
    wire [DATA_WIDTH - 1 : 0] sig_fdata;  // fdata signal
    wire                      sig_fvalid; // fvalid signal
    wire                      sig_fready; // fready signal
    wire [DATA_WIDTH - 1 : 0] sig_ldata;  // ldata signal
    wire                      sig_lvalid; // lvalid signal
    wire                      sig_lready; // lready signal

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Port signals rewriting
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    assign sig_rst    = rst;    // rst rewriting
    assign sig_fdata  = fdata;  // fdata rewriting
    assign sig_fvalid = fvalid; // fvalid rewriting
    assign sig_fready = fready; // fready rewriting
    assign sig_ldata  = ldata;  // ldata rewriting
    assign sig_lvalid = lvalid; // lvalid rewriting
    assign sig_lready = lready; // lready rewriting

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Internal signals declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    integer n; // Maximum amount of stimulation vectors
    integer i; // Current amount of stimulation vectors

    integer errors; // Amout of errors during simulation

    reg [DATA_WIDTH - 1 : 0] reg_data [0 : STIM_VECTORS]; // Data to compare

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Add data to compare
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        n = 0;
        @(posedge sig_rst);
        forever begin
            @(posedge clk);
            if (sig_fvalid && sig_fready) begin
                if (n < STIM_VECTORS) begin
                    reg_data[n] = sig_fdata;
                    n = n + 1;
                end
            end
        end
    end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Compare data
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        i = 0;
        errors = 0;
        @(posedge sig_rst);
        forever begin
            @(posedge clk);
            if (sig_lvalid && sig_lready) begin
                if (i < STIM_VECTORS) begin
                    if (reg_data[i] == sig_ldata)
                        $display("SUCCESS: Data equal 0x%h", reg_data[i]);
                    else begin
                        $display("ERROR: Data 0x%h, expected 0x%h", sig_ldata, reg_data[i]);
                        errors = errors + 1;
                    end
                    i = i + 1;
                end
            end
        end
    end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detect end of simulation
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        $display("+----------------------------------------------------------+");
        $display("|                     Simulation begin                     |");
        $display("+----------------------------------------------------------+");
        @(posedge sig_rst);
        forever begin
            @(posedge clk);
            if (i == STIM_VECTORS && n == STIM_VECTORS) begin
                $display("+----------------------------------------------------------+");
                $display("|                    End of simulation                     |");
                if (errors > 0)
                    $display("|          %d errors detected                     |", errors);
                $display("+----------------------------------------------------------+");
                $finish;
            end
        end
    end

endmodule
