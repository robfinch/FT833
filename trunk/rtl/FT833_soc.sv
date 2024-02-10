`timescale 1ns / 1ps
// ============================================================================
//        __
//   \\__/ o\    (C) 2014-2024  Robert Finch, Waterloo
//    \  __ /    All rights reserved.
//     \/_//     robfinch<remove>@finitron.ca
//       ||
//
//
// FT833_soc.sv
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
// ============================================================================
//
//`define SIMULATION	1'b1

module FT833_soc(btn, sysclk, ph2, nmi, irq, abort, vpb, vpa, vda, mlb, rw, ad, db, rdy);

input [1:0] btn;
input sysclk;
output ph2;
input nmi;
input irq;
input abort;
output vpb;
output vpa;
output vda;
output mlb;
output rw;
output [25:0] ad;
inout tri [7:0] db;
output rdy;

wire clk, ph2, locked;
wire e;
wire mx;
wire be = 1'b1;
wire [7:0] sr;
reg [7:0] mdb;
wire [7:0] idb;
wire [31:0] iad;
wire [7:0] db_flt;
wire [7:0] db_mmu;

clk_wiz_0 uclkgen1
(
  .clk_out1(clk),
  .clk25(ph2),
  .reset(&btn),
  .locked(locked),
  .clk_in1(sysclk)
);

assign rst = !locked;
wire cs_flt = ad[25:4]==22'h00000006;
wire cs_mmu = ad[25:1]==25'h00000001;
wire cs_tbl = ad[25:16]==10'h0F0;

FT833 ucpu1
(
	.corenum(1),
	.rst(rst),
	.clk(ph2),
	.clko(),
	.cyc(),
	.phi11(),
	.phi12(),
	.phi81(),
	.phi82(),
	.nmi(nmi),
	.irq(irq),
	.abort(abort),
	.e(e),
	.mx(mx),
	.rdy(rdy),
	.be(be),
	.vpa(vpa),
	.vda(vda),
	.mlb(mlb),
	.vpb(vpb),
  .rw(rw),
  .ad(iad),
  .db(idb),
  .err_i(),
  .rty_i()
);

assign db_flt = rw ? 8'bz : idb;
assign db_mmu = rw ? 8'bz : idb;

always_comb
	if (rw)
		casez({cs_flt,cs_mmu,cs_tbl})
		3'b1??:	mdb = db_flt;
		3'b01?:	mdb = db_mmu;
		3'b001:	mdb = db_mmu;
		default:	mdb = db;
		endcase
	else
		mdb = 8'b0;
		
assign idb = rw ? mdb : 8'bz;

FT833Float uflt1
(
	.rst(rst),
	.clk(clk),
	.ph2(ph2),
	.cs(cs_flt),
	.rw(rw),
	.vda(vda),
	.ad(ad[3:0]),
	.db(db_flt)
);

FT833_mmu ummu1
(
	.rst(rst),
	.clk(clk),
	.ph2(ph2),
	.cs(cs_mmu),
	.cs_tbl(cs_tbl),
	.rw(rw),
	.vda(vda),
	.ad_i(iad[23:0]),
	.ad_o(ad),
	.db(db_mmu)
);

endmodule
