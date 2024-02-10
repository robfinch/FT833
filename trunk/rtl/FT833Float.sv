`timescale 1ns / 1ps
// ============================================================================
//        __
//   \\__/ o\    (C) 2014-2024  Robert Finch, Waterloo
//    \  __ /    All rights reserved.
//     \/_//     robfinch<remove>@finitron.ca
//       ||
//
//
// FT816Float5.sv
//  - floating point accelerator
//
// BSD 3-Clause License
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//
// 1000 LUTs 250 FF's
// 140 MHz
// ============================================================================
//
//`define SIMULATION	1'b1

module FT833Float(rst,clk,ph2,cs,rw,vda,ad,db);
input rst;
input clk;
input ph2;
input cs;
input rw;
input vda;
input [3:0] ad;
inout tri [7:0] db;

reg [23:0] ir;
reg [47:0] i;
wire [47:0] o;
reg [7:0] dbo;
assign db = cs & vda & rw ? dbo : 8'bz;

always_ff @(negedge ph2)
if (rst) begin
	ir <= 24'd0;
	i <= 48'd0;
end
else begin
	if (cs & ~rw & vda)
		case(ad)
		4'h0:	i[7:0] <= db;
		4'h1:	i[15:8] <= db;
		4'h2:	i[23:16] <= db;
		4'h3:	i[31:24] <= db;
		4'h4: i[39:32] <= db;
		4'h5: i[47:40] <= db;
		4'h8:	ir[5:0] <= db[5:0];
		4'h9: ir[11:6] <= db[5:0];
		4'hA: ir[17:12] <= db[5:0];
		4'hB:	ir[23:18] <= db[5:0];
		default:	;
		endcase
end

always_comb
	case(ad)
	4'd0:	dbo <= o[7:0];
	4'd1:	dbo <= o[15:8];
	4'd2:	dbo <= o[23:16];
	4'd3:	dbo <= o[31:24];
	4'd4:	dbo <= o[39:32];
	4'd5:	dbo <= o[47:40];
	4'h8:	dbo <= ir[5:0];
	4'h9:	dbo <= ir[11:6];
	4'hA:	dbo <= ir[17:12];
	4'hB:	dbo <= ir[23:18];
	4'hC:	dbo <= sr;
	endcase

SeqFPU2c #(.PREC("SXX")) ufpu1
(
	.rst(rst),
	.clk(clk),
	.ir(ir),
	.i(i),
	.o(o),
	.sr(sr)
);

endmodule
