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
// Module Name: TB_RSTGEN                                                                                            //
// Date: 2021.03.20                                                                                                  //
// Engineer: Dawid Szulc                                                                                             //
// Dependencies: Verilog Hardware Description Language (IEEE Std 1364-2001)                                          //
// Target Devices: FPGA                                                                                              //
// Description: TestBench reset generator                                                                            //
//                                                                                                                   //
// Version: 1.0                                                                                                      //
// Revision 0.01 - File Created                                                                                      //
// Revision 1.00 - Reset generator                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps // Timescale for following modules

module TB_RSTGEN
(
    rst
);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ports declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    output rst; // Generated reset

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Port signals declaration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    reg sig_rst; // rst signal

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Port signals rewriting
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    assign rst = sig_rst; // rst rewriting

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Reset intialization
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        sig_rst = 1'b 0;
        #1000;
        sig_rst = 1'b 1;
    end

endmodule
