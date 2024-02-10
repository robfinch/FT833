// ============================================================================
//        __
//   \\__/ o\    (C) 2015-2024  Robert Finch, Waterloo
//    \  __ /    All rights reserved.
//     \/_//     robfinch<remove>@finitron.ca
//       ||
//
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
// ============================================================================

function [31:0] fn_get_sp;
input [31:0] sp;
begin
  if (m832)
    fn_get_sp = {4'd0,sp};
  else if (m816)
    fn_get_sp = {stack_bank,sp[15:0]};
  else
    fn_get_sp = {stack_page,sp[7:0]};
end
endfunction

function [31:0] fn_add_to_sp;
input [31:0] amt;
begin
  if (m832) begin
    case(stksz)
    2'd0:   fn_add_to_sp = {4'd0,sp[27:8],sp[7:0] + amt[7:0]};
    2'd1:   fn_add_to_sp = {4'd0,sp[27:12],sp[11:0] + amt[11:0]};
    2'd2:   fn_add_to_sp = {4'd0,sp[27:16],sp[15:0] + amt[15:0]};
    2'd3:   fn_add_to_sp = {4'd0,sp[27:24],sp[23:0] + amt[23:0]};
    endcase
  end
  else if (m816)
    fn_add_to_sp = {stack_bank,sp[15:0] + amt[15:0]};
  else
    fn_add_to_sp = {stack_page,sp[7:0] + amt[7:0]};
end
endfunction

task set_sp;
begin
  radr <= fn_get_sp(sp);
  wadr <= fn_get_sp(sp);
  sp <= fn_add_to_sp(32'hFFFFFFFF);
	if (m816)
    bank_wrap <= TRUE;
	else if (!m832)
    page_wrap <= TRUE;
end
endtask

task inc_sp;
begin
  radr <= fn_add_to_sp(32'd1);
  sp <= fn_add_to_sp(32'd1);
  if (m816)
    bank_wrap <= TRUE;
  else if (!m832)
    page_wrap <= TRUE;
end
endtask

function [31:0] fn_sp_inc;
input [31:0] sp_inc;
begin
  fn_sp_inc = fn_add_to_sp(32'd1);
end
endfunction

task tsk_push;
input [5:0] SW8;
input szFlg;
input szFlg2;
begin
  if (m832) begin
		if (szFlg2) begin
	    radr <= fn_add_to_sp(32'hFFFFFFFD);
	    wadr <= fn_add_to_sp(32'hFFFFFFFD);
			sp <= fn_add_to_sp(32'hFFFFFFFC);
			store_what <= SW8;
			s32 <= TRUE;
		end
		else if (szFlg) begin
	    radr <= fn_add_to_sp(32'hFFFFFFFF);
      wadr <= fn_add_to_sp(32'hFFFFFFFF);
      sp <= fn_add_to_sp(32'hFFFFFFFE);
			s16 <= TRUE;
			store_what <= SW8;
		end
		else begin
			radr <= sp;
			wadr <= sp;
			store_what <= SW8;
			sp <= fn_add_to_sp(32'hFFFFFFFF);
		end
  end
	else if (m816) begin
		if (szFlg2) begin
	    radr <= fn_add_to_sp(32'hFFFFFFFD);
      wadr <= fn_add_to_sp(32'hFFFFFFFD);
      sp <= fn_add_to_sp(32'hFFFFFFFC);
      store_what <= SW8;
      s32 <= TRUE;
    end
		else if (szFlg) begin
	    radr <= fn_add_to_sp(32'hFFFFFFFF);
      wadr <= fn_add_to_sp(32'hFFFFFFFF);
      sp <= fn_add_to_sp(32'hFFFFFFFE);
			s16 <= TRUE;
			store_what <= SW8;
		end
		else begin
			radr <= {stack_bank,sp[15:0]};
			wadr <= {stack_bank,sp[15:0]};
			store_what <= SW8;
			sp <= fn_add_to_sp(32'hFFFFFFFF);;
		end
    bank_wrap <= TRUE;
	end
	else begin
    // We could be pushing the CS or DS from
    // emulation mode.
		if (szFlg2) begin
	    radr <= fn_add_to_sp(32'hFFFFFFFD);
      wadr <= fn_add_to_sp(32'hFFFFFFFD);
      sp <= fn_add_to_sp(32'hFFFFFFFC);
      store_what <= SW8;
      s32 <= TRUE;
    end
		else if (szFlg) begin
	    radr <= fn_add_to_sp(32'hFFFFFFFF);
      wadr <= fn_add_to_sp(32'hFFFFFFFF);
      sp <= fn_add_to_sp(32'hFFFFFFFE);
      s16 <= TRUE;
      store_what <= SW8;
    end
    else begin
      radr <= {stack_page,sp[7:0]};
      wadr <= {stack_page,sp[7:0]};
      store_what <= SW8;
      sp <= fn_add_to_sp(32'hFFFFFFFF);
    end
    page_wrap <= TRUE;
	end
	data_nack();
	seg <= ss;
	state <= STORE1;
end
endtask

task moveto_ifetch;
begin
	tGoto(ssm ? SSM1 : IFETCH);
end
endtask

