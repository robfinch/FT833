`timescale 1ns / 1ps
// ============================================================================
//        __
//   \\__/ o\    (C) 2013-2024  Robert Finch, Waterloo
//    \  __ /    All rights reserved.
//     \/_//     robfinch<remove>@finitron.ca
//       ||
//
// FT833.v
//  - 8/16/32 bit CPU
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
// Approx 10561 LUTs   (16900 LC's)
// 9 block rams                                                                       
// ============================================================================
//
`define TRUE		1'b1
`define FALSE		1'b0

`define DEBUG		1'b1

// Comment out the SUPPORT_xxx definitions to remove a core feature.
`define SUPPORT_TASK	1'b1
`define TASK_MEM        512
`define TASK_MEM_ABIT   8
`define TASK_BL         1'b1                // core uses back link register rather than stack
`define SUPPORT_SEG     1'b1
`define ICACHE_4K		1'b1
//`define ICACHE_16K		1'b1
//`define ICACHE_2WAY		1'b1
`define SUPPORT_BCD		1'b1
//`define SUPPORT_CGI		1'b1			// support the control giveaway interrupt
`define SUPPORT_NEW_INSN    1'b1

`define BYTE_RST_VECT	32'h0000FFFC
`define BYTE_NMI_VECT	32'h0000FFFA
`define BYTE_IRQ_VECT	32'h0000FFFE
`define BYTE_ABT_VECT	32'h0000FFF8
`define BYTE_COP_VECT	32'h0000FFF4
`define RST_VECT_816	32'h0000FFFC
`define IRQ_VECT_816	32'h0000FFEE
`define NMI_VECT_816	32'h0000FFEA
`define ABT_VECT_816	32'h0000FFE8
`define BRK_VECT_816	32'h0000FFE6
`define COP_VECT_816	32'h0000FFE4
`define RST_VECT_832	32'h0000FFFC
`define IRQ_VECT_832	32'h0000FFDE
`define NMI_VECT_832	32'h0000FFDA
`define ABT_VECT_832	32'h0000FFD8
`define BRK_VECT_832	32'h0000FFD6
`define COP_VECT_832	32'h0000FFD4

`define BRK			9'h00
`define BRK2		9'h100
`define RTI			9'h40
`define RTS			9'h60
`define PHP			9'h08
`define CLC			9'h18
`define CMC         9'h118
`define PLP			9'h28
`define SEC			9'h38
`define PHA			9'h48
`define CLI			9'h58
`define PLA			9'h68
`define SEI			9'h78
`define DEY			9'h88
`define DEY4		9'h188
`define TYA			9'h98
`define TAY			9'hA8
`define CLV			9'hB8
`define SEV			9'h1B8
`define INY			9'hC8
`define INY4		9'h1C8
`define CLD			9'hD8
`define INX			9'hE8
`define INX4		9'h1E8
`define SED			9'hF8
`define ROR_ACC		9'h6A
`define TXA			9'h8A
`define TXS			9'h9A
`define TAX			9'hAA
`define TSX			9'hBA
`define DEX			9'hCA
`define DEX4		9'h1CA
`define NOP			9'hEA
`define NOP2		9'h1EA
`define TXY			9'h9B
`define TYX			9'hBB
`define TAS			9'h1B
`define TSA			9'h3B
`define TCD			9'h5B
`define TDC			9'h7B
`define STP			9'hDB
`define XCE			9'hFB
`define INA			9'h1A
`define DEA			9'h3A
`define SEP			9'hE2
`define SEP16       9'h1E2
`define REP			9'hC2
`define REP16       9'h1C2
`define PEA			9'hF4
`define PEI			9'hD4
`define PER			9'h62
`define WDM			9'h42
`define PEAxl       9'h1F4
`define CS          9'h11B
`define SEG         9'h13B
`define SEG0        9'h15B
`define IOS         9'h17B
`define PHDS        9'h10B
`define PLDS        9'h12B
`define PHCS        9'h14B
`define PCHIST      9'h1F0
`define CACHE       9'h1E0
`define BYT         9'h18B
`define UBT         9'h19B
`define HAF         9'h1AB
`define UHF         9'h1BB
`define WRD         9'h19A
`define INF         9'h14A
`define AAX         9'h18A
`define RA          9'h1F8
`define CR          9'h1D8

`define ADC_IMM		9'h69
`define ADC_ZP		9'h65
`define ADC_ZPX		9'h75
`define ADC_IX		9'h61
`define ADC_IY		9'h71
`define ADC_IYL		9'h77
`define ADC_ABS		9'h6D
`define ADC_ABSX	9'h7D
`define ADC_ABSY	9'h79
`define ADC_I		9'h72
`define ADC_IL		9'h67
`define ADC_AL		9'h6F
`define ADC_ALX		9'h7F
`define ADC_DSP		9'h63
`define ADC_DSPIY	9'h73
`define ADC_XDSPIY	9'h173
`define ADC_XIYL	9'h177
`define ADC_XIL		9'h167
`define ADC_XABS	9'h16D
`define ADC_XABSX	9'h17D
`define ADC_XABSY	9'h179

`define SBC_IMM		9'hE9
`define SBC_ZP		9'hE5
`define SBC_ZPX		9'hF5
`define SBC_IX		9'hE1
`define SBC_IY		9'hF1
`define SBC_IYL		9'hF7
`define SBC_ABS		9'hED
`define SBC_ABSX	9'hFD
`define SBC_ABSY	9'hF9
`define SBC_I		9'hF2
`define SBC_IL		9'hE7
`define SBC_AL		9'hEF
`define SBC_ALX		9'hFF
`define SBC_DSP		9'hE3
`define SBC_DSPIY	9'hF3
`define SBC_XDSPIY	9'h1F3
`define SBC_XIYL	9'h1F7
`define SBC_XIL		9'h1E7
`define SBC_XABS	9'h1ED
`define SBC_XABSX	9'h1FD
`define SBC_XABSY	9'h1F9

`define CMP_IMM		9'hC9
`define CMP_ZP		9'hC5
`define CMP_ZPX		9'hD5
`define CMP_IX		9'hC1
`define CMP_IY		9'hD1
`define CMP_IYL		8'hD7
`define CMP_ABS		9'hCD
`define CMP_ABSX	9'hDD
`define CMP_ABSY	9'hD9
`define CMP_I		9'hD2
`define CMP_IL		9'hC7
`define CMP_AL		9'hCF
`define CMP_ALX		9'hDF
`define CMP_DSP		9'hC3
`define CMP_DSPIY	9'hD3
`define CMP_XDSPIY	9'h1D3
`define CMP_XIYL	8'h1D7
`define CMP_XIL		9'h1C7
`define CMP_XABS	9'h1CD
`define CMP_XABSX	9'h1DD
`define CMP_XABSY	9'h1D9

`define LDA_IMM8	9'hA5
`define LDA_IMM16	9'hB9
`define LDA_IMM32	9'hA9

`define AND_IMM		9'h29
`define AND_ZP		9'h25
`define AND_ZPX		9'h35
`define AND_IX		9'h21
`define AND_IY		9'h31
`define AND_IYL		9'h37
`define AND_ABS		9'h2D
`define AND_ABSX	9'h3D
`define AND_ABSY	9'h39
`define AND_RIND	9'h32
`define AND_I		9'h32
`define AND_IL		9'h27
`define AND_DSP		9'h23
`define AND_DSPIY	9'h33
`define AND_AL		9'h2F
`define AND_ALX		9'h3F
`define AND_XDSPIY	9'h133
`define AND_XIL		9'h127
`define AND_XIYL	9'h137
`define AND_XABS	9'h12D
`define AND_XABSX	9'h13D
`define AND_XABSY	9'h139

`define ORA_IMM		9'h09
`define ORA_ZP		9'h05
`define ORA_ZPX		9'h15
`define ORA_IX		9'h01
`define ORA_IY		9'h11
`define ORA_IYL		9'h17
`define ORA_ABS		9'h0D
`define ORA_ABSX	9'h1D
`define ORA_ABSY	9'h19
`define ORA_I		9'h12
`define ORA_IL		9'h07
`define ORA_AL		9'h0F
`define ORA_ALX		9'h1F
`define ORA_DSP		9'h03
`define ORA_DSPIY	9'h13
`define ORA_XDSPIY	9'h113
`define ORA_XIL		9'h107
`define ORA_XIYL	9'h117
`define ORA_XABS	9'h10D
`define ORA_XABSX	9'h11D
`define ORA_XABSY	9'h119

`define EOR_IMM		9'h49
`define EOR_ZP		9'h45
`define EOR_ZPX		9'h55
`define EOR_IX		9'h41
`define EOR_IY		9'h51
`define EOR_IYL		9'h57
`define EOR_ABS		9'h4D
`define EOR_ABSX	9'h5D
`define EOR_ABSY	9'h59
`define EOR_RIND	9'h52
`define EOR_I		9'h52
`define EOR_IL		9'h47
`define EOR_DSP		9'h43
`define EOR_DSPIY	9'h53
`define EOR_AL		9'h4F
`define EOR_ALX		9'h5F
`define EOR_XDSPIY	9'h153
`define EOR_XIL		9'h147
`define EOR_XIYL	9'h157
`define EOR_XABS	9'h14D
`define EOR_XABSX	9'h15D
`define EOR_XABSY	9'h159

//`define LDB_RIND	9'hB2	// Conflict with LDX #imm16

`define LDA_IMM		9'hA9
`define LDA_ZP		9'hA5
`define LDA_ZPX		9'hB5
`define LDA_IX		9'hA1
`define LDA_IY		9'hB1
`define LDA_IYL		9'hB7
`define LDA_ABS		9'hAD
`define LDA_ABSX	9'hBD
`define LDA_ABSY	9'hB9
`define LDA_I		9'hB2
`define LDA_IL		9'hA7
`define LDA_AL		9'hAF
`define LDA_ALX		9'hBF
`define LDA_DSP		9'hA3
`define LDA_DSPIY	9'hB3
`define LDA_XDSPIY	9'h1B3
`define LDA_XIL		9'h1A7
`define LDA_XIYL	9'h1B7
`define LDA_XABS	9'h1AD
`define LDA_XABSX	9'h1BD
`define LDA_XABSY	9'h1B9

`define STA_ZP		9'h85
`define STA_ZPX		9'h95
`define STA_IX		9'h81
`define STA_IY		9'h91
`define STA_IYL		9'h97
`define STA_ABS		9'h8D
`define STA_ABSX	9'h9D
`define STA_ABSY	9'h99
`define STA_I		9'h92
`define STA_IL		9'h87
`define STA_AL		9'h8F
`define STA_ALX		9'h9F
`define STA_DSP		9'h83
`define STA_DSPIY	9'h93
`define STA_XDSPIY	9'h193
`define STA_XIL		9'h187
`define STA_XIYL	9'h197
`define STA_XABS	9'h18D
`define STA_XABSX	9'h19D
`define STA_XABSY	9'h199

`define ASL_ACC		9'h0A
`define ASR_ACC		9'h10A
`define ASL_ZP		9'h06
`define ASL_RR		9'h06
`define ASL_ZPX		9'h16
`define ASL_ABS		9'h0E
`define ASL_ABSX	9'h1E
`define ASL_XABS	9'h10E
`define ASL_XABSX	9'h11E

`define ROL_ACC		9'h2A
`define ROL_ZP		9'h26
`define ROL_RR		9'h26
`define ROL_ZPX		9'h36
`define ROL_ABS		9'h2E
`define ROL_ABSX	9'h3E
`define ROL_XABS	9'h12E
`define ROL_XABSX	9'h13E

`define LSR_ACC		9'h4A
`define LSR_ZP		9'h46
`define LSR_RR		9'h46
`define LSR_ZPX		9'h56
`define LSR_ABS		9'h4E
`define LSR_ABSX	9'h5E
`define LSR_XABS	9'h14E
`define LSR_XABSX	9'h15E

`define ROR_ZP		9'h66
`define ROR_ZPX		9'h76
`define ROR_ABS		9'h6E
`define ROR_ABSX	9'h7E
`define ROR_XABS	9'h16E
`define ROR_XABSX	9'h17E

`define DEC_RR		9'hC6
`define DEC_ZP		9'hC6
`define DEC_ZPX		9'hD6
`define DEC_ABS		9'hCE
`define DEC_ABSX	9'hDE
`define DEC_XABS	9'h1CE
`define DEC_XABSX	9'h1DE
`define INC_RR		9'hE6
`define INC_ZP		9'hE6
`define INC_ZPX		9'hF6
`define INC_ABS		9'hEE
`define INC_ABSX	9'hFE
`define INC_XABS	9'h1EE
`define INC_XABSX	9'h1FE
`define INC_IMM     9'h1E9

`define BIT_IMM		9'h89
`define BIT_ZP		9'h24
`define BIT_ZPX		9'h34
`define BIT_ABS		9'h2C
`define BIT_ABSX	9'h3C
`define BIT_XABS	9'h12C
`define BIT_XABSX	9'h13C

// CMP = SUB r0,...
// BIT = AND r0,...
`define BPL			9'h10
`define BVC			9'h50
`define BCC			9'h90
`define BNE			9'hD0
`define BMI			9'h30
`define BVS			9'h70
`define BCS			9'hB0
`define BEQ			9'hF0
`define BRL			9'h82
`define BRA			9'h80
`define BGT         9'h110
`define BLT         9'h130
`define BGE         9'h190
`define BLE         8'h1B0

`define JML			9'h5C
`define JML_IND     9'hDC
`define JML_XIND    9'h1DC
`define JMF			9'h15C
`define JMP			9'h4C
`define JMP_IND		9'h6C
`define JMP_INDX	9'h7C
`define JML_XINDX   9'h17C
`define JSR			9'h20
`define JSL			9'h22
`define JSL_XINDX   9'h1FC
`define JSF			9'h122
`define JSR_INDX	9'hFC
`define RTS			9'h60
`define RTT         9'h160
`define RTL			9'h6B
`define RTF			9'h16B
`define NOP			9'hEA
`define NOP2        9'h1EA
`define RTS_IMM     9'h1C0
`define RTL_IMM     9'h168
`define BSR         9'h128
`define BSL         9'h148

`define PLX			9'hFA
`define PLY			9'h7A
`define PHX			9'hDA
`define PHY			9'h5A
`define WAI			9'hCB
`define PHB			9'h8B
`define PHD			9'h0B
`define PHK			9'h4B
`define XBA			9'hEB
`define XBAW        9'h1EB
`define COP			9'h02
`define PLB			9'hAB
`define PLD			9'h2B
`define MUL         9'h12A

`define LDX_IMM		9'hA2
`define LDX_ZP		9'hA6
`define LDX_ZPX		9'hB6
`define LDX_ZPY		9'hB6
`define LDX_ABS		9'hAE
`define LDX_ABSY	9'hBE
`define LDX_XABS	9'h1AE
`define LDX_XABSY	9'h1BE

`define LDX_IMM32	9'hA2
`define LDX_IMM16	9'hB2
`define LDX_IMM8	9'hA6

`define LDY_IMM		9'hA0
`define LDY_ZP		9'hA4
`define LDY_ZPX		9'hB4
`define LDY_IMM32	9'hA0
`define LDY_IMM8	9'hA1
`define LDY_ABS		9'hAC
`define LDY_ABSX	9'hBC
`define LDY_XABS	9'h1AC
`define LDY_XABSX	9'h1BC

`define STX_ZP		9'h86
`define STX_ZPX		9'h96
`define STX_ZPY		9'h96
`define STX_ABS		9'h8E
`define STX_XABS	9'h18E

`define STY_ZP		9'h84
`define STY_ZPX		9'h94
`define STY_ABS		9'h8C
`define STY_XABS	9'h18C

`define STZ_ZP		9'h64
`define STZ_ZPX		9'h74
`define STZ_ABS		9'h9C
`define STZ_ABSX	9'h9E
`define STZ_XABS	9'h19C
`define STZ_XABSX	9'h19E

`define CPX_IMM		9'hE0
`define CPX_IMM32	9'hE0
`define CPX_IMM8	9'hE2
`define CPX_ZP		9'hE4
`define CPX_ZPX		9'hE4
`define CPX_ABS		9'hEC
`define CPX_XABS	9'h1EC
`define CPY_IMM		9'hC0
`define CPY_IMM32	9'hC0
`define CPY_IMM8	9'hC1
`define CPY_ZP		9'hC4
`define CPY_ZPX		9'hC4
`define CPY_ABS		9'hCC
`define CPY_XABS	9'h1CC

`define TRB_ZP		9'h14
`define TRB_ABS		9'h1C
`define TRB_XABS	9'h11C
`define TSB_ZP		9'h04
`define TSB_ABS		9'h0C
`define TSB_XABS	9'h10C

`define MVP			9'h44
`define MVN			9'h54
`define FILL		9'h144

`define TSK_IMM     9'h1A2
`define TSK_ACC     9'h13A
`define LDT_XABSX   9'h14C
`define LDT_XABS    9'h16C
`define FORK_IMM    9'h1A0
`define FORK_ACC    9'h1AA
`define TTA         9'h11A
`define TASB        9'h19A
`define TSBA        9'h1BA
`define JCR         9'h120
`define JCL         9'h182
`define JCF         9'h162
`define RTC         9'h140 
`define JCI         9'h180
`define TJ          9'h1CB

// Page Two Opcodes
`define PG2			9'h42

`define NOTHING		6'd0
`define SR_70		6'd1
`define SR_158		6'd2
`define WORD_310	6'd4
`define PC_70		6'd5
`define PC_158		6'd6
`define PC_2316		6'd7
`define PC_3124		6'd8
`define PC_310		6'd9
`define WORD_311	6'd10
`define IA_310		6'd11
`define IA_70		6'd12
`define IA_158		6'd13
`define WORD_312	6'd15
`define WORD_313	6'd16
`define WORD_314	6'd17
`define IA_2316		6'd18
`define BYTE_72		6'd25
`define TRIP_2316	6'd26
`define WORD_71S    6'd27
`define LOAD_70     6'd28
`define LOAD_158    6'd29
`define LOAD_2316   6'd30
`define LOAD_3124   6'd31
`define WORD_159S   6'd36
`define WORD_2317S  6'd37
`define WORD_3125S  6'd38
`define IA_3124     6'd39
`define CS_70       6'd40
`define CS_158      6'd41
`define CS_2316     6'd42
`define CS_3124     6'd43
`define LDW_TR70    6'd44
`define LDW_TR158   6'd45
`define CPY_BUF     6'd46
`define LDW_TR70S   6'd47
`define LDW_TR158S  6'd48

`define STW_DEF		6'h1
`define STW_SR158   6'd2
`define STW_CS3124  6'd4
`define STW_CS2316  6'd5
`define STW_CS158   6'd6
`define STW_CS70    6'd7
`define STW_DS3124  6'd8
`define STW_DS2316  6'd9
`define STW_DS158   6'd10
`define STW_DS70    6'd11
`define STW_ACC3124 6'd12
`define STW_ACC2316 6'd13
`define STW_RES8	6'd14
`define STW_TR70    6'd15
`define STW_TR158   6'd16
`define STW_PC3124	6'd19
`define STW_PC2316	6'd20
`define STW_PC158	6'd21
`define STW_PC70	6'd22
`define STW_SR70	6'd23
`define STW_Z8		6'd24
`define STW_DEF8	6'd25
`define STW_DEF70	6'd26
`define STW_DEF158	6'd27
`define STW_DEF2316	6'd28
`define STW_DEF3124 6'd29

`define STW_ACC70	6'd32
`define STW_ACC158	6'd33
`define STW_X70		6'd34
`define STW_X158	6'd35
`define STW_Y70		6'd36
`define STW_Y158	6'd37
`define STW_Z70		6'd38
`define STW_Z158	6'd39
`define STW_DBR		6'd40
`define STW_DPR158	6'd41
`define STW_DPR70	6'd42
`define STW_TMP158	6'd43
`define STW_TMP70	6'd44
`define STW_IA158	6'd45
`define STW_IA70	6'd46
`define STW_BRA		6'd47

`define STW_X3124   6'd48
`define STW_X2316   6'd49
`define STW_Y3124   6'd50
`define STW_Y2316   6'd51
`define STW_Z3124   6'd52
`define STW_Z2316   6'd53
`define STW_IA2316  6'd54
`define STW_IA3124  6'd55
`define STW_TMP3124 6'd56
`define STW_TMP2316 6'd57
`define STW_CPY_BUF 6'd58

// Input Frequency is 32 times the 00 clock

module FT833(corenum, rst, clk, clko, cyc, phi11, phi12, phi81, phi82, nmi, irq, abort, e, mx, rdy, be, vpa, vda, mlb, vpb,
    rw, ad, db, err_i, rty_i);
parameter STORE_SKIPPING = 1'b1;        // set to 1 to skip the store operation if the value didn't change during a RMW instruction
parameter EXTRA_LONG_BRANCHES = 1'b1;   // set to 1 to use an illegal branch displacement ($FF) to indicate a long branch
parameter IO_SEGMENT = 32'hFFD00000;    // set to determine the segment value of the IOS: prefix
parameter PC24 = 1'b1;                  // set if PC is to be true 24 bits (generates slightly more hardware).
parameter POPBF = 1'b0;                 // set to 1 if popping the break flag from the stack is desired
parameter TASK_VECTORING = 1'b1;        // controls whether the core uses task vectors or regular interrupt vectors
//parameter DEAD_CYCLE = 1'b1;            // insert dead cycles between each memory access

// There parameters are not meant to be altered.
parameter RESET1 = 6'd0;
parameter IFETCH = 6'd1;
parameter LDT1 = 6'd2;
parameter TSK1 = 6'd3;
parameter DECODE = 6'd5;
parameter INF1 = 6'd6;
parameter SSM1 = 6'd7;
parameter STORE1 = 6'd9;
parameter STORE2 = 6'd10;
parameter JSR161 = 6'd11;
parameter RTS1 = 6'd12;
parameter IY3 = 6'd13;
parameter BSR1 = 6'd14;
parameter BYTE_IX5 = 6'd15;
parameter BYTE_IY5 = 6'd16;
parameter WAIT_DHIT = 6'd17;
parameter BUS_ERROR = 6'd19;
parameter LOAD_MAC1 = 6'd20;
parameter LOAD_MAC2 = 6'd21;
parameter LOAD_MAC3 = 6'd22;
parameter LOAD_DCACHE = 6'd26;
parameter LOAD_ICACHE = 6'd27;
parameter LOAD_IBUF1 = 6'd28;
parameter LOAD_IBUF2 = 6'd29;
parameter LOAD_IBUF3 = 6'd30;
parameter ICACHE1 = 6'd31;
parameter IBUF1 = 6'd32;
parameter DCACHE1 = 6'd33;
parameter MVN816 = 6'd36;
parameter ICACHE2 = 6'd43;
parameter CALC = 6'd44;
parameter ICACHE3 = 6'd45;

input [31:0] corenum;
input rst;
input clk;
output clko;
output reg [4:0] cyc;
output phi11;
output phi12;
output phi81;
output phi82;
input nmi;
input irq;
input abort;
output e;
output mx;
input rdy;
input be;
output reg vpa;
output reg vda;
output reg mlb;
output reg vpb;
output tri rw;
output tri [31:0] ad;
inout tri [7:0] db;
input err_i;
input rty_i;

parameter TRUE = 1'b1;
parameter FALSE = 1'b0;

reg [31:0] phi1r,phi2r;
reg [31:0] ado1;

reg rwo;
reg [7:0] dbo;
reg [31:0] ado;
reg [7:0] dbi;
reg pg2;
reg [5:0] state;    // machine state number
reg [5:0] retstate; // return state - allows 1 level of state subroutine call
reg [7:0] cnt;      // icache counter / general counter
reg [7:0] maxcnt;
reg [127:0] ir;     // the instruction register
wire [8:0] ir9 = {pg2,ir[7:0]}; // The first byte of the instruction
reg [23:0] pc,opc,npc;
reg pc_cap;                 // pc history capture flag
`ifdef SUPPORT_SEG
reg [31:0] ds;              // data segment
reg [31:0] cs;              // code segment
reg [31:0] ss = 0;          // stack segment
wire [31:0] cspc = cs + pc;
`else
wire [31:0] cspc = pc;
`endif
reg [15:0] dpr;		        // direct page register
reg [7:0] dbr;		        // data bank register
reg [31:0] x,y,acc,sp;      // programming model registers
reg [23:0] stack_page = 24'd1;    // The default stack page for eight bit emulation
reg [15:0] stack_bank = 16'd0;    // The default stack bank for sixteen bit emulation
reg [1:0] stksz;            // size of stack 00=256,01=4095,10=65536,11=16777216
reg [15:0] tmp;
wire [15:0] acc16 = acc[15:0];  // convenience wires
wire [7:0] acc8=acc[7:0];
wire [7:0] x8=x[7:0];
wire [7:0] y8=y[7:0];
wire [15:0] x16 = x[15:0];
wire [15:0] y16 = y[15:0];
wire [15:0] sp16 = sp[15:0];
wire [31:0] acc_dec = acc - 32'd1;
wire [31:0] acc_inc = acc + 32'd1;
wire [31:0] x_dec = x - 32'd1;
wire [31:0] x_inc = x + 32'd1;
wire [31:0] y_dec = y - 32'd1;
wire [31:0] y_inc = y + 32'd1;
reg gie;	// global interrupt enable (set when sp is loaded)
reg hwi;	// hardware interrupt indicator
reg im;
reg cf,vf,nf,zf,df,em,bf;
reg m816,m832;
reg x_bit,m_bit;
reg m16,m32;
reg xb16,xb32;
reg mxb16,mxb32;
reg mib;
reg ssm;
wire DEAD_CYCLE = FALSE;//(vda|vpa) && ado >= 32'h10000;

//wire m16 = m816 & ~m_bit;
//wire xb16 = m816 & ~x_bit;
always_comb
begin
  case ({~m832,~m816,m_bit,x_bit})
  4'b0000:    begin m32 = `FALSE; m16 = `TRUE; xb32 = `TRUE; xb16 = `FALSE; end
  4'b0001:    begin m32 = `FALSE; m16 = `TRUE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b0010:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `TRUE; xb16 = `FALSE; end
  4'b0011:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b0100:    begin m32 = `TRUE; m16 = `FALSE; xb32 = `TRUE; xb16 = `FALSE; end
  4'b0101:    begin m32 = `TRUE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b0110:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `TRUE; xb16 = `FALSE; end
  4'b0111:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b1000:    begin m32 = `FALSE; m16 = `TRUE; xb32 = `FALSE; xb16 = `TRUE; end
  4'b1001:    begin m32 = `FALSE; m16 = `TRUE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b1010:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `TRUE; end
  4'b1011:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b1100:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b1101:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b1110:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  4'b1111:    begin m32 = `FALSE; m16 = `FALSE; xb32 = `FALSE; xb16 = `FALSE; end
  endcase 
end
wire [31:0] acc32 = m32 ? acc : m16 ? {16'h0000,acc[15:0]} : {24'h000000,acc[7:0]}; // for multiply
wire [31:0] x32 = xb32 ? x : xb16 ? {16'h0000,x[15:0]} : {24'h000000,x[7:0]};
wire [31:0] y32 = xb32 ? y : xb16 ? {16'h0000,y[15:0]} : {24'h000000,y[7:0]};
wire [7:0] sr8 = (m816|m832) ? {nf,vf,m_bit,x_bit,df,im,zf,cf} : {nf,vf,1'b0,bf,df,im,zf,cf};
wire [7:0] srx = {3'b0,ssm,1'b0,mib,m832,m816};
reg nmi1,nmi_edge;
reg wai;
reg [31:0] b32;
wire [15:0] b16 = b32[15:0];
wire [7:0] b8 = b32[7:0];
reg [32:0] res32;
reg [63:0] prod64;
wire resc8 = res32[8];
wire resc16 = res32[16];
wire resc32 = res32[32];
wire resz8 = res32[7:0]==8'h00;
wire resz16 = res32[15:0]==16'h0000;
wire resz32 = res32[31:0]==32'd0;
wire resn8 = res32[7];
wire resn16 = res32[15];
wire resn32 = res32[31];
reg [31:0] radr;
reg [31:0] wadr;
reg [31:0] wdat;
wire [7:0] rdat;
reg [5:0] load_what;
reg [5:0] store_what;
reg s8,s16,s32,lds;
reg sop;                // size override prefix
reg [31:0] tmp32;
reg first_ifetch;
reg [31:0] derr_address;

reg [8:0] intno;
reg isBusErr;
reg isBrk,isMove,isSts;
reg isMove816;
reg isRTI,isRTL,isRTS,isRTF;
reg isRMW;
reg isSub;
reg isJsrIndx,isJsrInd,isJLInd;
reg isIY,isIY24,isI24,isIY32,isI32;
reg isDspiy;
reg cs_prefix,tj_prefix;

wire isCmp = ir9==`CPX_ZPX || ir9==`CPX_ABS || ir9==`CPX_XABS ||
			 ir9==`CPY_ZPX || ir9==`CPY_ABS || ir9==`CPY_XABS;
wire isRMW8 =
			 ir9==`ASL_ZP || ir9==`ROL_ZP || ir9==`LSR_ZP || ir9==`ROR_ZP || ir9==`INC_ZP || ir9==`DEC_ZP ||
			 ir9==`ASL_ZPX || ir9==`ROL_ZPX || ir9==`LSR_ZPX || ir9==`ROR_ZPX || ir9==`INC_ZPX || ir9==`DEC_ZPX ||
			 ir9==`ASL_ABS || ir9==`ROL_ABS || ir9==`LSR_ABS || ir9==`ROR_ABS || ir9==`INC_ABS || ir9==`DEC_ABS ||
			 ir9==`ASL_ABSX || ir9==`ROL_ABSX || ir9==`LSR_ABSX || ir9==`ROR_ABSX || ir9==`INC_ABSX || ir9==`DEC_ABSX ||
			 ir9==`ASL_XABS || ir9==`ROL_XABS || ir9==`LSR_XABS || ir9==`ROR_XABS || ir9==`INC_XABS || ir9==`DEC_XABS ||
             ir9==`ASL_XABSX || ir9==`ROL_XABSX || ir9==`LSR_XABSX || ir9==`ROR_XABSX || ir9==`INC_XABSX || ir9==`DEC_XABSX ||
			 ir9==`TRB_ZP || ir9==`TRB_ABS || ir9==`TSB_ZP || ir9==`TSB_ABS ||
			 ir9==`TRB_XABS || ir9==`TSB_XABS
			 ;
wire isBranch = ir9==`BRA || ir9==`BEQ || ir9==`BNE || ir9==`BVS || ir9==`BVC || ir9==`BMI || ir9==`BPL || ir9==`BCS || ir9==`BCC ||
                ir9==`BGT || ir9==`BGE || ir9==`BLT || ir9==`BLE;

// This function needed to make the processor adhere to the page and bank 
// wrapping characteristics of the 65xx. The stack will wrap around within
// page 1 for eight bit emulation, and within bank 0 for 16 bit emulation.
// Direct page addressimg wraps around within bank 0 for 16 bit emulation.

reg bank_wrap;
reg page_wrap;
function [31:0] inc_adr;
input [31:0] adr;
begin
  if (page_wrap)
    inc_adr = {adr[31:8],adr[7:0] + 8'd1};
  else if (bank_wrap)
    inc_adr = {adr[31:16],adr[15:0] + 16'd1};
  else
    inc_adr = adr + 32'd1;
end
endfunction


// Instruction cache.
// The cache is organized as 256 lines of 16 bytes each, for a total of
// 4kB. The processor has access to a window of 16 bytes into the cache
// from the current program counter.

reg wr_icache;
wire [127:0] insn;
ft832_icachemem uicm1
(
  .wclk(clk),
  .wce(rdy),
  .wr(vpa&wr_icache),
  .wa(ado[11:0]),
  .i(db),
  .rclk(~clk),
  .rce(1'b1),
  .pc(cspc[11:0]),
  .insn(insn)
);

reg inv_icache;
reg wr_itag;
wire hit0,hit1;
reg prc_hit0,prc_hit1;
reg inv_iline;

ft832_itagmem uitm1
(
  .wclk(clk),
  .wce(1'b1),
  .wr(wr_itag),
  .wa(ado1),
  .invalidate(inv_icache),
  .invalidate_line(inv_iline),
  .rclk(~clk),
  .rce(1'b1),
  .pc(cspc),
  .hit0(hit0),
  .hit1(hit1)
);

`ifdef SUPPORT_TASK
reg [`TASK_MEM_ABIT:0] tr, otr;
reg [7:0] tsk_pres;                 // register value preservation flags
reg tskm_we;
reg tskm_wr;
reg [`TASK_MEM_ABIT:0] tskm_wa;

wire [31:0] cs_o;
wire [31:0] ds_o;
wire [23:0] pc_o;
wire [31:0] acc_o;
wire [31:0] x_o;
wire [31:0] y_o;
wire [1:0] stksz_o;
wire [27:0] sp_o;
wire [7:0] sr_o;
wire [7:0] srx_o;
wire [7:0] dbr_o;
wire [15:0] dpr_o;
wire [`TASK_MEM_ABIT:0] bl_o;
reg [31:0] cs_i;
reg [31:0] ds_i;
reg [23:0] pc_i;
reg [31:0] acc_i;
reg [31:0] x_i;
reg [31:0] y_i;
reg [1:0] stksz_i;
reg [27:0] sp_i;
reg [7:0] sr_i;
reg [7:0] srx_i;
reg [7:0] dbr_i;
reg [15:0] dpr_i;
reg [`TASK_MEM_ABIT:0] bl_i;
reg [`TASK_MEM_ABIT:0] back_link;

task_mem utskm1
(
  .wclk(clk),
  .wce(tskm_we),
  .wr(tskm_wr),
  .wa(tskm_wa),
  .cs_i(cs_i),
  .ds_i(ds_i),
  .pc_i(pc_i),
  .acc_i(acc_i),
  .x_i(x_i),
  .y_i(y_i),
  .stksz_i(stksz_i),
  .sp_i(sp_i),
  .sr_i(sr_i),
  .srx_i(srx_i),
  .db_i(dbr_i),
  .dpr_i(dpr_i),
  .bl_i(bl_i),
  .rclk(~clk),
  .rce(1'b1),
  .ra(tr),
  .cs_o(cs_o),
  .ds_o(ds_o),
  .pc_o(pc_o),
  .acc_o(acc_o),
  .x_o(x_o),
  .y_o(y_o),
  .stksz_o(stksz_o),
  .sp_o(sp_o),
  .sr_o(sr_o),
  .srx_o(srx_o),
  .db_o(dbr_o),
  .dpr_o(dpr_o),
  .bl_o(bl_o)
);

`endif

reg  [7:0] cpybuf [63:0];   // stack copy buffer

// Registerable decodes
// The following decodes can be registered because they aren't needed until at least the cycle after
// the DECODE stage.

always_ff @(posedge clk)
	if (state==RESET1)
		isBrk <= `TRUE;
	else if (state==DECODE) begin
		isRMW <= isRMW8;
		isRTI <= ir9==`RTI;
		isRTL <= ir9==`RTL || ir9==`RTL_IMM;
		isRTS <= ir9==`RTS || ir9==`RTS_IMM;
		isRTF <= ir9==`RTF;
		isBrk <= ir9==`BRK || ir9==`COP;
		isMove <= ir9==`MVP || ir9==`MVN;
		isJsrIndx <= ir9==`JSR_INDX;
		isJLInd <= ir9==`JML_IND || ir9==`JML_XIND || ir9==`JSL_XINDX || ir9==`JML_XINDX;
		isDspiy <= ir9[4:0]==5'h13;
	end

assign mx = clk ? m_bit : x_bit;
assign e = ~(m816|m832);

wire [15:0] bcaio;
wire [15:0] bcao;
wire [15:0] bcsio;
wire [15:0] bcso;
wire bcaico,bcaco,bcsico,bcsco;
wire bcaico8,bcaco8,bcsico8,bcsco8;

`ifdef SUPPORT_BCD
BCDAdd4 ubcdai1 (.ci(cf),.a(acc16),.b(ir[23:8]),.o(bcaio),.c(bcaico),.c8(bcaico8));
BCDAdd4 ubcda2 (.ci(cf),.a(acc16),.b(b8),.o(bcao),.c(bcaco),.c8(bcaco8));
//BCDSubtract #(.N(4)) ubcdsi1 (.ci(cf),.a(acc16),.b(ir[23:8]),.o(bcsio),.c(bcsico),.c8(bcsico8));
//BCDSubtract #(.N(4)) ubcds2 (.ci(cf),.a(acc16),.b(b8),.o(bcso),.c(bcsco),.c8(bcsco8));
`endif

function carry;
input op;	// 0=add,1=sub
input a;
input b;
input s;
begin
	carry = op? (~a&b)|(s&~a)|(s&b) : (a&b)|(a&~s)|(b&~s);
end
endfunction



wire [7:0] dati = db;

// Evaluate branches
// 
reg takb;
always_comb
case(ir9)
`BEQ:	takb <= zf;
`BNE:	takb <= !zf;
`BPL:	takb <= !nf;
`BMI:	takb <= nf;
`BCS:	takb <= cf;
`BCC:	takb <= !cf;
`BVS:	takb <= vf;
`BVC:	takb <= !vf;
`BRA:	takb <= 1'b1;
`BRL:	takb <= 1'b1;
`BGT:   takb <= !nf & !zf;//(nf & vf & !zf) | (!nf & !vf & !zf);
//`BGE:   takb <= !nf;//(nf & vf) | (!nf & !vf);
`BLE:   takb <= zf | nf;//zf | (nf & !vf) | (!nf & vf);
//`BLT:   takb <= nf;//(nf & !vf) | (!nf & vf);
default:	takb <= 1'b0;
endcase

// Address generation
reg [7:0] mvndst_bank;
reg [7:0] mvnsrc_bank;
reg [31:0] seg;
reg [31:0] ia;
wire [15:0] dpr_zp = {16'h00,ir[15:8]} + dpr;
wire [15:0] dpr_zpx = {{16'h00,ir[15:8]} + x32} + dpr;
wire [15:0] dpr_zpy = {{16'h00,ir[15:8]} + y32} + dpr;
wire [31:0] dpr_zp32 = {16'h00,ir[15:8]} + dpr;
wire [31:0] dpr_zpx32 = {{16'h00,ir[15:8]} + x32} + dpr;
wire [31:0] dpr_zpy32 = {{16'h00,ir[15:8]} + y32} + dpr;
wire [31:0] mvnsrc_address	= m832 ? x32 : {8'h00,ir[23:16],x32[15:0]};
wire [31:0] mvndst_address	= m832 ? y32 : {8'h00,ir[15:8],y32[15:0]};
wire [31:0] iapy8 			= ia + y32;		// Don't add in abs8, already included with ia
wire [31:0] zp_address 		= (m832 ? dpr_zp32 : dpr_zp);
wire [31:0] zpx_address 	= (m832 ? dpr_zpx32 : dpr_zpx);
wire [31:0] zpy_address	 	= (m832 ? dpr_zpy32 : dpr_zpy);
wire [31:0] abs_address 	= {8'h00,dbr,ir[23:8]};
wire [31:0] absx_address 	= m832 ? {8'h00,dbr,ir[23:8]} + x32 :
                                     {8'h00,dbr,ir[23:8] + x16} ;	// simulates 64k bank wrap-around
wire [31:0] absy_address 	= m832 ? {8'h00,dbr,ir[23:8]} + y32 :
                                     {8'h00,dbr,ir[23:8] + y16} ;
wire [31:0] al_address		= {8'h00,ir[31:8]};
wire [31:0] alx_address		= {8'h00,ir[31:8]} + x32;
wire [31:0] xal_address		= ir[39:8];
wire [31:0] xalx_address	= ir[39:8] + x32;
wire [31:0] xaly_address	= ir[39:8] + y32;

wire [31:0] dsp_address = m832 ? sp + ir[15:8] :
                          m816 ? {stack_bank,sp16 + ir[15:8]} : {stack_page,sp[7:0]+ir[15:8]};
reg [31:0] vect;

assign rw = be ? rwo : 1'bz;
assign ad = be ? ado : {32{1'bz}};
assign db = rwo ? {8{1'bz}} : be ? dbo : {8{1'bz}};

wire [23:0] pc_hist_o;

vtdl #(.WID(24),.DEP(64)) pc_hist_buf (
    .clk(clk),
    .ce(state==IFETCH && hit0 && hit1 && pc_cap),
    .a(x[5:0]),
    .d(pc),
    .q(pc_hist_o)
);
/*
c_shift_ram_0 pc_hist_buf (
  .A(x[5:0]),      // input wire [5 : 0] A
  .D({8'h00,pc}),      // input wire [31 : 0] D
  .CLK(clk),  // input wire CLK
  .CE(state==IFETCH && hit0 && hit1 && pc_cap),    // input wire CE
  .Q(pc_hist_o)      // output wire [31 : 0] Q
);
*/
reg [31:0] phi11r,phi12r,phi81r,phi82r;
assign phi11 = phi11r[31];
assign phi12 = phi12r[31];
assign phi81 = phi81r[31];
assign phi82 = phi82r[31];

always_ff @(posedge clk)
if (~rst) begin
	cyc <= 5'd0;
	phi11r <= 32'b01111111111111100000000000000000;
	phi12r <= 32'b00000000000000000111111111111110;
	phi81r <= 32'b01110000011100000111000001110000;
	phi82r <= 32'b00000111000001110000011100000111;
end
else begin
	cyc <= cyc + 5'd1;
	phi11r <= {phi11r[30:0],phi11r[31]};
	phi12r <= {phi12r[30:0],phi12r[31]};
	phi81r <= {phi81r[30:0],phi81r[31]};
	phi82r <= {phi82r[30:0],phi82r[31]};
end

//-----------------------------------------------------------------------------
// Clock control
// - reset or NMI reenables the clock
// - this circuit must be under the clk_i domain
//-----------------------------------------------------------------------------
//
reg cpu_clk_en;
reg clk_en;
wire clkx;
BUFGCE u20 (.CE(cpu_clk_en), .I(clk), .O(clkx) );
assign clko = clkx;
//assign clkx = clk;

always_ff @(posedge clk)
if (~rst) begin
	cpu_clk_en <= 1'b1;
	nmi1 <= 1'b0;
end
else begin
	nmi1 <= nmi;
	if (nmi)
		cpu_clk_en <= 1'b1;
	else
		cpu_clk_en <= clk_en;
end

reg abort1;
reg abort_edge;
reg [2:0] imcd;	// interrupt mask enable count down

always_ff @(posedge clkx)
if (~rst) begin
	vpa <= `FALSE;
	vda <= `FALSE;
	vpb <= `TRUE;
	rwo <= `TRUE;
	ado <= 32'h000000;
	dbo <= 8'h00;
	nmi_edge <= 1'b0;
	wai <= 1'b0;
	pg2 <= 1'b0;
	ir <= 8'hEA;
	cf <= 1'b0;
	df <= 1'b0;
	m816 <= 1'b0;
	m832 <= 1'b0;
	m_bit <= 1'b1;
	x_bit <= 1'b1;
	vect <= `BYTE_RST_VECT;
	state <= RESET1;
	em <= 1'b1;
	pc <= 24'h00FFF0;		// set high-order pc to zero
	cs <= 32'd0;
	ds <= 32'd0;
	ss <= 32'd0;
	stksz <= 2'b00;        // 256 bytes
	dpr <= 16'h0000;
	dbr <= 8'h00;
	acc <= 32'h0;
	x <= 32'h0;
	y <= 32'h0;
	sp <= 32'h1FF;
	clk_en <= 1'b1;
	im <= `TRUE;
	mib <= `FALSE;
	gie <= 1'b0;
	isIY <= 1'b0;
	isIY24 <= 1'b0;
	isI24 <= `FALSE;
	load_what <= `NOTHING;
	abort_edge <= 1'b0;
	abort1 <= 1'b0;
	imcd <= 3'b111;
	inv_icache <= TRUE;
	inv_iline <= FALSE;
	pc_cap <= TRUE;
	tr <= 8'h00;
  tskm_we <= FALSE;
  tskm_wr <= FALSE;
  ssm <= FALSE;
  cs_prefix <= FALSE;
  tj_prefix <= FALSE;
end
else begin
abort1 <= abort;
if (~abort & abort1)
	abort_edge <= 1'b1;
if (~nmi & nmi1)
	nmi_edge <= 1'b1;
if (~nmi|~nmi1)
	clk_en <= 1'b1;
inv_iline <= FALSE;
`ifdef SUPPORT_TASK
tskm_we <= FALSE;
tskm_wr <= FALSE;
`endif
wr_itag <= FALSE;
case(state)
RESET1:
	begin
		radr <= `BYTE_RST_VECT;
		load_what <= `PC_70;
`ifdef SUPPORT_SEG
		cs <= 32'd0;
		ds <= 32'd0;
		ss <= 32'd0;
`endif
		seg <= 32'd0;
		inv_icache <= FALSE;
		state <= LOAD_MAC1;
	end
IFETCH:
  begin
	vda <= FALSE;
	if (hit0&hit1) begin
		if (imcd != 3'b111)
			imcd <= {imcd[1:0],1'b0};
		if (imcd == 3'b000) begin
			imcd <= 3'b111;
			im <= 1'b0;
		end
		vect <= m832 ? `BRK_VECT_832 : m816 ? `BRK_VECT_816 : `BYTE_IRQ_VECT;
		hwi <= `FALSE;
		isBusErr <= `FALSE;
		pg2 <= FALSE;
		isIY <= `FALSE;
		isIY24 <= `FALSE;
		isIY32 <= `FALSE;
		isI24 <= `FALSE;
		isI32 <= `FALSE;
		s8 <= FALSE;
		s16 <= FALSE;
		s32 <= FALSE;
		lds <= FALSE;
		sop <= FALSE;
		cs_prefix <= FALSE;
		tj_prefix <= FALSE;
		bank_wrap <= FALSE;
		page_wrap <= FALSE;
`ifdef SUPPORT_SEG
		seg <= ds;
`endif
		store_what <= (m32 | m16) ? `STW_DEF70 : `STW_DEF;
	    ir <= insn;
		opc <= pc;
		if (nmi_edge | ~irq)
			wai <= 1'b0;
		if (abort_edge) begin
			pc <= opc;
			ir[7:0] <= `BRK;
			abort_edge <= 1'b0;
			hwi <= `TRUE;
			vect <= m832 ? `ABT_VECT_832 : m816 ? `ABT_VECT_816 : `BYTE_ABT_VECT;
			vect[23:16] <= 8'h00;
			seg <= 32'd0;
			tGoto(DECODE);
		end
		else if (nmi_edge & gie) begin
			ir[7:0] <= `BRK;
			nmi_edge <= 1'b0;
			hwi <= `TRUE;
			vect <= m832 ? `NMI_VECT_832 : m816 ? `NMI_VECT_816 : `BYTE_NMI_VECT;
			vect[23:16] <= 8'h00;
			seg <= 32'd0;
			tGoto(DECODE);
		end
		else if (~irq & gie & ~im) begin
			ir[7:0] <= `BRK;
			hwi <= `TRUE;
			if (m832)
			    vect <= `IRQ_VECT_832;
			else if (m816)
				vect <= `IRQ_VECT_816;
			seg <= 32'd0;
			tGoto(DECODE);
		end
		else if (!wai) begin
      if (mib) begin
        set_task_regs(m832 ? 24'd4 : m816 ? 24'd2 : 24'd1);
        case({m832,m816})
        2'd0: acc <= insn[7:0];
        2'd1: acc <= insn[15:0];
        2'd2: acc <= insn[31:0];
        2'd3: acc <= insn[31:0];
        endcase
        x <= pc;
        tsk_pres <= 7'h0C;
        tr <= back_link;
        retstate <= IFETCH;
        tGoto(TSK1);
      end
      else
		    tGoto(DECODE);
		end
		else
			tGoto(IFETCH);
		if (!abort_edge) begin
		casez(ir9)
`ifdef SUPPORT_NEW_INSN
    `SEP16:
      begin
        cf <= cf | ir[8];
        zf <= zf | ir[9];
        im <= im | ir[10];
        df <= df | ir[11];
        if (m816|m832) begin
	        x_bit <= x_bit | ir[12];
	        m_bit <= m_bit | ir[13];
	        //if (ir[13]) acc[31:8] <= 24'd0;
	        if (ir[12]) begin
            x[31:8] <= 24'd0;
            y[31:8] <= 24'd0;
	        end
        end
        vf <= vf | ir[14];
        nf <= nf | ir[15];
        m816 <= m816 | ir[16];
        m832 <= m832 | ir[17];
        mib <= mib | ir[18];
        ssm <= ssm | ir[20];
      end
    `REP16:
        begin
          cf <= cf & ~ir[8];
          zf <= zf & ~ir[9];
          im <= im & ~ir[10];
          df <= df & ~ir[11];
          if (m816|m832) begin
            x_bit <= x_bit & ~ir[12];
            m_bit <= m_bit & ~ir[13];
          end
          vf <= vf & ~ir[14];
          nf <= nf & ~ir[15];
          m816 <= m816 & ~ir[16];
          m832 <= m832 & ~ir[17];
          mib <= mib & ~ir[18];
          ssm <= ssm & ~ir[20];
        end
      `INF:
				begin
					acc <= res32;
					nf <= resn32;
					zf <= resz32;
				end
      `XBAW:
        begin
          acc <= res32;
          nf <= resn16;
          zf <= resz16;
        end
      `AAX:
        begin
          if (m32) begin
            acc <= res32;
						zf <= resz32;
            nf <= resn32;
            vf <= (res32[31] ^ x32[31]) & (1'b1 ^ acc[31] ^ x32[31]);
            cf <= carry(0,acc[31],x32[31],res32[31]);
          end
          else if (m16) begin
            acc[15:0] <= res32[15:0];
            zf <= resz16;
            nf <= resn16;
            vf <= (res32[15] ^ x32[15]) & (1'b1 ^ acc[15] ^ x32[15]);
            cf <= carry(0,acc[15],x32[15],res32[15]);
          end
          else begin
            acc[7:0] <= res32[7:0];
            zf <= resz8;
            nf <= resn8;
            vf <= (res32[7] ^ x32[7]) & (1'b1 ^ acc[7] ^ x32[7]);
            cf <= carry(0,acc[7],x32[7],res32[7]);
          end
        end
`endif
		// Note the break flag is not affected by SEP/REP
		// Setting the index registers to eight bit zeros out the upper part of the register.
		`SEP:
			begin
				cf <= cf | ir[8];
				zf <= zf | ir[9];
				im <= im | ir[10];
				df <= df | ir[11];
				if (m816|m832) begin
					x_bit <= x_bit | ir[12];
					m_bit <= m_bit | ir[13];
					//if (ir[13]) acc[31:8] <= 24'd0;
					if (ir[12]) begin
						x[31:8] <= 24'd0;
						y[31:8] <= 24'd0;
					end
				end
				vf <= vf | ir[14];
				nf <= nf | ir[15];
			end
		`REP:
			begin
				cf <= cf & ~ir[8];
				zf <= zf & ~ir[9];
				im <= im & ~ir[10];
				df <= df & ~ir[11];
				if (m816|m832) begin
					x_bit <= x_bit & ~ir[12];
					m_bit <= m_bit & ~ir[13];
				end
				vf <= vf & ~ir[14];
				nf <= nf & ~ir[15];
			end
		`XBA:
			begin
        acc[15:0] <= res32[15:0];
        nf <= resn8;
        zf <= resz8;
	    end
`ifdef SUPPORT_NEW_INSN
`endif
		`LDY_IMM,`LDY_ZP,`LDY_ZPX,`LDY_ABS,`LDY_ABSX,`LDY_XABS,`LDY_XABSX,
		`TAY,`TXY,`DEY,`INY,`INY4,`DEY4,`PLY:
			begin
        if (xb32) begin
          y <= res32;
          nf <= resn32;
          zf <= resz32;
        end
        else if (xb16) begin
          y <= {16'h0000,res32[15:0]};
          nf <= resn16;
          zf <= resz16;
        end
        else begin
          y <= {24'h000000,res32[7:0]};
          nf <= resn8;
          zf <= resz8;
        end
      end
		`LDX_IMM,`LDX_ZP,`LDX_ZPY,`LDX_ABS,`LDX_ABSY,`LDX_XABS,`LDX_XABSY,
        `TAX,`TYX,`TSX,`DEX,`INX,`INX4,`DEX4,`PLX:
			begin
        if (xb32) begin
          x <= res32;
          nf <= resn32;
          zf <= resz32;
        end
        else if (xb16) begin
          x <= {16'h0000,res32[15:0]};
          nf <= resn16;
          zf <= resz16;
        end
        else begin
          x <= {24'h000000,res32[7:0]};
          nf <= resn8;
          zf <= resz8;
        end
      end
    `TTA:
      begin
        if (m32) begin
          acc <= res32;
          nf <= resn16;
          zf <= resz16;
        end
        else if (m16) begin
          acc[15:0] <= res32[15:0];
          nf <= resn16;
          zf <= resz16;
        end
        else begin
          acc[15:0] <= res32[15:0];
          nf <= resn16;
          zf <= resz16;
        end
      end
		`TSA,`TYA,`TXA,`INA,`DEA,`PLA:
			begin
        if (m32) begin
          acc <= res32;
          nf <= resn32;
          zf <= resz32;
        end
        else if (m16) begin
          acc[15:0] <= {acc[31:16],res32[15:0]};
          nf <= resn16;
          zf <= resz16;
        end
        else begin
          acc[7:0] <= {acc[31:8],res32[7:0]};
          nf <= resn8;
          zf <= resz8;
        end
      end
    `PCHIST:    acc <= res32;
		`TAS,`TXS:
	    begin
        if (m832) sp <= res32;
        else if (m816) sp <= {stack_bank,res32[15:0]};
        else sp <= {stack_page,res32[7:0]};
        gie <= `TRUE;
	    end
		`TCD:	begin dpr <= res32[15:0]; end
		`TDC:	begin acc <= {16'h0000,res32[15:0]}; nf <= resn16; zf <= resz16; end
		`ADC_IMM:
			begin
		    if (m32) begin
					acc <= df ? bcaio : res32;
          cf <= df ? bcaico : carry(0,acc[31],b32[31],res32[31]);
//                        vf <= resv8;
          vf <= (res32[31] ^ b32[31]) & (1'b1 ^ acc[31] ^ b32[31]);
          nf <= df ? bcaio[15] : resn32;
          zf <= df ? bcaio==16'h0000 : resz32;
		    end
				else if (m16) begin
					acc[15:0] <= df ? bcaio : res32[15:0];
					cf <= df ? bcaico : carry(0,acc[15],b32[15],res32[15]);;
//						vf <= resv8;
					vf <= (res32[15] ^ b32[15]) & (1'b1 ^ acc[15] ^ b32[15]);
					nf <= df ? bcaio[15] : resn16;
					zf <= df ? bcaio==16'h0000 : resz16;
				end
				else begin
					acc[7:0] <= df ? bcaio[7:0] : res32[7:0];
					cf <= df ? bcaico8 : carry(0,acc[7],b32[7],res32[7]);
//						vf <= resv8;
					vf <= (res32[7] ^ b32[7]) & (1'b1 ^ acc[7] ^ b32[7]);
					nf <= df ? bcaio[7] : resn8;
					zf <= df ? bcaio[7:0]==8'h00 : resz8;
				end
			end
		`ADC_ZP,`ADC_ZPX,`ADC_IX,`ADC_IY,`ADC_IYL,`ADC_ABS,`ADC_ABSX,`ADC_ABSY,`ADC_I,`ADC_IL,`ADC_AL,`ADC_ALX,`ADC_DSP,`ADC_DSPIY,
		`ADC_XABS,`ADC_XABSX,`ADC_XABSY,`ADC_XIYL,`ADC_XIL,`ADC_XDSPIY:
			begin
		    if (m32) begin
					acc <= df ? bcao : res32;
          cf <= df ? bcaco : carry(0,acc[31],b32[31],res32[31]);
          vf <= (res32[31] ^ b32[31]) & (1'b1 ^ acc[31] ^ b32[31]);
          nf <= df ? bcao[15] : resn32;
          zf <= df ? bcao==16'h0000 : resz32;
		    end
				else if (m16) begin
					acc[15:0] <= df ? bcao : res32[15:0];
					cf <= df ? bcaco : carry(0,acc[15],b32[15],res32[15]);
					vf <= (res32[15] ^ b32[15]) & (1'b1 ^ acc[15] ^ b32[15]);
					nf <= df ? bcao[15] : resn16;
					zf <= df ? bcao==16'h0000 : resz16;
				end
				else begin
					acc[7:0] <= df ? bcao[7:0] : res32[7:0];
					cf <= df ? bcaco8 : carry(0,acc[7],b32[7],res32[7]);
					vf <= (res32[7] ^ b32[7]) & (1'b1 ^ acc[7] ^ b32[7]);
					nf <= df ? bcao[7] : resn8;
					zf <= df ? bcao[7:0]==8'h00 : resz8;
				end
			end
		`SBC_IMM:
			begin
				if (m32) begin
          acc <= df ? bcsio : res32;
          cf <= ~(df ? bcsico : carry(1,acc[31],b32[31],res32[31]));
          vf <= (1'b1 ^ res32[31] ^ b32[31]) & (acc[31] ^ b32[31]);
          nf <= df ? bcsio[15] : resn16;
          zf <= df ? bcsio==16'h0000 : resz16;
        end
				else if (m16) begin
					acc[15:0] <= df ? bcsio : res32[15:0];
					cf <= ~(df ? bcsico : carry(1,acc[15],b32[15],res32[15]));
					vf <= (1'b1 ^ res32[15] ^ b32[15]) & (acc[15] ^ b32[15]);
					nf <= df ? bcsio[15] : resn16;
					zf <= df ? bcsio==16'h0000 : resz16;
				end
				else begin
					acc[7:0] <= df ? bcsio[7:0] : res32[7:0];
					cf <= ~(df ? bcsico8 : carry(1,acc[7],b32[7],res32[7]));
					vf <= (1'b1 ^ res32[7] ^ b32[7]) & (acc[7] ^ b32[7]);
					nf <= df ? bcsio[7] : resn8;
					zf <= df ? bcsio[7:0]==8'h00 : resz8;
				end
			end
		`SBC_ZP,`SBC_ZPX,`SBC_IX,`SBC_IY,`SBC_IYL,`SBC_ABS,`SBC_ABSX,`SBC_ABSY,`SBC_I,`SBC_IL,`SBC_AL,`SBC_ALX,`SBC_DSP,`SBC_DSPIY,
		`SBC_XABS,`SBC_XABSX,`SBC_XABSY,`SBC_XIYL,`SBC_XIL,`SBC_XDSPIY:
			begin
				if (m32) begin
          acc <= df ? bcso : res32;
          vf <= (1'b1 ^ res32[31] ^ b32[31]) & (acc[31] ^ b32[31]);
          cf <= ~(df ? bcsco : carry(1,acc[31],b32[31],res32[31]));
          nf <= df ? bcso[15] : resn16;
          zf <= df ? bcso==16'h0000 : resz16;
        end
				else if (m16) begin
					acc[15:0] <= df ? bcso : res32[15:0];
					vf <= (1'b1 ^ res32[15] ^ b32[15]) & (acc[15] ^ b32[15]);
					cf <= ~(df ? bcsco : carry(1,acc[15],b32[15],res32[15]));
					nf <= df ? bcso[15] : resn16;
					zf <= df ? bcso==16'h0000 : resz16;
				end
				else begin
					acc[7:0] <= df ? bcso[7:0] : res32[7:0];
					vf <= (1'b1 ^ res32[7] ^ b32[7]) & (acc[7] ^ b32[7]);
					cf <= ~(df ? bcsco8 : carry(1,acc[7],b32[7],res32[7]));
					nf <= df ? bcso[7] : resn8;
					zf <= df ? bcso[7:0]==8'h00 : resz8;
				end
			end
		`CMP_IMM,`CMP_ZP,`CMP_ZPX,`CMP_IX,`CMP_IY,`CMP_IYL,`CMP_ABS,`CMP_ABSX,`CMP_ABSY,`CMP_I,`CMP_IL,`CMP_AL,`CMP_ALX,`CMP_DSP,`CMP_DSPIY,
		`CMP_XABS,`CMP_XABSX,`CMP_XABSY,`CMP_XIYL,`CMP_XIL,`CMP_XDSPIY:
		        if (m32) begin cf <= ~carry(1,acc[31],b32[31],res32[31]); nf <= resn32; zf <= resz32; end 
				else if (m16) begin cf <= ~carry(1,acc[15],b32[15],res32[15]); nf <= resn16; zf <= resz16; end
				else begin          cf <= ~carry(1,acc[7],b32[7],res32[7]); nf <= resn8; zf <= resz8; end
		`CPX_IMM,`CPX_ZP,`CPX_ABS,`CPX_XABS:
      if (xb32) begin cf <= ~carry(1,x[31],b32[31],res32[31]); nf <= resn32; zf <= resz32; end 
          else if (xb16) begin cf <= ~carry(1,x[15],b32[15],res32[15]); nf <= resn16; zf <= resz16; end
          else begin           cf <= ~carry(1,x[7],b32[7],res32[7]); nf <= resn8; zf <= resz8; end
		`CPY_IMM,`CPY_ZP,`CPY_ABS,`CPY_XABS:
		        if (xb32) begin cf <= ~carry(1,y[31],b32[31],res32[31]); nf <= resn32; zf <= resz32; end 
				else if (xb16) begin cf <= ~carry(1,y[15],b32[15],res32[15]); nf <= resn16; zf <= resz16; end
				else begin           cf <= ~carry(1,y[7],b32[7],res32[7]); nf <= resn8; zf <= resz8; end
		`BIT_IMM,`BIT_ZP,`BIT_ZPX,`BIT_ABS,`BIT_ABSX,`BIT_XABS,`BIT_XABSX:
		        if (m32) begin nf <= b32[31]; vf <= b32[30]; zf <= resz32; end 
				else if (m16) begin nf <= b32[15]; vf <= b32[14]; zf <= resz16; end
				else begin          nf <= b32[7]; vf <= b32[6]; zf <= resz8; end
		`TRB_ZP,`TRB_ABS,`TSB_ZP,`TSB_ABS,`TRB_XABS,`TSB_XABS:
		    if (m32) begin zf <= resz32; end
			else if (m16) begin zf <= resz16; end
			else begin          zf <= resz8; end
		`LDA_IMM,`LDA_ZP,`LDA_ZPX,`LDA_IX,`LDA_IY,`LDA_IYL,`LDA_ABS,`LDA_ABSX,`LDA_ABSY,`LDA_I,`LDA_IL,`LDA_AL,`LDA_ALX,`LDA_DSP,`LDA_DSPIY,
		`LDA_XABS,`LDA_XABSX,`LDA_XABSY,`LDA_XIYL,`LDA_XIL,`LDA_XDSPIY,
		`AND_IMM,`AND_ZP,`AND_ZPX,`AND_IX,`AND_IY,`AND_IYL,`AND_ABS,`AND_ABSX,`AND_ABSY,`AND_I,`AND_IL,`AND_AL,`AND_ALX,`AND_DSP,`AND_DSPIY,
		`AND_XABS,`AND_XABSX,`AND_XABSY,`AND_XIYL,`AND_XIL,`AND_XDSPIY,
		`ORA_IMM,`ORA_ZP,`ORA_ZPX,`ORA_IX,`ORA_IY,`ORA_IYL,`ORA_ABS,`ORA_ABSX,`ORA_ABSY,`ORA_I,`ORA_IL,`ORA_AL,`ORA_ALX,`ORA_DSP,`ORA_DSPIY,
		`ORA_XABS,`ORA_XABSX,`ORA_XABSY,`ORA_XIYL,`ORA_XIL,`ORA_XDSPIY,
		`EOR_IMM,`EOR_ZP,`EOR_ZPX,`EOR_IX,`EOR_IY,`EOR_IYL,`EOR_ABS,`EOR_ABSX,`EOR_ABSY,`EOR_I,`EOR_IL,`EOR_AL,`EOR_ALX,`EOR_DSP,`EOR_DSPIY,
		`ORA_XABS,`ORA_XABSX,`ORA_XABSY,`ORA_XIYL,`ORA_XIL,`ORA_XDSPIY:
		    if (m32) begin acc <= res32; nf <= resn32; zf <= resz32; end
			else if (m16) begin acc[15:0] <= res32[15:0]; nf <= resn16; zf <= resz16; end
			else begin acc[7:0] <= res32[7:0]; nf <= resn8; zf <= resz8; end
		`ASR_ACC:
      if (m32) begin acc <= res32; cf <= acc[0]; nf <= resn32; zf <= resz32; end 
      else if (m16) begin acc[15:0] <= res32[15:0]; cf <= acc[0]; nf <= resn16; zf <= resz16; end
      else begin acc[7:0] <= res32[7:0]; cf <= acc[0]; nf <= resn8; zf <= resz8; end
    `ASL_ACC,
    `ROL_ACC:
      if (m32) begin acc <= res32; cf <= acc[31]; nf <= resn32; zf <= resz32; end 
      else if (m16) begin acc[15:0] <= res32[15:0]; cf <= acc[15]; nf <= resn16; zf <= resz16; end
      else begin acc[7:0] <= res32[7:0]; cf <= acc[7]; nf <= resn8; zf <= resz8; end
		`LSR_ACC,
		`ROR_ACC:
      if (m32) begin acc <= res32; cf <= acc[0]; nf <= resn32; zf <= resz32; end 
      else if (m16) begin acc[15:0] <= res32[15:0]; cf <= acc[0]; nf <= resn16; zf <= resz16; end
      else begin acc[7:0] <= res32[7:0]; cf <= acc[0]; nf <= resn8; zf <= resz8; end
		`ASL_ZP,`ASL_ZPX,`ASL_ABS,`ASL_ABSX,`ASL_XABS,`ASL_XABSX,
		`ROL_ZP,`ROL_ZPX,`ROL_ABS,`ROL_ABSX,`ROL_XABS,`ROL_XABSX:
     if (m32) begin cf <= b32[31]; nf <= resn32; zf <= resz32; end 
     else if (m16) begin cf <= b32[15]; nf <= resn16; zf <= resz16; end
     else begin cf <= b32[7]; nf <= resn8; zf <= resz8; end
		`LSR_ZP,`LSR_ZPX,`LSR_ABS,`LSR_ABSX,`LSR_XABS,`LSR_XABSX,
		`ROR_ZP,`ROR_ZPX,`ROR_ABS,`ROR_ABSX,`ROR_XABS,`ROR_XABSX:
      if (m32) begin cf <= b32[0]; nf <= resn32; zf <= resz32; end 
      else if (m16) begin cf <= b32[0]; nf <= resn16; zf <= resz16; end
      else begin cf <= b32[0]; nf <= resn8; zf <= resz8; end
		`INC_IMM,
		`INC_ZP,`INC_ZPX,`INC_ABS,`INC_ABSX,`INC_XABS,`INC_XABSX,
		`DEC_ZP,`DEC_ZPX,`DEC_ABS,`DEC_ABSX,`DEC_XABS,`DEC_XABSX:
      if (m32) begin nf <= resn32; zf <= resz32; end 
      else if (m16) begin nf <= resn16; zf <= resz16; end
      else begin nf <= resn8; zf <= resz8; end
		`PLB:	begin dbr <= res32[7:0]; nf <= resn8; zf <= resz8; end
`ifdef SUPPORT_NEW_INSN
		`MUL:   begin
	            acc <= prod64[31:0];
	            x <= prod64[63:32];
	            zf <= prod64==64'd0;
	            nf <= prod64[63];
	            vf <= prod64[63:32]!=32'd0;
		        end
`ifdef SUPPORT_SEG
		`PLDS:	begin ds <= res32; nf <= resn32; zf <= resz32; end
`endif
`endif
        `PLD:   begin dpr <= res32[15:0]; nf <= resn16; zf <= resz16; end
		endcase
		end	// !abort_edge
	end
	else begin
    prc_hit0 <= FALSE;
    prc_hit1 <= FALSE;
    tGoto(ICACHE1);
	end
	end

// Decode
DECODE:
  begin
		moveto_ifetch();
    inc_pc(24'd1);
		case(ir9)
		`PG2: begin
		      pg2 <= TRUE;
		      ir <= {8'h00,ir[127:8]};
		      tGoto(DECODE);
		      end
`ifdef SUPPORT_NEW_INSN
`ifdef SUPPORT_SEG
		`CS:  begin
		      seg <= cs;
		      cs_prefix <= TRUE;
		      ir <= {8'h00,ir[127:8]};
		      pg2 <= FALSE;
		      tGoto(DECODE);
		      end
		`IOS: begin
		      seg <= IO_SEGMENT;
		      ir <= {8'h00,ir[127:8]};
		      pg2 <= FALSE;
              tGoto(DECODE);
		      end
		`SEG0:
          begin
            seg <= 32'd0;
            ir <= {8'h00,ir[127:8]};
			      pg2 <= FALSE;
            tGoto(DECODE);
          end
     `SEG:
	     	begin
	        inc_pc(24'd5);
		      seg <= ir[39:8];
		      ir <= {40'h00,ir[127:40]};
		      pg2 <= FALSE;
		      tGoto(DECODE);
	      end
`endif
        `TJ:  begin tj_prefix <= TRUE; ir <= {8'h00,ir[127:8]}; pg2 <= FALSE; tGoto(DECODE); end
		`BYT: begin sop <= TRUE; lds <= TRUE; ir <= {8'h00,ir[127:8]}; pg2 <= FALSE; tGoto(DECODE); end
		`UBT: begin sop <= TRUE; ir <= {8'h00,ir[127:8]}; pg2 <= FALSE; tGoto(DECODE); end
		`HAF: begin sop <= TRUE; lds <= TRUE; s16 <= TRUE; ir <= {8'h00,ir[127:8]}; pg2 <= FALSE; tGoto(DECODE); end
		`UHF: begin sop <= TRUE; s16 <= TRUE; ir <= {8'h00,ir[127:8]}; pg2 <= FALSE; tGoto(DECODE); end
		`UHF: begin sop <= TRUE; s16 <= TRUE; ir <= {8'h00,ir[127:8]}; pg2 <= FALSE; tGoto(DECODE); end
		`WRD: begin sop <= TRUE; s32 <= TRUE; ir <= {8'h00,ir[127:8]}; pg2 <= FALSE; tGoto(DECODE); end
		`SEP16:	  inc_pc(24'd3);	// see byte_ifetch
        `REP16:   inc_pc(24'd3);
`endif
		`SEP:	inc_pc(24'd2);	// see byte_ifetch
		`REP:	inc_pc(24'd2);
		`PCHIST:  res32 <= pc_hist_o;
		// XBA cannot be done in the ifetch stage because it'd repeat when there
		// was a cache miss, causing the instruction to be done twice.
		`XBA:   res32 <= {acc[31:16],acc[7:0],acc[15:8]};
		`STP:	begin clk_en <= 1'b0; end
		// Switching the processor mode always zeros out the upper part of the index registers.
		// switching to emulation mode sets 8 bit memory/indexes
		`XCE:	begin
					m816 <= ~cf;
					m832 <= ~vf;
					cf <= ~m816;
					vf <= ~m832;
					if (cf) begin		
						m_bit <= 1'b1;
						x_bit <= 1'b1;
						sp[31:8] <= stack_page;
					end
					x[31:8] <= 24'd0;
					y[31:8] <= 24'd0;
				end
//		`NOP:	;	// may help routing
		`CLC:	begin cf <= 1'b0; end
		`SEC:	begin cf <= 1'b1; end
		`CMC:   cf <= ~cf;
		`CLV:	begin vf <= 1'b0; end
		`CLI:	begin imcd <= 3'b110; end
		`SEI:	begin im <= 1'b1; end
		`CLD:	begin df <= 1'b0; end
		`SED:	begin df <= 1'b1; end
		`WAI:	begin wai <= 1'b1; end
		`DEX:	begin res32 <= x_dec; end
		`INX:	begin res32 <= x_inc; end
		`DEY:	begin res32 <= y_dec; end
		`INY:	begin res32 <= y_inc; end
`ifdef SUPPORT_NEW_INSN
		`XBAW:    res32 <= {acc[15:0],acc[31:16]};
		`DEX4:    res32 <= x - 32'd4;
		`DEY4:    res32 <= y - 32'd4;
		`INX4:    res32 <= x + 32'd4;
		`INY4:    res32 <= y + 32'd4;
		`AAX:     res32 <= acc32 + x32;
`ifdef SUPPORT_TASK
		`TTA:       res32 <= tr;
`endif
`endif
		`DEA:	res32 <= acc_dec;
		`INA:	res32 <= acc_inc;
		`TSX,`TSA:	res32 <= sp;
		`TXS,`TXA,`TXY:	begin res32 <= x32; end
		`TAX,`TAY:	begin res32 <= acc; end
		`TAS:	res32 <= acc;
		`TYA,`TYX:	begin res32 <= y32; end
		`TDC:		begin res32 <= dpr; end
		`TCD:		begin res32 <= acc; end
		`ASL_ACC:   res32 <= {acc,1'b0};
		`ROL_ACC:	res32 <= {acc,cf};
		`LSR_ACC:	if (m32) res32 <= {acc[0],1'b0,acc[31:1]};
		            else if (m16) res32 <= {acc[0],17'b0,acc[15:1]};
		            else res32 <= {acc[0],25'b0,acc[7:1]};
`ifdef SUPPORT_NEW_INSN
		`ASR_ACC:	if (m32) res32 <= {acc[0],acc[31],acc[31:1]};
                    else if (m16) res32 <= {acc[0],16'b0,acc[15],acc[15:1]};
                    else res32 <= {acc[0],24'b0,acc[7],acc[7:1]};
        `MUL:       prod64 <= acc32 * x32;
        `INF:       begin
                    otr <= tr;
                    tr <= x32[15:4];
                    tGoto(INF1);
                    end
`endif
		`ROR_ACC:	if (m32) res32 <= {acc[0],cf,acc[31:1]};
		            else if (m16) res32 <= {acc[0],16'b0,cf,acc[15:1]};
		            else res32 <= {acc[0],24'b0,cf,acc[7:1]};
`ifdef SUPPORT_SEG
		`RTF,`RTS_IMM,`RTL_IMM:
			begin
			    inc_pc(24'd2);
                inc_sp();
                seg <= ss;
                load_what <= `PC_70;
                state <= LOAD_MAC1;
            end
`endif
		`RTS,`RTL:
			begin
			    inc_sp();
			    seg <= ss;
				load_what <= `PC_70;
				state <= LOAD_MAC1;
			end
		`RTI:	begin
			    seg <= ss;
`ifdef SUPPORT_TASK
		        if (m832) begin
                    set_task_regs(24'd1);
`ifdef TASK_BL
                    begin
                        tr <= back_link;
                        tsk_pres <= 7'h0;
                        retstate <= IFETCH;
                        tGoto(TSK1);
                    end
`else
                    begin
                        sp_i <= fn_add_to_sp(32'd2);
                        inc_sp();
                        seg <= ss;
                        tsk_pres <= 7'd0;
                        load_what <= `LDW_TR70S;
                        state <= LOAD_MAC1;
                    end
`endif
                end
                else
`endif
                begin
                    inc_sp();
                    if (bf) pc_cap <= TRUE;
                    load_what <= `SR_70;
                    state <= LOAD_MAC1;
				end
				end
		`PHP:   begin
		             if (m832)
		                 tsk_push(`STW_SR158,1,0);
		             else
		                 tsk_push(`STW_SR70,0,0);
		        end
        `PHA:   tsk_push(`STW_ACC70,m16,m32);
		`PHX:	tsk_push(`STW_X70,xb16,xb32);
		`PHY:	tsk_push(`STW_Y70,xb16,xb32);
//		`PHCS:  tsk_push(`STW_CS0,0,1);
        `PHK:   tsk_push(`STW_PC2316,0,0);
		`PHB:   tsk_push(`STW_DBR,0,0);
		`PHD:   tsk_push(`STW_DPR70,1,0);
		`PEA:
            begin
                inc_pc(24'd3);
                wdat <= ir[23:8];
                tsk_push(`STW_DEF70,1,0);
            end
`ifdef SUPPORT_NEW_INSN
        `PEAxl:
            begin
                inc_pc(24'd5);
                wdat <= ir[39:8];
                tsk_push(`STW_DEF70,0,1);
            end
`endif
        `PER:
            begin
                inc_pc(24'd3);
                wdat <= pc[15:0] + ir[23:8] + 16'd3;
                tsk_push(`STW_DEF70,1,0);
            end
		`PLP:
			begin
                inc_sp();
                seg <= ss;
				load_what <= `SR_70;
				state <= LOAD_MAC1;
			end
		`PLA:
			begin
			    inc_sp();
                seg <= ss;
                if (m32) s32 <= TRUE;
                else if (m16) s16 <= TRUE;
                load_what <= `WORD_71S;
				state <= LOAD_MAC1;
				retstate <= ssm ? SSM1:IFETCH;
			end
		`PLX,`PLY:
			begin
			    inc_sp();
                seg <= ss;
                if (xb32) s32 <= TRUE;
                else if (xb16) s16 <= TRUE;
				load_what <= `WORD_71S;
				state <= LOAD_MAC1;
				retstate <= ssm ? SSM1:IFETCH;
			end
		`PLB:
			begin
			    inc_sp();
                seg <= ss;
  				load_what <= `WORD_71S;
				state <= LOAD_MAC1;
				retstate <= ssm ? SSM1 : IFETCH;
			end
		`PLD:
			begin
			    inc_sp();
                seg <= ss;
			    s16 <= TRUE;
  				load_what <= `WORD_71S;
				state <= LOAD_MAC1;
				retstate <= ssm ? SSM1 : IFETCH;
			end
		// Handle # mode
        `LDA_IMM:
            begin
                if (m32) inc_pc(24'd5);
                else if (m16) inc_pc(24'd3);
                else inc_pc(24'd2);
                res32 <= ir[39:8];
            end
        `LDX_IMM,`LDY_IMM:
            begin
                if (xb32) inc_pc(24'd5);
                else if (xb16) inc_pc(24'd3);
                else inc_pc(24'd2);
                res32 <= ir[39:8];
            end
            // We don't care what the high order bits of the calculation
            // are for 8/16 bit results, so we can safely use 32 bits
            // from the instruction stream. The high order bits will be
            // invalid, but don't get stored anyway for 8/16 bit ops.
            // This is to save some hardware.
        `ADC_IMM:
            begin
                b32 <= ir[39:8];        // for overflow calc
                if (m32) inc_pc(24'd5);
                else if (m16) inc_pc(24'd3);
                else inc_pc(24'd2);
                res32 <= acc + ir[39:8] + {31'b0,cf};
            end
        `SBC_IMM:
            begin
                b32 <= ir[39:8];        // for overflow calc
                if (m32) inc_pc(24'd5);
                else if (m16) inc_pc(24'd3);
                else inc_pc(24'd2);
                res32 <= acc - ir[39:8] - {31'b0,~cf};
            end
        `AND_IMM,`BIT_IMM:
            begin
                if (m32) inc_pc(24'd5);
                else if (m16) inc_pc(24'd3);
                else inc_pc(24'd2);
                res32 <= acc & ir[39:8];
                b32 <= ir[39:8];    // for bit flags
            end
        `ORA_IMM:
            begin
                if (m32) inc_pc(24'd5);
                else if (m16) inc_pc(24'd3);
                else inc_pc(24'd2);
                res32 <= acc | ir[39:8];
            end
        `EOR_IMM:
            begin
                if (m32) inc_pc(24'd5);
                else if (m16) inc_pc(24'd3);
                else inc_pc(24'd2);
                res32 <= acc ^ ir[39:8];
            end
        `CMP_IMM:
            begin
                b32 <= ir[39:8];        // for carry calc
                res32 <= {1'd0,acc} - {1'd0,ir[39:8]};
                if (m32) inc_pc(24'd5);
                else if (m16) inc_pc(24'd3);
                else inc_pc(24'd2);
            end
        `CPX_IMM:
            begin
                b32 <= ir[39:8];        // for carry calc
                res32 <= x32 - ir[39:8];
                if (xb32) inc_pc(24'd5);
                else if (xb16) inc_pc(24'd3);
                else inc_pc(24'd2);
            end
        `CPY_IMM:
            begin
                b32 <= ir[39:8];        // for carry calc
                res32 <= y32 - ir[39:8];
                if (xb32) inc_pc(24'd5);
                else if (xb16) inc_pc(24'd3);
                else inc_pc(24'd2);
            end
		// Handle zp mode
        `LDA_ZP:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `LDX_ZP,`LDY_ZP:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= xb16;
                mxb32 <= xb32;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                retstate <= ssm ? SSM1 : IFETCH;
                state <= LOAD_MAC2;
                bank_wrap <= !m832;
            end
        `ADC_ZP,`SBC_ZP,`AND_ZP,`ORA_ZP,`EOR_ZP,`CMP_ZP,
        `BIT_ZP,
        `ASL_ZP,`ROL_ZP,`LSR_ZP,`ROR_ZP,`TRB_ZP,`TSB_ZP:
            begin
                inc_pc(24'd2);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                radr <= zp_address;
                wadr <= zp_address;
                data_read(zp_address,1);
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
        `INC_ZP,`DEC_ZP:
            begin
                inc_pc(24'd2);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                radr <= zp_address;
                wadr <= zp_address;
                data_read(zp_address,1);
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
        `INC_IMM:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                radr <= zp_address;
                wadr <= zp_address;
                data_read(zp_address,1);
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
        `CPX_ZP,`CPY_ZP:
            begin
                inc_pc(24'd2);
                mxb16 <= xb16;
                mxb32 <= xb32;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                radr <= zp_address;
                data_read(zp_address,1);
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
        `STA_ZP:
            begin
                inc_pc(24'd2);
                wadr <= zp_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
        `STX_ZP:
            begin
                inc_pc(24'd2);
                wadr <= zp_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_X70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
        `STY_ZP:
            begin
                inc_pc(24'd2);
                wadr <= zp_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_Y70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
        `STZ_ZP:
            begin
                inc_pc(24'd2);
                wadr <= zp_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_Z70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
		// Handle zp,x mode
        `LDA_ZPX:
            begin
                inc_pc(24'd2);
                radr <= zpx_address;
                data_read(zpx_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `LDY_ZPX:
            begin
                inc_pc(24'd2);
                radr <= zpx_address;
                data_read(zpx_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `ADC_ZPX,`SBC_ZPX,`AND_ZPX,`ORA_ZPX,`EOR_ZPX,`CMP_ZPX,
        `BIT_ZPX,
        `ASL_ZPX,`ROL_ZPX,`LSR_ZPX,`ROR_ZPX,`INC_ZPX,`DEC_ZPX:
            begin
                inc_pc(24'd2);
                radr <= zpx_address;
                wadr <= zpx_address;
                data_read(zpx_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                retstate <= CALC;
                state <= LOAD_MAC2;
                bank_wrap <= !m832;
            end
        `STA_ZPX:
            begin
                inc_pc(24'd2);
                wadr <= zpx_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
        `STY_ZPX:
            begin
                inc_pc(24'd2);
                wadr <= zpx_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_Y70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
        `STZ_ZPX:
            begin
                inc_pc(24'd2);
                wadr <= zpx_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_Z70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
        // Handle zp,y
        `LDX_ZPY:
            begin
                inc_pc(24'd2);
                radr <= zpy_address;
                data_read(zpy_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `STX_ZPY:
            begin
                inc_pc(24'd2);
                wadr <= zpy_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_X70;
                state <= STORE1;
                bank_wrap <= !m832;
            end
		// Handle (zp,x)
		`LDA_IX:
            begin
                inc_pc(24'd2);
                radr <= zpx_address;
                data_read(zpx_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `ADC_IX,`SBC_IX,`AND_IX,`ORA_IX,`EOR_IX,`CMP_IX,`STA_IX:
            begin
                inc_pc(24'd2);
                radr <= zpx_address;
                data_read(zpx_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
        // Handle (zp),y
        `LDA_IY:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                isIY <= `TRUE;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `ADC_IY,`SBC_IY,`AND_IY,`ORA_IY,`EOR_IY,`CMP_IY,`LDA_IY,`STA_IY:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                isIY <= `TRUE;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
		// Handle d,sp
        `LDA_DSP:
            begin
                inc_pc(24'd2);
                seg <= ss;
                radr <= dsp_address;
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC1;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_DSP,`SBC_DSP,`CMP_DSP,`ORA_DSP,`AND_DSP,`EOR_DSP:
            begin
                inc_pc(24'd2);
                radr <= dsp_address;
                seg <= ss;
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC1;
                retstate <= CALC;
            end
        `STA_DSP:
            begin
                inc_pc(24'd2);
                seg <= ss;
                radr <= dsp_address;
                wadr <= dsp_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                state <= STORE1;
            end
		// Handle (d,sp),y
		`LDA_DSPIY:
            begin
                inc_pc(24'd2);
                seg <= ss;
                radr <= dsp_address;
                mxb16 <= m16;
                mxb32 <= m32;
                isIY <= `TRUE;
                load_what <= `IA_70;
                retstate <= ssm ? SSM1 : IFETCH;
                state <= LOAD_MAC1;
            end
        `ADC_DSPIY,`SBC_DSPIY,`CMP_DSPIY,`ORA_DSPIY,`AND_DSPIY,`EOR_DSPIY,`STA_DSPIY:
            begin
                inc_pc(24'd2);
                radr <= dsp_address;
                seg <= ss;
                mxb16 <= m16;
                mxb32 <= m32;
                isIY <= `TRUE;
                load_what <= `IA_70;
                retstate <= CALC;
                state <= LOAD_MAC1;
            end
`ifdef SUPPORT_NEW_INSN
		// Handle {d,sp},y
	   `LDA_XDSPIY:
            begin
               inc_pc(24'd2);
               seg <= ss;
               radr <= dsp_address;
               mxb16 <= m16;
               mxb32 <= m32;
               isIY32 <= `TRUE;
               load_what <= `IA_70;
               state <= LOAD_MAC1;
               retstate <= ssm ? SSM1 : IFETCH;
           end
       `ADC_XDSPIY,`SBC_XDSPIY,`CMP_XDSPIY,`ORA_XDSPIY,`AND_XDSPIY,`EOR_XDSPIY,`STA_XDSPIY:
            begin
                inc_pc(24'd2);
                seg <= ss;
                radr <= dsp_address;
                mxb16 <= m16;
                mxb32 <= m32;
                isIY32 <= `TRUE;
                load_what <= `IA_70;
                state <= LOAD_MAC1;
                retstate <= CALC;
            end
`endif
        // Handle [zp],y
        `LDA_IYL:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                isIY24 <= `TRUE;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_IYL,`SBC_IYL,`AND_IYL,`ORA_IYL,`EOR_IYL,`CMP_IYL,`STA_IYL:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                isIY24 <= `TRUE;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
`ifdef SUPPORT_NEW_INSN
        // Handle {zp},y
        `LDA_XIYL:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                isIY32 <= `TRUE;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_XIYL,`SBC_XIYL,`AND_XIYL,`ORA_XIYL,`EOR_XIYL,`CMP_XIYL,`STA_XIYL:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                isIY32 <= `TRUE;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
`endif
		// Handle [zp]
		`LDA_IL:
            begin
                inc_pc(24'd2);
                isI24 <= `TRUE;
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `ADC_IL,`SBC_IL,`AND_IL,`ORA_IL,`EOR_IL,`CMP_IL,`STA_IL:
            begin
                inc_pc(24'd2);
                isI24 <= `TRUE;
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
`ifdef SUPPORT_NEW_INSN
		// Handle {zp}
		`LDA_XIL:
            begin
                inc_pc(24'd2);
                isI32 <= `TRUE;
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `ADC_XIL,`SBC_XIL,`AND_XIL,`ORA_XIL,`EOR_XIL,`CMP_XIL,`STA_XIL:
            begin
                inc_pc(24'd2);
                isI32 <= `TRUE;
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
`endif
        // Handle (zp)
        `LDA_I:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `ADC_I,`SBC_I,`AND_I,`ORA_I,`EOR_I,`CMP_I,`STA_I,`PEI:
            begin
                inc_pc(24'd2);
                radr <= zp_address;
                data_read(zp_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                load_what <= `IA_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
                bank_wrap <= !m832;
            end
		// Handle abs
        `LDA_ABS:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= abs_address;
                data_read(abs_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                retstate <= ssm ? SSM1 : IFETCH;
                state <= LOAD_MAC2;
            end
        `LDX_ABS,`LDY_ABS:
            begin
                inc_pc(24'd3);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= abs_address;
                data_read(abs_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_ABS,`SBC_ABS,`AND_ABS,`ORA_ABS,`EOR_ABS,`CMP_ABS,
        `ASL_ABS,`ROL_ABS,`LSR_ABS,`ROR_ABS,`INC_ABS,`DEC_ABS,`TRB_ABS,`TSB_ABS,
        `BIT_ABS:
            begin
                inc_pc(24'd3);
                radr <= abs_address;
                wadr <= abs_address;
                data_read(abs_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `CPX_ABS,`CPY_ABS:
            begin
                inc_pc(24'd3);
                radr <= abs_address;
                data_read(abs_address,1);
                mxb16 <= xb16;
                mxb32 <= xb32;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `STA_ABS:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= abs_address;
                wadr <= abs_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(abs_address,acc[7:0],1);
                state <= STORE2;
            end
        `STX_ABS:
            begin
                inc_pc(24'd3);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= abs_address;
                wadr <= abs_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_X70;
                data_write(abs_address,x[7:0],1);
                state <= STORE2;
            end    
        `STY_ABS:
            begin
                inc_pc(24'd3);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= abs_address;
                wadr <= abs_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_Y70;
                data_write(abs_address,y[7:0],1);
                state <= STORE2;
            end
        `STZ_ABS:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= abs_address;
                wadr <= abs_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_Z70;
                data_write(abs_address,8'h00,1);
                state <= STORE2;
            end
`ifdef SUPPORT_NEW_INSN
		// Handle xlabs
        `LDA_XABS:
            begin
                inc_pc(24'd5);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= xal_address;
                data_read(xal_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `LDX_XABS,`LDY_XABS:
            begin
                inc_pc(24'd5);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= xal_address;
                data_read(xal_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_XABS,`SBC_XABS,`AND_XABS,`ORA_XABS,`EOR_XABS,`CMP_XABS,
        `ASL_XABS,`ROL_XABS,`LSR_XABS,`ROR_XABS,`INC_XABS,`DEC_XABS,`TRB_XABS,`TSB_XABS,
        `BIT_XABS:
            begin
                inc_pc(24'd5);
                radr <= xal_address;
                wadr <= xal_address;
                data_read(xal_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `CPX_XABS,`CPY_XABS:
            begin
                inc_pc(24'd5);
                radr <= xal_address;
                data_read(xal_address,1);
                mxb16 <= xb16;
                mxb32 <= xb32;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `STA_XABS:
            begin
                inc_pc(24'd5);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= xal_address;
                wadr <= xal_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(xal_address,acc[7:0],1);
                state <= STORE2;
            end
        `STX_XABS:
            begin
                inc_pc(24'd5);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= xal_address;
                wadr <= xal_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_X70;
                data_write(xal_address,x[7:0],1);
                state <= STORE2;
            end    
        `STY_XABS:
            begin
                inc_pc(24'd5);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= xal_address;
                wadr <= xal_address;
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                store_what <= `STW_Y70;
                data_write(xal_address,y[7:0],1);
                state <= STORE2;
            end
        `STZ_XABS:
            begin
                inc_pc(24'd5);
                radr <= xal_address;
                wadr <= xal_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_Z70;
                data_write(xal_address,8'h00,1);
                state <= STORE2;
            end
`endif
        // Handle abs,x
        `LDA_ABSX:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= absx_address;
                data_read(absx_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_ABSX,`SBC_ABSX,`AND_ABSX,`ORA_ABSX,`EOR_ABSX,`CMP_ABSX,
        `ASL_ABSX,`ROL_ABSX,`LSR_ABSX,`ROR_ABSX,`INC_ABSX,`DEC_ABSX,`BIT_ABSX:
            begin
                inc_pc(24'd3);
                radr <= absx_address;
                wadr <= absx_address;
                data_read(absx_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `LDY_ABSX:
            begin
                inc_pc(24'd3);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= absx_address;
                data_read(absx_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `STA_ABSX:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= absx_address;
                wadr <= absx_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(absx_address,acc[7:0],1);
                state <= STORE2;
            end
        `STZ_ABSX:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= absx_address;
                wadr <= absx_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_Z70;
                data_write(absx_address,8'h00,1);
                state <= STORE2;
            end
`ifdef SUPPORT_NEW_INSN
        // Handle xlabs,x
        `LDA_XABSX:
            begin
                inc_pc(24'd5);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= xalx_address;
                data_read(xalx_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_XABSX,`SBC_XABSX,`AND_XABSX,`ORA_XABSX,`EOR_XABSX,`CMP_XABSX,
        `ASL_XABSX,`ROL_XABSX,`LSR_XABSX,`ROR_XABSX,`INC_XABSX,`DEC_XABSX,`BIT_XABSX:
            begin
                inc_pc(24'd5);
                radr <= xalx_address;
                wadr <= xalx_address;
                data_read(xalx_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `LDY_XABSX:
            begin
                inc_pc(24'd5);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= xalx_address;
                data_read(xalx_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `STA_XABSX:
            begin
                inc_pc(24'd5);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= xalx_address;
                wadr <= xalx_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(xalx_address,acc[7:0],1);
                state <= STORE2;
            end
        `STZ_XABSX:
            begin
                inc_pc(24'd5);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= xalx_address;
                wadr <= xalx_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_Z70;
                data_write(xalx_address,8'h00,1);
                state <= STORE2;
            end
`endif
		// Handle abs,y
        `LDA_ABSY:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= absy_address;
                data_read(absy_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
                bank_wrap <= !m832;
            end
        `ADC_ABSY,`SBC_ABSY,`AND_ABSY,`ORA_ABSY,`EOR_ABSY,`CMP_ABSY:
            begin
                inc_pc(24'd3);
                radr <= absy_address;
                data_read(absy_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `LDX_ABSY:
            begin
                inc_pc(24'd3);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= absy_address;
                data_read(absy_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `STA_ABSY:
            begin
                inc_pc(24'd3);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= absy_address;
                wadr <= absy_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(absy_address,acc[7:0],1);
                state <= STORE2;
            end
`ifdef SUPPORT_NEW_INSN
		// Handle xlabs,y
        `LDA_XABSY:
            begin
                inc_pc(24'd5);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= xaly_address;
                data_read(xaly_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_XABSY,`SBC_XABSY,`AND_XABSY,`ORA_XABSY,`EOR_XABSY,`CMP_XABSY:
            begin
                inc_pc(24'd5);
                radr <= xaly_address;
                data_read(xaly_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `LDX_XABSY:
            begin
                inc_pc(24'd5);
                mxb16 <= xb16;
                mxb32 <= xb32;
                radr <= xaly_address;
                data_read(xaly_address,1);
                if (!sop) begin
                    if (xb32) s32 <= TRUE;
                    else if (xb16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `STA_XABSY:
            begin
                inc_pc(24'd5);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= xaly_address;
                wadr <= xaly_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(xaly_address,acc[7:0],1);
                state <= STORE2;
            end
`endif
		// Handle al
        `LDA_AL:
            begin
                inc_pc(24'd4);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= al_address;
                data_read(al_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_AL,`SBC_AL,`AND_AL,`ORA_AL,`EOR_AL,`CMP_AL:
            begin
                inc_pc(24'd4);
                radr <= al_address;
                data_read(al_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `STA_AL:
            begin
                inc_pc(24'd4);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= al_address;
                wadr <= al_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(al_address,acc[7:0],1);
                state <= STORE2;
            end
		// Handle alx
        `LDA_ALX:
            begin
                inc_pc(24'd4);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= alx_address;
                data_read(alx_address,1);
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= ssm ? SSM1 : IFETCH;
            end
        `ADC_ALX,`SBC_ALX,`AND_ALX,`ORA_ALX,`EOR_ALX,`CMP_ALX:
            begin
                inc_pc(24'd4);
                radr <= alx_address;
                data_read(alx_address,1);
                mxb16 <= m16;
                mxb32 <= m32;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                load_what <= `LOAD_70;
                state <= LOAD_MAC2;
                retstate <= CALC;
            end
        `STA_ALX:
            begin
                inc_pc(24'd4);
                mxb16 <= m16;
                mxb32 <= m32;
                radr <= alx_address;
                wadr <= alx_address;
                if (!sop) begin
                    if (m32) s32 <= TRUE;
                    else if (m16) s16 <= TRUE;
                end
                store_what <= `STW_ACC70;
                data_write(alx_address,acc[7:0],1);
                state <= STORE2;
            end
        `BRK,`BRK2:
            begin
                pc_cap <= FALSE;
                if (!hwi)
                    inc_pc(24'd2);
                else
                    pc <= pc;   // override increment above
                if (m832) begin
`ifdef SUPPORT_TASK
                    if (TASK_VECTORING) begin
                        seg <= 32'd0;
                        radr <= vect;
                        otr <= tr;
                        load_what <= `LDW_TR70;
                        tGoto(LOAD_MAC1);
                    end
                    else begin
                        set_sp();
                        seg <= ss;
                        store_what <= `STW_CS3124;
                        data_nack();
                        state <= STORE1;
                    end
`else
                    set_sp();
                    seg <= ss;
                    store_what <= `STW_CS3124;
                    data_nack();
                    state <= STORE1;
`endif
                end
                else begin
                    set_sp();
                    seg <= ss;
                    store_what <= m816 ? `STW_PC2316 : `STW_PC158;// `STW_PC3124;
                    data_nack();
                    state <= STORE1;
                end
                bf <= !hwi;
            end
		`COP:
            begin
                inc_pc(24'd2);
                set_sp();
                seg <= ss;
                store_what <= m832 ? `STW_CS3124 : m816 ? `STW_PC2316 : `STW_PC158;// `STW_PC3124;
                state <= STORE1;
                vect <= m832 ? `COP_VECT_832 : m816 ? `COP_VECT_816 : `BYTE_COP_VECT;
            end
		`BEQ,`BNE,`BPL,`BMI,`BCC,`BCS,`BVC,`BVS,`BRA,`BGT,`BGE,`BLT,`BLE:
            begin
                if (ir[15:8]==8'hFF) begin
                    if (takb)
                        inc_pc({{8{ir[31]}},ir[31:16]} + 24'd4);
                    else
                        inc_pc(24'd4);
                end
                else begin
                    if (takb)
                        inc_pc({{16{ir[15]}},ir[15:8]} + 24'd2);
                    else
                        inc_pc(24'd2);
                end
            end
		`JMP:
            begin
                pc[15:0] <= ir[23:8];
            end
        `JMP_IND:
            begin
                radr <= abs_address;
                load_what <= `PC_70;
                data_read(abs_address,0);
                state <= LOAD_MAC2;
            end
        `JML_IND:
            begin
                radr <= abs_address;
                load_what <= `PC_70;
                data_read(abs_address,0);
                state <= LOAD_MAC2;
            end
        `JML_XIND:
            begin
                radr <= xal_address;
                data_read(xal_address,0);
                load_what <= `PC_70;
                state <= LOAD_MAC2;
            end
`ifdef SUPPORT_NEW_INSN
        `JML_XINDX:
            begin
                radr <= xalx_address;
                load_what <= `PC_70;
                data_read(xalx_address,0);
                state <= LOAD_MAC2;
            end
        `JSL_XINDX:
            begin
                inc_pc(24'd4);  // Yes this should be one less than the instruction length.
                set_sp();
                seg <= ss;
                store_what <= `STW_PC2316;
                state <= STORE1;
            end
`endif
        `JMP_INDX:
            begin
                radr <= absx_address;
                load_what <= `PC_70;
                data_read(absx_address,0);
                state <= LOAD_MAC2;
            end    
        `BSR,`JSR,`JSR_INDX:
            begin
                inc_pc(24'd2);  // Yes this should be one less than the instruction length.
                set_sp();
                seg <= ss;
                store_what <= `STW_PC158;
                state <= STORE1;
            end
        `BRL:
            begin
                inc_pc({{8{ir[23]}},ir[23:8]} + 24'd3);
            end
		`JML:
            begin
                pc <= ir[31:8];
            end
        `BSL,`JSL:
                begin
                    inc_pc(24'd3);
                    set_sp();
                    seg <= ss;
                    store_what <= `STW_PC2316;
                    state <= STORE1;
                end
`ifdef SUPPORT_NEW_INSN
`ifdef SUPPORT_SEG
		`PHDS:  tsk_push(`STW_DS70,0,1);
        `PHCS:
            begin
                set_sp();
                seg <= ss;
//                data_write(fn_get_sp(sp),cs[31:24],0); // new to set the segment in use
//                mlb <= TRUE;
                store_what <= `STW_CS3124;
                state <= STORE1;
            end
        `PLDS:
            begin
                inc_sp();
                seg <= ss;
                s32 <= TRUE;
                load_what <= `WORD_71S;
//                data_read(fn_sp_inc(sp_inc),0);
                state <= LOAD_MAC1;
                retstate <= ssm ? SSM1 : IFETCH;
            end
		`JMF:
            begin
                pc <= ir[31:8];
                // Switch modes ?
                if (ir[63:32]==32'hFFFFFFFF) begin
                    m832 <= `FALSE;
                    m816 <= `FALSE;
                    cs <= 32'd0;
                    ds <= 32'd0;
                    x[31:8] <= 24'd0;
                    y[31:8] <= 24'd0;
                    sp[27:8] <= 24'd1;
                    stksz <= 2'b00;
					m_bit <= 1'b1;
                    x_bit <= 1'b1;
                end
                else if (ir[63:32]==32'hFFFFFFFE) begin
                    m832 <= `FALSE;
                    m816 <= `TRUE;
                    cs <= 32'd0;
                    ds <= 32'd0;
                    x[31:8] <= 24'd0;
                    y[31:8] <= 24'd0;
                    sp[27:16] <= 16'd0;
                    stksz <= 2'b10;
					m_bit <= 1'b1;
                    x_bit <= 1'b1;
                end
                else
                    cs <= ir[63:32];
            end
        `JSF:
            begin
                inc_pc(24'd7);
                set_sp();
                seg <= ss;
                radr <= sp;
                wadr <= sp;
                state <= STORE1;
            end
`endif
`ifdef SUPPORT_TASK
        `TSK_IMM:
            begin
                inc_pc(24'd3);
                if (tr != ir[`TASK_MEM_ABIT+8:8]) begin
                    set_task_regs(24'd3);
                    otr <= tr;
                    back_link <= tr;
                    tr <= ir[`TASK_MEM_ABIT+8:8];
                    tsk_pres <= 7'h20;
                    store_what <= `STW_TR158;
                    tGoto(TSK1);
`ifdef TASK_BL
                    retstate <= ssm ? SSM1 : IFETCH;
`else
                    retstate <= tj_prefix ? IFETCH : STORE1;
`endif
                    //retstate <= ssm ? SSM1 : IFETCH;
                end
            end
        `TSK_ACC:
            begin
                if (tr != acc[`TASK_MEM_ABIT:0]) begin
                    set_task_regs(24'd1);
                    otr <= tr;
                    back_link <= tr;
                    tr <= acc[`TASK_MEM_ABIT:0];
                    tsk_pres <= 7'h20;
                    store_what <= `STW_TR158;
                    tGoto(TSK1);
`ifdef TASK_BL
                    retstate <= ssm ? SSM1 : IFETCH;
`else
                    retstate <= tj_prefix ? IFETCH : STORE1;
`endif
                end
            end
        `FORK_IMM:
            begin
                inc_pc(24'd3);
                if (tr != ir[`TASK_MEM_ABIT+8:8]) begin
                    set_task_regs(24'd3);
                    otr <= tr;
                    back_link <= tr;
                    tr <= ir[`TASK_MEM_ABIT+8:8];
`ifdef TASK_BL
                    tGoto(ssm ? SSM1 : IFETCH);
`else
                    set_sp();
                    seg <= ss;
                    store_what <= `STW_TR158;
                    if (!tj_prefix)
                        tGoto(STORE1);
`endif
                end
            end
        `FORK_ACC:
            begin
                if (tr != acc[`TASK_MEM_ABIT:0]) begin
                    set_task_regs(24'd1);
                    otr <= tr;
                    back_link <= tr;
                    tr <= acc[`TASK_MEM_ABIT:0];
`ifdef TASK_BL
                    tGoto(ssm ? SSM1 : IFETCH);                    
`else
                    set_sp();
                    seg <= ss;
                    store_what <= `STW_TR158;
                    if (!tj_prefix)
                        tGoto(STORE1);
`endif
                end
            end
		`RTT:
            begin
                set_task_regs(24'd1);
                tsk_pres <= 7'd0;
`ifdef TASK_BL
                tr <= back_link;
                retstate <= ssm ? SSM1 : IFETCH;
                tGoto(TSK1);
`else
                sp_i <= fn_add_to_sp(32'd2);
                inc_sp();
                seg <= ss;
                load_what <= `LDW_TR70S;
                state <= LOAD_MAC1;
`endif
            end
        `LDT_XABS:
            begin
                inc_pc(24'd5);
                cnt <= 4'd0;
                radr <= ir[39:8];
                tGoto(LDT1);
            end
        `LDT_XABSX:
            begin
                inc_pc(24'd5);
                cnt <= 4'd0;
                radr <= ir[39:8] + (x << 5);
                tGoto(LDT1);
            end
        `JCF:
            begin
                inc_pc(24'd11);
                if (tr != ir[`TASK_MEM_ABIT+64:64]) begin
                    pc <= ir[31:8];
                    cs <= ir[63:32];
                    back_link <= tr;
                    set_task_regs(24'd11);
                    otr <= tr;
                    tr <= ir[`TASK_MEM_ABIT+64:64];
                    maxcnt <= ir[84:80];
                    if (ir[87]) begin
                        tsk_pres[3:0] <= 4'hF;
                        tsk_pres[4] <= TRUE;
                        tsk_pres[5] <= TRUE;
                        tsk_pres[6] <= TRUE;
                    end
                    else begin
                        tsk_pres[3:0] <= 4'h0;
                        tsk_pres[4] <= TRUE;
                        tsk_pres[5] <= TRUE;
                        tsk_pres[6] <= TRUE;
                    end
                    if (ir[84:80] > 5'd0) begin
                        cnt <= 8'h00;
                        load_what <= `CPY_BUF;
                        store_what <= `STW_CPY_BUF;
                        inc_sp();
                        seg <= ss;
                        tGoto(LOAD_MAC1);
                        retstate <= STORE1;
                    end
                    else begin 
                        state <= TSK1;
`ifdef TASK_BL
                        retstate <= ssm ? SSM1 : IFETCH;
`else                        
                        store_what <= `STW_TR158;
                        retstate <= tj_prefix ? IFETCH : STORE1;
`endif
                    end
                end
            end
        `JCL:
            begin
                inc_pc(24'd7);
                if (tr != ir[`TASK_MEM_ABIT+32:32]) begin
                    pc <= ir[31:8];
                    back_link <= tr;
                    set_task_regs(24'd7);
                    otr <= tr;
                    tr <= ir[`TASK_MEM_ABIT+32:32];
                    maxcnt <= ir[52:48];
                    if (ir[55]) begin
                        tsk_pres[3:0] <= 4'hF;
                        tsk_pres[4] <= TRUE;
                        tsk_pres[5] <= TRUE;
                        tsk_pres[6] <= FALSE;
                    end
                    else begin
                        tsk_pres[3:0] <= 4'h0;
                        tsk_pres[4] <= TRUE;
                        tsk_pres[5] <= TRUE;
                        tsk_pres[6] <= FALSE;
                    end
                    if (ir[52:48] > 5'd0) begin
                        cnt <= 8'h00;
                        load_what <= `CPY_BUF;
                        store_what <= `STW_CPY_BUF;
                        inc_sp();
                        seg <= ss;
                        tGoto(LOAD_MAC1);
                        retstate <= STORE1;
                    end
                    else begin 
                        state <= TSK1;
`ifdef TASK_BL
                        retstate <= ssm ? SSM1 : IFETCH;
`else                        
                        store_what <= `STW_TR158;
                        retstate <= tj_prefix ? IFETCH : STORE1;
`endif
                    end
                end
            end
        `JCR:
            begin
                inc_pc(24'd5);
                if (tr != {8'h00,ir[31:24]}) begin
                    pc <= {8'h00,ir[23:8]};
                    back_link <= tr;
                    set_task_regs(24'd5);
                    otr <= tr;
                    tr <= {8'h00,ir[31:24]};
                    tsk_pres[3:0] <= 4'hF;
                    tsk_pres[4] <= TRUE;
                    tsk_pres[5] <= TRUE;
                    tsk_pres[6] <= FALSE;
                    state <= TSK1;
`ifdef TASK_BL
                    retstate <= ssm ? SSM1 : IFETCH;
`else
                    store_what <= `STW_TR158;
                    retstate <= tj_prefix ? IFETCH : STORE1;
`endif
                end
            end
        `JCI:
            begin
                if (tr != {8'h00,acc[31:24]}) begin
                    pc <= acc[23:0];
                    back_link <= tr;
                    set_task_regs(24'd1);
                    otr <= tr;
                    tr <= {8'h00,acc[31:24]};
                    tsk_pres[3:0] <= 4'hF;
                    tsk_pres[4] <= TRUE;
                    tsk_pres[5] <= TRUE;
                    tsk_pres[6] <= FALSE;
                    state <= TSK1;
`ifdef TASK_BL
                    retstate <= ssm ? SSM1 : IFETCH;
`else
                    store_what <= `STW_TR158;
                    retstate <= tj_prefix ? IFETCH : STORE1;
`endif
                end
            end
		`RTC:
            begin
                inc_pc(24'd2);
                set_task_regs(24'd2);
                tsk_pres <= 7'hF;
                sp_i <= fn_add_to_sp(ir[15:8]);
`ifdef TASK_BL
                tr <= back_link;
                tGoto(TSK1);
                retstate <= ssm ? SSM1 : IFETCH;
`else
                inc_sp();
                seg <= ss;
                load_what <= `LDW_TR70S;
                state <= LOAD_MAC1;
`endif
            end
`endif
    `FILL:
      begin
        mvndst_bank <= ir[15:8];
        wadr <= mvndst_address;
        store_what <= `STW_X70;
        npc <= PC24 ? pc + 24'd2 : {pc[23:16],pc[15:0]+16'd2};
        pc <= opc;      // override increment above
        tGoto(STORE1);
      end
`endif
		`MVN,`MVP:
      begin
        mvndst_bank <= ir[15:8];
        mvnsrc_bank <= ir[23:16];
        radr <= mvnsrc_address;
        load_what <= `BYTE_72;
        npc <= PC24 ? pc + 24'd3 : {pc[23:16],pc[15:0]+16'd3};
        pc <= opc;       // override increment above
        state <= LOAD_MAC1;
      end
`ifdef SUPPORT_NEW_INSN
        `CACHE:
            begin
                inc_pc(24'd2);
                case(ir[15:8])
                8'h00:  inv_icache <= TRUE; // invalidate entire instruction cache
                8'h01:  begin
                        ado1 <= {acc[31:4],4'h0};
                        inv_iline <= TRUE;
                        end
                8'h02:  begin       // LICL
                        rwo <= TRUE;
                        vpa <= TRUE;
                        vda <= TRUE;
                        ado <= {acc[31:4],4'h0};
                        wr_icache <= TRUE; 
                        cnt <= 4'h0;
                        // Going to the ICACHE2 state will ensure that loading
                        // the cache line didn't dump the cache line that is
                        // required by the PC.
                        tGoto(ICACHE2);
                        end
                default:    ;
                endcase
            end
`endif
        default:
			begin
				moveto_ifetch();
			end
		endcase
	end
`ifdef SUPPORT_TASK
TSK1:
    begin
`ifdef SUPPORT_SEG
        if (!tsk_pres[6]) cs <= cs_o;
        ds <= ds_o;
`endif
        if (!tsk_pres[4]) pc <= pc_o;
        if (!tsk_pres[3]) acc <= acc_o;
        if (!tsk_pres[2]) x <= x_o;
        if (!tsk_pres[1]) y <= y_o;
        sp <= sp_o[27:0];
        stksz <= stksz_o;
        if (!tsk_pres[0]) cf <= sr_o[0];
        if (!tsk_pres[0]) zf <= sr_o[1];
        // Force further interrupts to be masked automatically when the task is
        // invoked as an interrupt handler. Otherwise the task will be invoked
        // continuously.
        if (sr_o[2]|hwi)
            im <= 1'b1;
        else
            imcd <= 3'b110;
        df <= sr_o[3];
        if (|srx_o[1:0]) begin
            x_bit <= sr_o[4];
            m_bit <= sr_o[5];
        end
        // The following load of the break flag is different than the '02
        // which never loads the flag.
        else if (POPBF)
            bf <= sr_o[4];
        if (!tsk_pres[0]) vf <= sr_o[6];
        if (!tsk_pres[0]) nf <= sr_o[7];
        m816 <= srx_o[0];
        m832 <= srx_o[1];
        mib <= srx_o[2];
        ssm <= srx_o[4];
        dbr <= dbr_o;
        dpr <= dpr_o;
        if (!tsk_pres[5]) back_link <= bl_o;
        if (!srx_o[2]) begin
            if (retstate==STORE1) begin
                set_sp();
                seg <= ss;
            end
            tGoto(retstate);
        end
        else
            moveto_ifetch();
    end
LDT1:
    begin
        cnt <= cnt + 4'd1;
        s32 <= TRUE;
        if (cnt < 4'd8) begin
            data_read(radr,cnt==4'd0);
            load_what <= `LOAD_70;
            tGoto(LOAD_MAC2);
            retstate <= LDT1;
        end
        case(cnt)
        4'd1:   cs_i <= b32;
        4'd2:   ds_i <= b32;
        4'd3:   begin pc_i <= b32[23:0]; acc_i[7:0] <= b32[31:24]; end
        4'd4:   begin acc_i[31:8] <= b32[23:0]; x_i[7:0] <= b32[31:24]; end
        4'd5:   begin x_i[31:8] <= b32[23:0]; y_i[7:0] <= b32[31:24]; end
        4'd6:   begin y_i[31:8] <= b32[23:0]; sp_i[7:0] <= b32[31:24]; end
        4'd7:   begin sp_i[27:8] <= b32[19:0]; stksz_i <= b32[23:22]; sr_i <= b32[31:24]; end
        4'd8:   begin srx_i <= b32[7:0]; dbr_i <= b32[15:8]; dpr_i <= b32[31:16];
                tskm_we <= TRUE;
                tskm_wr <= TRUE;
                tskm_wa <= x32[`TASK_MEM_ABIT:0];
                moveto_ifetch();
                end
        endcase 
    end
INF1:
    begin
        if (x[15:4]==12'hFFF) begin
            case(x[3:0])
            4'h0:   res32 <= corenum;
            default:    ;
            endcase
        end
        else begin
            case(x[3:0])
            4'h0:   res32 <= cs_o;
            4'h1:   res32 <= ds_o;
            4'h2:   res32 <= pc_o;
            4'h3:   res32 <= acc_o;
            4'h4:   res32 <= x_o;
            4'h5:   res32 <= y_o;
            4'h6:   res32 <= {stksz_o,2'b00,sp_o};
            4'h7:   res32 <= {srx_o,sr_o};
            4'h8:   res32 <= dbr_o;
            4'h9:   res32 <= dpr_o;
            4'hA:   res32 <= bl_o;
            default:    ;
            endcase
        end
        tr <= otr;
        moveto_ifetch();
    end
`endif
LOAD_MAC1:
`ifdef SUPPORT_DCACHE
    if (unCachedData)
`endif
    begin
        if (load_what==`CPY_BUF && maxcnt > 1)
            mlb <= 1'b1;
        if (isRMW)
            mlb <= 1'b1;
        if (isBrk)
            vpb <= `TRUE;
        data_read(radr,0);
        state <= LOAD_MAC2;
    end
`ifdef SUPPORT_DCACHE
    else if (dhit)
        load_tsk(rdat,rdat8,rdat16);
    else begin
        retstate <= LOAD_MAC1;
        state <= DCACHE1;
    end
`endif
LOAD_MAC2:
    if (rdy) begin
        data_nack();
        begin
            case(load_what)
            `CPY_BUF:
                begin
                    cnt <= cnt + 8'd1;
                    cpybuf[cnt] <= db;
                    if (cnt < maxcnt - 8'd1) begin
                        inc_sp();
                        tGoto(LOAD_MAC1);
                    end
                    else begin
                        mlb <= 1'b0;
                        cnt <= cnt;
                        tGoto(TSK1);
                    end
                end
            `BYTE_72:
                        begin
                            wdat[7:0] <= db;
                            radr <= mvnsrc_address;
                            wadr <= mvndst_address;
                            store_what <= `STW_DEF70;
                            if (m832)
                                acc <= acc_dec;
                            else
                                acc[15:0] <= acc_dec[15:0];
                            if (ir9==`MVN) begin
                                if (xb32) begin
                                    x <= x_inc;
                                    y <= y_inc;
                                end
                                else if (xb16) begin
                                    x <= {16'h0000,x_inc[15:0]};
                                    y <= {16'h0000,y_inc[15:0]};
                                end
                                else begin
                                    x <= {24'h0000,x_inc[7:0]};
                                    y <= {24'h0000,y_inc[7:0]};
                                end
                            end
                            else begin
                                if (xb32) begin
                                    x <= x_dec;
                                    y <= y_dec;
                                end
                                else if (xb16) begin
                                    x <= {16'h0000,x_dec[15:0]};
                                    y <= {16'h0000,y_dec[15:0]};
                                end
                                else begin
                                    x <= {24'h0000,x_dec[7:0]};
                                    y <= {24'h0000,y_dec[7:0]};
                                end
                            end
                            tGoto(STORE1);
                        end
            `LOAD_70:
                        begin
                            radr <= inc_adr(radr);
                            if (lds) begin
                                b32 <= {{24{db[7]}},db};
                                res32 <= {{24{db[7]}},db};
                            end
                            else begin
                                b32 <= {24'd0,db};
                                res32 <= {24'd0,db};
                            end
                            if (s16|s32) begin
                                load_what <= `LOAD_158;
                                if (DEAD_CYCLE) begin
                                    data_nack();
                                    tGoto(LOAD_MAC1);
                                end
                                else begin
                                    data_read(inc_adr(radr),0);
                                    state <= LOAD_MAC2;
                                end
                            end
                            else
                                state <= retstate;
                        end
            `LOAD_158:
                        begin
                            radr <= inc_adr(radr);
                            if (lds) begin
                                b32[31:8] <= {{16{db[7]}},db};
                                res32[31:8] <= {{16{db[7]}},db};
                            end
                            else begin
                                b32[31:8] <= {24'd0,db};
                                res32[31:8] <= {24'd0,db};
                            end
                            if (s32) begin
                                load_what <= `LOAD_2316;
                                if (DEAD_CYCLE) begin
                                    data_nack();
                                    tGoto(LOAD_MAC1);
                                end
                                else begin
                                    data_read(inc_adr(radr),0);
                                    state <= LOAD_MAC2;
                                end
                            end
                            else
                                state <= retstate;
                        end
            `LOAD_2316:
                        begin
                            b32[23:16] <= db;
                            res32[23:16] <= db;
                            load_what <= `LOAD_3124;
                            radr <= inc_adr(radr);
                            if (DEAD_CYCLE) begin
                                data_nack();
                                tGoto(LOAD_MAC1);
                            end
                            else begin
                                data_read(inc_adr(radr),0);
                                state <= LOAD_MAC2;
                            end
                        end
            `LOAD_3124:
                        begin
                            radr <= inc_adr(radr);
                            b32[31:24] <= db;
                            res32[31:24] <= db;
                            state <= retstate;
                        end
            `WORD_71S:
                        begin
                            res32[7:0] <= db;
                            if (s16|s32) begin
                                load_what <= `WORD_159S;
                                inc_sp();
                                if (DEAD_CYCLE)
                                    tGoto(LOAD_MAC1);
                                else begin
                                    data_read(fn_add_to_sp(32'd1),0);
                                    tGoto(LOAD_MAC2);
                                end
                            end
                            else
                                tGoto(retstate);
                        end
            `WORD_159S:
                        begin
                            res32[15:8] <= db;
                            if (s32) begin
                                load_what <= `WORD_2317S;
                                inc_sp();
                                if (DEAD_CYCLE)
                                    tGoto(LOAD_MAC1);
                                else begin
                                    data_read(fn_add_to_sp(32'd1),0);
                                    tGoto(LOAD_MAC2);
                                end
                            end
                            else
                                tGoto(retstate);
                        end
            `WORD_2317S:
                        begin
                            res32[23:16] <= db;
                            load_what <= `WORD_3125S;
                            inc_sp();
                            if (DEAD_CYCLE)
                                tGoto(LOAD_MAC1);
                            else begin
                                data_read(fn_add_to_sp(32'd1),0);
                                tGoto(LOAD_MAC2);
                            end
                        end
            `WORD_3125S:
                        begin
                            res32[31:24] <= db;
                            state <= retstate;
                        end
            `SR_70:        begin
                            cf <= db[0];
                            zf <= db[1];
                            if (db[2])
                                im <= 1'b1;
                            else
                                imcd <= 3'b110;
                            df <= db[3];
                            if (m816|m832) begin
                                x_bit <= db[4];
                                m_bit <= db[5];
//                                if (db[4]) begin
//                                    x[31:8] <= 24'd0;
//                                    y[31:8] <= 24'd0;
//                                end
                            end
                            // The following load of the break flag is different than the '02
                            // which never loads the flag.
                            else if (POPBF)
                                bf <= db[4];
                            vf <= db[6];
                            nf <= db[7];
                            if (isRTI) begin
                                load_what <= `PC_70;
                                inc_sp();
                                if (DEAD_CYCLE) begin
                                    data_nack();
                                    tGoto(LOAD_MAC1);
                                end
                                else begin
                                    data_read(fn_add_to_sp(32'd1),0);
                                    state <= LOAD_MAC2;
                                end
                            end        
                            else begin    // PLP
                                if (m832) begin
                                    load_what <= `SR_158;
                                    inc_sp();
                                    if (DEAD_CYCLE) begin
                                        data_nack();
                                        tGoto(LOAD_MAC1);
                                    end
                                    else begin
                                        data_read(fn_add_to_sp(32'd1),0);
                                        state <= LOAD_MAC2;
                                    end
                                end
                                else
                                    moveto_ifetch();
                            end
                        end
             `SR_158:
                        begin
                            m816 <= db[0];
                            m832 <= db[1];
                            mib <= db[2];
                            ssm <= db[4];
                            moveto_ifetch();
                        end
`ifdef SUPPORT_TASK
             // Vector to the task only if it's not the one currently running. 
             `LDW_TR70: begin
                            b32 <= db;
                            radr <= inc_adr(radr);
                            load_what <= `LDW_TR158;
                            if (DEAD_CYCLE) begin
                                data_nack();
                                tGoto(LOAD_MAC1);
                            end
                            else begin
                                data_read(inc_adr(radr),0);
                                tGoto(LOAD_MAC2);
                            end
                        end
             `LDW_TR158: begin
                           radr <= inc_adr(radr);
                           vpb <= FALSE;
                           if ({db,b32[7:0]} != tr) begin
                               set_task_regs(hwi ? 24'd0 : 24'd2);
                               tr <= {db,b32[7:0]};
                               back_link <= tr;
                               tsk_pres <= 7'h20;
                               state <= TSK1;
`ifdef TASK_BL
                               retstate <= IFETCH;
`else                               
                               store_what <= `STW_TR158;
                               retstate <= STORE1;
`endif
                           end
                           else begin
                               tGoto(IFETCH);
                           end
                        end
`ifndef TASK_BL
             `LDW_TR70S:
                        begin
                           tr[7:0] <= db;
                           load_what <= `LDW_TR158S;
                           inc_sp();
                           if (DEAD_CYCLE) begin
                               data_nack();
                               tGoto(LOAD_MAC1);
                           end
                           else begin
                               data_read(fn_add_to_sp(32'd1),0);
                               state <= LOAD_MAC2;
                           end
                        end
             `LDW_TR158S:
                       begin
                          tr[`TASK_MEM_ABIT:8] <= db;
                          tGoto(TSK1);
                          retstate <= ssm ? SSM1 : IFETCH;
                       end
`endif
`endif
             `PC_70:        begin
                            pc[7:0] <= db;
                            load_what <= `PC_158;
                            if (isRTI|isRTS|isRTL|isRTF) begin
                                inc_sp();
                                if (DEAD_CYCLE) begin
                                    data_nack();
                                    tGoto(LOAD_MAC1);
                                end
                                else begin
                                    data_read(fn_add_to_sp(32'd1),0);
                                    state <= LOAD_MAC2;
                                end
                            end
                            else begin    // JMP (abs)
                                radr <= inc_adr(radr);
                                state <= LOAD_MAC1;
                            end
                        end
            `PC_158:    begin
                            pc[15:8] <= db;
                            if ((isRTI&(m816|m832))|isRTL|isRTF) begin
                                load_what <= `PC_2316;
                                inc_sp();
                                if (DEAD_CYCLE) begin
                                    data_nack();
                                    tGoto(LOAD_MAC1);
                                end
                                else begin
                                    data_read(fn_add_to_sp(32'd1),0);
                                    state <= LOAD_MAC2;
                                end
                            end
                            else if (isRTS)    // rts instruction
                                tGoto(RTS1);
                            else if (isJLInd) begin   // jmp (abs)
                                load_what <= `PC_2316;
                                seg <= ds;
                                radr <= inc_adr(radr);
                                state <= LOAD_MAC1;
                            end
                            else
                            begin
                                vpb <= `FALSE;
                                tGoto(IFETCH);
                            end
                        end
            `PC_2316:    begin
                            pc[23:16] <= db;
                            if (isRTF|(isRTI&m832)) begin
                                load_what <= `CS_70;
                                inc_sp();
                                if (DEAD_CYCLE) begin
                                    data_nack();
                                    tGoto(LOAD_MAC1);
                                end
                                else begin
                                    data_read(fn_add_to_sp(32'd1),0);
                                    tGoto(LOAD_MAC2);
                                end
                            end
                            else if (isRTL) begin
                                load_what <= `NOTHING;
                                tGoto(RTS1);
                            end
                            else begin
                                load_what <= `NOTHING;
                                tGoto(IFETCH);
                            end
                        end
`ifdef SUPPORT_SEG
              `CS_70:   begin
                              load_what <= `CS_158;
                              inc_sp();
                              cs[7:0] <= db;
                              if (DEAD_CYCLE) begin
                                  data_nack();
                                  tGoto(LOAD_MAC1);
                              end
                              else begin
                                  data_read(fn_add_to_sp(32'd1),0);
                                  tGoto(LOAD_MAC2);
                              end
                        end
              `CS_158:   begin
                            load_what <= `CS_2316;
                            inc_sp();
                            cs[15:8] <= db;
                            if (DEAD_CYCLE) begin
                                data_nack();
                                tGoto(LOAD_MAC1);
                            end
                            else begin
                                data_read(fn_add_to_sp(32'd1),0);
                                tGoto(LOAD_MAC2);
                            end
                        end
              `CS_2316:   begin
                              load_what <= `CS_3124;
                              inc_sp();
                              cs[23:16] <= db;
                              if (DEAD_CYCLE) begin
                                  data_nack();
                                  tGoto(LOAD_MAC1);
                              end
                              else begin
                                  data_read(fn_add_to_sp(32'd1),0);
                                  tGoto(LOAD_MAC2);
                              end
                          end
              `CS_3124:   begin
                              cs[31:24] <= db;
                              vpb <= `FALSE;
                              load_what <= `NOTHING;
                              if (isRTF)
                                  tGoto(RTS1);
                              else
                                  moveto_ifetch();
                          end
`endif
        //    `PC_3124:    begin
        //                    pc[31:24] <= db;
        //                    load_what <= `NOTHING;
        //                    tGoto(BYTE_IFETCH);
        //                end
            `IA_70:
                    begin
                        radr <= radr + 32'd1;
                        if (DEAD_CYCLE) begin
                            data_nack();
                            tGoto(LOAD_MAC1);
                        end
                        else begin
                            data_read(radr + 32'd1,0);
                            state <= LOAD_MAC2;
                        end
                        ia[7:0] <= db;
                        load_what <= `IA_158;
                    end
            `IA_158:
                    begin
                        ia[15:8] <= db;
                        ia[23:16] <= dbr;
                        ia[31:24] <= 8'h00;
                        if (isIY24|isI24|isIY32|isI32) begin
                            radr <= radr + 32'd1;
                            if (DEAD_CYCLE) begin
                                data_nack();
                                tGoto(LOAD_MAC1);
                            end
                            else begin
                                data_read(radr + 32'd1,0);
                                state <= LOAD_MAC2;
                            end
                            load_what <= `IA_2316;
                        end
                        else begin
                            seg <= ds;
                            state <= isIY ? BYTE_IY5 : BYTE_IX5;
                        end
                    end
            `IA_2316:
                    begin
                        ia[23:16] <= db;
                        ia[31:24] <= 8'h00;
                        if (isI32|isIY32) begin
                            load_what <= `IA_3124;
                            radr <= radr + 32'd1;
                            if (DEAD_CYCLE) begin
                                data_nack();
                                tGoto(LOAD_MAC1);
                            end
                            else begin
                                data_read(radr + 32'd1,0);
                                tGoto(LOAD_MAC2);
                            end
                        end
                        else begin
                            seg <= ds;
                            state <= isIY24 ? BYTE_IY5 : BYTE_IX5;
                        end
                    end
            `IA_3124:
                    begin
                        ia[31:24] <= db;
                        seg <= ds;
                        state <= isIY32 ? BYTE_IY5 : BYTE_IX5;
                    end
            endcase
        end
        //endtask
//        load_tsk(db,b16);
    end
`ifdef SUPPORT_BERR
    else if (err_i) begin
        mlb <= 1'b0;
        data_nack();
        derr_address <= ado;
        intno <= 9'd508;
        state <= BUS_ERROR;
    end
`endif
RTS1:
    begin
        if (ir9==`RTL_IMM || ir9==`RTS_IMM || ir9==`RTF)
            sp <= fn_add_to_sp(ir[15:8]);
        inc_pc(24'd1);
        moveto_ifetch();
    end
BYTE_IX5:
    begin
        isI24 <= `FALSE;
        isI32 <= `FALSE;
        bank_wrap <= FALSE;
        page_wrap <= FALSE;
        seg <= ds;
        radr <= ia;
        load_what <= `LOAD_70;
        state <= LOAD_MAC1;
        if (!sop) begin
            if (m32) s32 <= TRUE;
            else if (m16) s16 <= TRUE;
        end
        if (ir[7:0]==`STA_IX || ir[7:0]==`STA_I || ir[7:0]==`STA_IL) begin
            wadr <= ia;
            store_what <= `STW_ACC70;
            state <= STORE1;
        end
        else if (ir[7:0]==`PEI) begin
            set_sp();
            seg <= ss;
            store_what <= isI32 ? `STW_IA3124 : `STW_IA158;
            state <= STORE1;
        end
    end
BYTE_IY5:
    begin
        isIY <= `FALSE;
        isIY24 <= `FALSE;
        isIY32 <= `FALSE;
        bank_wrap <= FALSE;
        page_wrap <= FALSE;
        seg <= ds;
        radr <= iapy8;
        wadr <= iapy8;
        if (!sop) begin
            if (m32) s32 <= TRUE;
            else if (m16) s16 <= TRUE;
        end
        store_what <= `STW_ACC70;
        load_what <= `LOAD_70;
        $display("IY addr: %h", iapy8);
        if (ir[7:0]==`STA_IY || ir[7:0]==`STA_IYL || ir[7:0]==`STA_DSPIY)
            state <= STORE1;
        else
            state <= LOAD_MAC1;
    end

STORE1:
	begin
		case(store_what)
`ifdef SUPPORT_SEG
		`STW_CS3124:    begin data_write(wadr,cs[31:24],0); mlb <= 1'b1; end
		`STW_CS2316:    data_write(wadr,cs[23:16],0);
		`STW_CS158:     data_write(wadr,cs[15:8],0);
		`STW_CS70:      data_write(wadr,cs[7:0],0);
    `STW_DS70:      begin data_write(wadr,ds[7:0],0); mlb <= 1'b1; end
    `STW_DS158:     data_write(wadr,ds[15:8],0);
    `STW_DS2316:    data_write(wadr,ds[23:16],0);
    `STW_DS3124:    data_write(wadr,ds[31:24],0);
`endif
		`STW_PC2316:	begin data_write(wadr,pc[23:16],0); mlb <= 1'b1; end
		`STW_PC158:		data_write(wadr,pc[15:8],0);
		`STW_PC70:		data_write(wadr,pc[7:0],0);
		`STW_SR70:		data_write(wadr,sr8,0);
		`STW_SR158:		begin data_write(wadr,srx,1); mlb <= TRUE; end
		`STW_DEF70:		begin data_write(wadr,wdat,0); mlb <= s16|s32; end
		`STW_DEF158:    data_write(wadr,wdat[15:8],0);
		`STW_DEF2316:   data_write(wadr,wdat[23:16],0);
		`STW_DEF3124:   data_write(wadr,wdat[31:24],0);
		`STW_ACC70:		begin data_write(wadr,acc,0); mlb <= s16|s32; end
		`STW_ACC158:	data_write(wadr,acc[15:8],0);
		`STW_ACC2316:	data_write(wadr,acc[23:16],0);
		`STW_ACC3124:	data_write(wadr,acc[31:24],0);
		`STW_X70:		begin data_write(wadr,x,0); mlb <= s16|s32; end
		`STW_X158:		data_write(wadr,x[15:8],0);
		`STW_X2316:		data_write(wadr,x[23:16],0);
		`STW_X3124:		data_write(wadr,x[31:24],0);
		`STW_Y70:		begin data_write(wadr,y,0); mlb <= s16|s32; end
		`STW_Y158:		data_write(wadr,y[15:8],0);
		`STW_Y2316:		data_write(wadr,y[23:16],0);
		`STW_Y3124:		data_write(wadr,y[31:24],0);
		`STW_Z70:		begin data_write(wadr,8'h00,0); mlb <= s16|s32; end
		`STW_Z158:		data_write(wadr,8'h00,0);
		`STW_Z2316:		data_write(wadr,8'h00,0);
		`STW_Z3124:		data_write(wadr,8'h00,0);
		`STW_DBR:       data_write(wadr,dbr,0);
		`STW_DPR158:	begin data_write(wadr,dpr[15:8],0); mlb<= 1'b1; end
		`STW_DPR70:		begin data_write(wadr,dpr[7:0],0); mlb <= 1'b1; end
		`STW_TMP3124:	begin data_write(wadr,tmp32[31:24],0); mlb <= 1'b1; end
		`STW_TMP2316:	begin data_write(wadr,tmp32[23:16],0); mlb <= 1'b1; end
		`STW_TMP158:	begin data_write(wadr,tmp32[15:8],0); mlb <= 1'b1; end
		`STW_TMP70:		data_write(wadr,tmp32[7:0],0);
		`STW_IA3124:	begin data_write(wadr,ia[31:24],0); mlb <= 1'b1; end
		`STW_IA2316:	data_write(wadr,ia[23:16],0);
		`STW_IA158:		begin data_write(wadr,ia[15:8],0); mlb <= 1'b1; end
		`STW_IA70:		data_write(wadr,ia,0);
`ifdef SUPPORT_TASK
        `STW_TR158:     begin data_write(wadr,otr[`TASK_MEM_ABIT:8],1); mlb <= 1'b1; end
        `STW_TR70:      data_write(wadr,otr[7:0],0);
		`STW_CPY_BUF:   begin data_write(wadr,cpybuf[cnt],0); mlb <= maxcnt > 8'd1; end
`endif
		default:	data_write(wadr,wdat,0);
		endcase
`ifdef SUPPORT_DCACHE
		radr <= wadr;		// Do a cache read to test the hit
`endif
		state <= STORE2;
	end
	
// Terminal state for stores. Update the data cache if there was a cache hit.
// Clear any previously set lock status
STORE2:
	if (rdy) begin
//		wdat <= dat_o;
		mlb <= 1'b0;
		data_nack();
		if (!em && (isMove|isSts)) begin
			state <= MVN816;
			retstate <= MVN816;
		end
		else begin
			if (em) begin
				if (isMove) begin
					state <= MVN816;
					retstate <= MVN816;
				end
				else begin
					moveto_ifetch();
					retstate <= IFETCH;
				end
			end
			else begin
				moveto_ifetch();
				retstate <= IFETCH;
			end
		end
		case(store_what)
		`STW_CPY_BUF:
		    begin
		        if (cnt > 0) begin
		            mlb <= TRUE;
		            cnt <= cnt - 8'd1;
                    set_sp();
                    if (DEAD_CYCLE) begin
                        data_nack();
                        tGoto(STORE1);
                    end
                    else begin
                        data_write(fn_get_sp(sp),cpybuf[cnt-8'd1],0);
                        state <= STORE2;
                    end
		        end
		        else begin
`ifdef TASK_BL
                    moveto_ifetch();
`else
		            if (tj_prefix)
		               moveto_ifetch();
		            else begin
    		            store_what <= `STW_TR158;
    		            set_sp();
                        if (DEAD_CYCLE)
                            tGoto(STORE1);
                        else begin
                            data_write(fn_get_sp(sp),otr[`TASK_MEM_ABIT:8],0);
                            tGoto(STORE2);
    		            end
		            end
`endif
		        end
		    end
		`STW_DEF70:
			begin
				wadr <= inc_adr(wadr);
				if (s16|s32) begin
				    mlb <= TRUE;
                    store_what <= `STW_DEF158;
                    if (DEAD_CYCLE)
                        tGoto(STORE1);
                    else begin
		                data_write(inc_adr(wadr),wdat[15:8],0);
                        tGoto(STORE2);
                    end
                end
			end
		`STW_DEF158:
			if (s32) begin
			    mlb <= TRUE;
				wadr <= inc_adr(wadr);
				if (DEAD_CYCLE)
				    tGoto(STORE1);
				else begin
                    data_write(inc_adr(wadr),wdat[23:16],0);
                    tGoto(STORE2);
                end
				store_what <= `STW_DEF2316;
			end
		`STW_DEF2316:
            begin
			    mlb <= TRUE;
				wadr <= inc_adr(wadr);
				if (DEAD_CYCLE) begin
                    data_nack();
				    tGoto(STORE1);
				end
				else begin
	                data_write(inc_adr(wadr),wdat[31:24],0);
                    tGoto(STORE2);
	            end
                store_what <= `STW_DEF3124;
            end
        `STW_ACC70:
            if (s16|s32) begin
				wadr <= inc_adr(wadr);
			    mlb <= TRUE;
                store_what <= `STW_ACC158;
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
		            data_write(inc_adr(wadr),acc[15:8],0);
                    state <= STORE2;
                end
            end
        `STW_ACC158:
            if (s32) begin
                wadr <= inc_adr(wadr);
			    mlb <= TRUE;
                store_what <= `STW_ACC2316;
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
		            data_write(inc_adr(wadr),acc[23:16],0);
                    state <= STORE2;
                end
            end
        `STW_ACC2316:
            begin
                wadr <= inc_adr(wadr);
			    mlb <= TRUE;
                store_what <= `STW_ACC3124;
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
		            data_write(inc_adr(wadr),acc[31:24],0);
                    state <= STORE2;
                end
            end
		`STW_X70:
		    begin
    	        do_fill_inc(MVN816); 
                if (s16|s32) begin
                    mlb <= 1'b1;
                    wadr <= inc_adr(wadr);
                    if (DEAD_CYCLE) begin
                        data_nack();
                        tGoto(STORE1);
                    end
                    else begin
                        data_write(inc_adr(wadr),x[15:8],0);
                        tGoto(STORE2);
                    end
                    store_what <= `STW_X158;
    			end
			end
		`STW_X158:
		    begin
                do_fill_inc(MVN816);
                if (s32) begin
                    mlb <= 1'b1;
                    wadr <= inc_adr(wadr);
                    if (DEAD_CYCLE) begin
                        data_nack();
                        tGoto(STORE1);
                    end
                    else begin
                        data_write(inc_adr(wadr),x[23:16],0);
                        state <= STORE2;
                    end
                    store_what <= `STW_X2316;
                end
            end          
            
		`STW_X2316:
            begin
                do_fill_inc(MVN816);
                mlb <= 1'b1;
                wadr <= inc_adr(wadr);
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
		            data_write(inc_adr(wadr),x[31:24],0);
                    state <= STORE2;
                end
                store_what <= `STW_X3124;
            end
        `STW_X3124:
             do_fill_inc(MVN816);
        
		`STW_Y70:
			if (s16|s32) begin
				mlb <= 1'b1;
				wadr <= inc_adr(wadr);
				if (DEAD_CYCLE) begin
                    data_nack();
				    tGoto(STORE1);
				end
				else begin
                    data_write(inc_adr(wadr),y[15:8],0);
    				state <= STORE2;
    		    end
				store_what <= `STW_Y158;
			end
		`STW_Y158:
            if (s32) begin
                mlb <= 1'b1;
                wadr <= inc_adr(wadr);
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(inc_adr(wadr),y[23:16],0);
                    state <= STORE2;
                end
                store_what <= `STW_Y2316;
            end
		`STW_Y2316:
            begin
                mlb <= 1'b1;
                wadr <= inc_adr(wadr);
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(inc_adr(wadr),y[31:24],0);
                    state <= STORE2;
                end
                store_what <= `STW_Y3124;
            end
		`STW_Z70:
			if (s16|s32) begin
				mlb <= 1'b1;
				wadr <= inc_adr(wadr);
				if (DEAD_CYCLE) begin
                    data_nack();
				    tGoto(STORE1);
				end
				else begin
                    data_write(inc_adr(wadr),8'h00,0);
				    state <= STORE2;
				end
				store_what <= `STW_Z158;
			end
		`STW_Z158:
            if (s32) begin
                mlb <= 1'b1;
                wadr <= inc_adr(wadr);
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(inc_adr(wadr),8'h00,0);
                    state <= STORE2;
                end
                store_what <= `STW_Z2316;
            end
		`STW_Z2316:
            begin
                mlb <= 1'b1;
                wadr <= inc_adr(wadr);
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(inc_adr(wadr),8'h00,0);
                    state <= STORE2;
                end
                store_what <= `STW_Z3124;
            end
		`STW_DPR70:
			begin
				mlb <= 1'b1;
				wadr <= inc_adr(wadr);
				store_what <= `STW_DPR158;
				state <= STORE1;
			end
`ifdef SUPPORT_TASK
`ifndef TASK_BL
		`STW_TR158:
            begin
                mlb <= `TRUE;
                set_sp();
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(fn_get_sp(sp),otr[7:0],0);
                    tGoto(STORE2);
                end
                store_what <= `STW_TR70;
            end
        `STW_TR70:
            begin
                moveto_ifetch();
            end
`endif
`endif
`ifdef SUPPORT_SEG
		`STW_DS70:
		    begin
				mlb <= 1'b1;
				wadr <= inc_adr(wadr);
				if (DEAD_CYCLE) begin
                    data_nack();
				    tGoto(STORE1);
				end
				else begin
				    data_write(inc_adr(wadr),ds[15:8],0);
                    state <= STORE2;
                end
                store_what <= `STW_DS158;
		    end
		`STW_DS158:
            begin
			    mlb <= TRUE;
				wadr <= inc_adr(wadr);
				if (DEAD_CYCLE) begin
                    data_nack();
				    tGoto(STORE1);
				end
				else begin
				    data_write(inc_adr(wadr),ds[23:16],0);
                    state <= STORE2;
                end
                store_what <= `STW_DS2316;
            end
		`STW_DS2316:
            begin
			    mlb <= TRUE;
				wadr <= inc_adr(wadr);
				if (DEAD_CYCLE) begin
                    data_nack();
				    tGoto(STORE1);
				end
				else begin
				    data_write(inc_adr(wadr),ds[31:24],0);
                    state <= STORE2;
                end
                store_what <= `STW_DS3124;
            end
		`STW_CS3124:
            begin
                mlb <= `TRUE;
                set_sp();
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(fn_get_sp(sp),cs[23:16],0);
                    state <= STORE2;
                end
                store_what <= `STW_CS2316;
            end
        `STW_CS2316:
            begin
			    mlb <= TRUE;
                set_sp();
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(fn_get_sp(sp),cs[15:8],0);
                    state <= STORE2;
                end
                store_what <= `STW_CS158;
            end
        `STW_CS158:
            begin
			    mlb <= TRUE;
                set_sp();
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(fn_get_sp(sp),cs[7:0],0);
                    state <= STORE2;
                end
                store_what <= `STW_CS70;
            end
        `STW_CS70:
            if (ir9 != `PHCS) begin
			    mlb <= TRUE;
                set_sp();
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(fn_get_sp(sp),pc[23:16],0);
                    state <= STORE2;
                end
                store_what <= `STW_PC2316;
            end
`endif
		`STW_TMP158:
			begin
				set_sp();
				store_what <= `STW_TMP70;
				state <= STORE1;
			end
		`STW_IA3124:
            begin
                set_sp();
                store_what <= `STW_IA2316;
                state <= STORE1;
            end
		`STW_IA2316:
            begin
                set_sp();
                store_what <= `STW_IA158;
                state <= STORE1;
            end
		`STW_IA158:
			begin
				set_sp();
				store_what <= `STW_IA70;
				state <= STORE1;
			end
        `STW_PC2316:
			begin
				if (ir9 != `PHK) begin
    			    mlb <= TRUE;
					set_sp();
					if (DEAD_CYCLE) begin
                        data_nack();
		 			    tGoto(STORE1);
					end
					else begin
                        data_write(fn_get_sp(sp),pc[15:8],0);
    					state <= STORE2;
    			    end
					store_what <= `STW_PC158;
				end
			end
		`STW_PC158:
			begin
			    mlb <= TRUE;
				set_sp();
				if (DEAD_CYCLE) begin
                    data_nack();
				    tGoto(STORE1);
				end
				else begin
                    data_write(fn_get_sp(sp),pc[7:0],0);
    				state <= STORE2;
    		    end
				store_what <= `STW_PC70;
			end
		`STW_PC70:
			begin
				case(ir9)
				`BRK,`BRK2,`COP:
						begin
        			    mlb <= TRUE;
						set_sp();
						if (DEAD_CYCLE) begin
                            data_nack();
						    tGoto(STORE1);
						end
						else begin
                            data_write(fn_get_sp(sp),sr8,0);
    						state <= STORE2;
    				    end
					    store_what <= `STW_SR70;
						end
				`JSR:
				    	begin
					    pc[15:0] <= ir[23:8];
						end
				`JSL:
				    	begin
                        pc[23:0] <= ir[31:8];
						end
			     `BSR:   pc[15:0] <= pc[15:0] + ir[23:8] + 16'd1;
			     `BSL:   pc <= pc + ir[31:8] + 24'd1;
`ifdef SUPPORT_SEG
			    `JSF,`JCF:
			            begin
    		            pc <= ir[31:8];
                        cs <= ir[63:32];
		                end
`endif
				`JSR_INDX:
						begin
						state <= LOAD_MAC1;
						load_what <= `PC_70;
						seg <= ds;
						radr <= absx_address;
						bank_wrap <= FALSE;
						page_wrap <= FALSE;
						end
				`JSL_XINDX:
                        begin
                        state <= LOAD_MAC1;
                        load_what <= `PC_70;
                        seg <= ds;
                        radr <= xalx_address;
						bank_wrap <= FALSE;
                        page_wrap <= FALSE;
                        end
				endcase
			end
		`STW_SR158:
		    begin
		        store_what <= `STW_SR70;
				set_sp();
                if (DEAD_CYCLE) begin
                    data_nack();
                    tGoto(STORE1);
                end
                else begin
                    data_write(fn_get_sp(sp),sr8,0);
                    state <= STORE2;
                end
		    end
        `STW_SR70:
			begin
				if (ir[7:0]==`BRK) begin
					load_what <= `PC_70;
					seg <= 32'd0;
					state <= LOAD_MAC1;
					pc[23:16] <= 8'h00;//abs8[23:16];
					radr <= vect;
					vpb <= TRUE;
//					data_read(vect);
					im <= hwi;
					df <= 1'b0;
					bank_wrap <= FALSE;
                    page_wrap <= FALSE;
				end
				else if (ir[7:0]==`COP) begin
					load_what <= `PC_70;
					seg <= 32'd0;
					state <= LOAD_MAC1;
					pc[23:16] <= 8'h00;//abs8[23:16];
					radr <= vect;
					vpb <= TRUE;
//					data_read(vect);
					im <= 1'b1;
					bank_wrap <= FALSE;
                    page_wrap <= FALSE;
				end
			end
		default:
			if (isJsrIndx) begin
				load_what <= `PC_310;
				state <= LOAD_MAC1;
				seg <= ds;
				radr <= ir[31:8] + x;
				bank_wrap <= FALSE;
                page_wrap <= FALSE;
			end
			else if (isJsrInd) begin
				load_what <= `PC_310;
				state <= LOAD_MAC1;
				seg <= ds;
				radr <= ir[31:8];
				bank_wrap <= FALSE;
                page_wrap <= FALSE;
			end
		endcase
`ifdef SUPPORT_DCACHE
		if (!dhit && write_allocate) begin
			state <= DCACHE1;
		end
`endif
	end
`ifdef SUPPORT_BERR
	else if (err_i) begin
		mlb <= 1'b0;
		data_nack();
		derr_address <= ado[23:0];
		intno <= 9'd508;
		state <= BUS_ERROR;
	end
`endif

CALC:
	begin
    	moveto_ifetch();
        store_what <= `STW_DEF70;
        // The following calculations are the same regardless of the size.
        case(ir9)
    	`ADC_IMM,`ADC_ZP,`ADC_ZPX,`ADC_IX,`ADC_IY,`ADC_ABS,`ADC_ABSX,`ADC_ABSY,`ADC_XABS,`ADC_XABSX,`ADC_XABSY,
        `ADC_IYL,`ADC_XIYL,`ADC_I,`ADC_IL,`ADC_XIL,`ADC_AL,`ADC_ALX,`ADC_DSP,`ADC_DSPIY,`ADC_XDSPIY:
              begin res32 <= acc + b32 + {31'b0,cf}; end
        `SBC_IMM,`SBC_ZP,`SBC_ZPX,`SBC_IX,`SBC_IY,`SBC_ABS,`SBC_ABSX,`SBC_ABSY,`SBC_XABS,`SBC_XABSX,`SBC_XABSY,
        `SBC_IYL,`SBC_XIYL,`SBC_I,`SBC_IL,`SBC_XIL,`SBC_AL,`SBC_ALX,`SBC_DSP,`SBC_DSPIY,`SBC_XDSPIY:
              begin res32 <= acc - b32 - {31'b0,~cf}; end
        `CMP_IMM,`CMP_ZP,`CMP_ZPX,`CMP_IX,`CMP_IY,`CMP_ABS,`CMP_ABSX,`CMP_ABSY,`CMP_XABS,`CMP_XABSX,`CMP_XABSY,
        `CMP_IYL,`CMP_XIYL,`CMP_I,`CMP_IL,`CMP_XIL,`CMP_AL,`CMP_ALX,`CMP_DSP,`CMP_DSPIY,`CMP_XDSPIY:
              begin res32 <= acc - b32; end
        `CPX_IMM,`CPX_ZP,`CPX_ABS,`CPX_XABS:    begin res32 <= x - b32; end
        `CPY_IMM,`CPY_ZP,`CPY_ABS,`CPY_XABS:    begin res32 <= y - b32; end
        `AND_IMM,`AND_ZP,`AND_ZPX,`AND_IX,`AND_IY,`AND_ABS,`AND_ABSX,`AND_ABSY,`AND_XABS,`AND_XABSX,`AND_XABSY,
        `AND_IYL,`AND_XIYL,`AND_I,`AND_IL,`AND_XIL,`AND_AL,`AND_ALX,`AND_DSP,`AND_DSPIY,`AND_XDSPIY:
              begin res32 <= acc & b32; end
        `ORA_IMM,`ORA_ZP,`ORA_ZPX,`ORA_IX,`ORA_IY,`ORA_ABS,`ORA_ABSX,`ORA_ABSY,`ORA_XABS,`ORA_XABSX,`ORA_XABSY,
        `ORA_IYL,`ORA_XIYL,`ORA_I,`ORA_IL,`ORA_XIL,`ORA_AL,`ORA_ALX,`ORA_DSP,`ORA_DSPIY,`ORA_XDSPIY:
              begin res32 <= acc | b32; end
        `EOR_IMM,`EOR_ZP,`EOR_ZPX,`EOR_IX,`EOR_IY,`EOR_ABS,`EOR_ABSX,`EOR_ABSY,`EOR_XABS,`EOR_XABSX,`EOR_XABSY,
        `EOR_IYL,`EOR_XIYL,`EOR_I,`EOR_IL,`EOR_XIL,`EOR_AL,`EOR_ALX,`EOR_DSP,`EOR_DSPIY,`EOR_XDSPIY:
              begin res32 <= acc ^ b32; end
        `LDA_IMM,`LDA_ZP,`LDA_ZPX,`LDA_IX,`LDA_IY,`LDA_ABS,`LDA_ABSX,`LDA_ABSY,`LDA_XABS,`LDA_XABSX,`LDA_XABSY,
        `LDA_IYL,`LDA_XIYL,`LDA_I,`LDA_IL,`LDA_XIL,`LDA_AL,`LDA_ALX,`LDA_DSP,`LDA_DSPIY,`LDA_XDSPIY:
              begin res32 <= b32; end
        `BIT_IMM,`BIT_ZP,`BIT_ZPX,`BIT_ABS,`BIT_ABSX,`BIT_XABS,`BIT_XABSX:    begin res32 <= acc & b32; end
        `LDX_IMM,`LDX_ZP,`LDX_ZPY,`LDX_ABS,`LDX_ABSY,`LDX_XABS,`LDX_XABSY:    begin res32 <= b32; end
        `LDY_IMM,`LDY_ZP,`LDY_ZPX,`LDY_ABS,`LDY_ABSX,`LDY_XABS,`LDY_XABSX:    begin res32 <= b32; end
        `TRB_ZP,`TRB_ABS,`TRB_XABS:    begin res32 <= acc & b32; wdat <= ~acc & b32; state <= STORE1; data_nack(); end
        `TSB_ZP,`TSB_ABS,`TSB_XABS:    begin res32 <= acc & b32; wdat <= acc | b32; state <= STORE1; data_nack(); end
		`INC_ZP,`INC_ZPX,`INC_ABS,`INC_ABSX,`INC_XABS,`INC_XABSX:    begin res32 <= b32 + 32'd1; wdat <= b32+32'd1; state <= STORE1; data_nack(); end
        `DEC_ZP,`DEC_ZPX,`DEC_ABS,`DEC_ABSX,`DEC_XABS,`DEC_XABSX:    begin res32 <= b32 - 32'd1; wdat <= b32-32'd1; state <= STORE1; data_nack(); end
		`ASL_ZP,`ASL_ZPX,`ASL_ABS,`ASL_ABSX,`ASL_XABS,`ASL_XABSX:    begin res32 <= {b32,1'b0}; wdat <= {b32[30:0],1'b0}; state <= STORE1; data_nack(); end
        `ROL_ZP,`ROL_ZPX,`ROL_ABS,`ROL_ABSX,`ROL_XABS,`ROL_XABSX:    begin res32 <= {b32,cf}; wdat <= {b32[30:0],cf}; state <= STORE1; data_nack(); end
		`INC_IMM:   begin res32 <= b32 + {{24{ir[23]}},ir[23:16]}; wdat <= {{24{ir[23]}},ir[23:16]}; state <= STORE1; data_nack(); end
        default: begin
			// The following calculations depend on the operand size.
			if ((sop && mxb16) || (!sop && s16)) begin
				case(ir9)
				`LSR_ZP,`LSR_ZPX,`LSR_ABS,`LSR_ABSX,`LSR_XABS,`LSR_XABSX:    begin res32 <= {b32[0],17'b0,b32[15:1]}; wdat <= {17'b0,b32[15:1]}; state <= STORE1; data_nack(); end
				`ROR_ZP,`ROR_ZPX,`ROR_ABS,`ROR_ABSX,`ROR_XABS,`ROR_XABSX:    begin res32 <= {b32[0],16'b0,cf,b32[15:1]}; wdat <= {16'h0,cf,b32[15:1]}; state <= STORE1; data_nack(); end
				default: res32 <= 32'hDEADDEAD;
				endcase
			end
			else if ((sop && mxb32) || (!sop && s32)) begin
				case(ir9)
				`LSR_ZP,`LSR_ZPX,`LSR_ABS,`LSR_ABSX,`LSR_XABS,`LSR_XABSX:    begin res32 <= {b32[0],1'b0,b32[31:1]}; wdat <= {1'b0,b32[31:1]}; state <= STORE1; data_nack(); end
				`ROR_ZP,`ROR_ZPX,`ROR_ABS,`ROR_ABSX,`ROR_XABS,`ROR_XABSX:    begin res32 <= {b32[0],cf,b32[31:1]}; wdat <= {cf,b32[31:1]}; state <= STORE1; data_nack(); end
				default: res32 <= 32'hDEADDEAD;
				endcase
			end
			else begin
				case(ir9)
				`LSR_ZP,`LSR_ZPX,`LSR_ABS,`LSR_ABSX,`LSR_XABS,`LSR_XABSX:    begin res32 <= {b32[0],25'b0,b8[7:1]}; wdat <= {25'b0,b8[7:1]}; state <= STORE1; data_nack(); end
				`ROR_ZP,`ROR_ZPX,`ROR_ABS,`ROR_ABSX,`ROR_XABS,`ROR_XABSX:    begin res32 <= {b32[0],24'b0,cf,b8[7:1]}; wdat <= {24'b0,cf,b8[7:1]}; state <= STORE1; data_nack(); end
				default: res32 <= 32'hDEADDEAD;
				endcase
			end
		end
		endcase
	end

MVN816:
	begin
		moveto_ifetch();
		if (m832) begin
            if (&acc) begin
                pc <= npc;
            end
		end
		else begin
            if (&acc[15:0]) begin
                pc <= npc;
                dbr <= mvndst_bank;
            end
		end
	end
SSM1:
    begin
        set_task_regs(24'd0);
        otr <= tr;
        back_link <= tr; 
        tr <= 16'd3;        // single step task
        tsk_pres <= 7'h2C;
        acc <= tr;
        x <= pc;
`ifndef TASK_BL
        seg <= ss;
        store_what <= `STW_TR158;
        retstate <= STORE1; // Do not switch on SSM here
`else
        retstate <= IFETCH; 
`endif
        tGoto(TSK1);
    end

ICACHE1:
    begin
        rwo <= TRUE;
        inv_icache <= FALSE;
        inv_iline <= FALSE;
        if (!hit0) begin
            prc_hit0 <= TRUE;
            vpa <= TRUE;
            vda <= TRUE;
            ado <= {cspc[31:4],4'h0};
            wr_icache <= TRUE; 
            cnt <= 8'h0;
            tGoto(ICACHE2);
        end
        else if (!hit1) begin
            prc_hit1 <= TRUE;
            vpa <= TRUE;
            vda <= TRUE;
            ado <= {cspc[31:4]+28'd1,4'h0};
            wr_icache <= TRUE; 
            cnt <= 8'h0;
            tGoto(ICACHE2);
        end
        else
            tGoto(IFETCH);
    end
ICACHE2:
    if (rdy) begin
        ado1 <= ado;
        vda <= FALSE;
        if (DEAD_CYCLE) begin
            vpa <= FALSE;
            ado <= 32'd0;
            tGoto(ICACHE3);
        end
        else
            ado <= {ado[31:4],cnt[3:0]+4'd1};
        if (cnt[3:0] == 4'hE)
            wr_itag <= TRUE;
        if (cnt[3:0] == 4'hF) begin
            vpa <= FALSE;
            ado <= 32'd0;
            if ((hit1|prc_hit1)&hit0) begin
                tGoto(IFETCH);
            end
            else
                tGoto(ICACHE1);
            wr_icache <= FALSE;
        end
        cnt <= cnt + 4'd1;
    end
ICACHE3:
    begin
        vpa <= TRUE;
        ado <= {ado1[31:4],cnt[3:0]};
        tGoto(ICACHE2);
    end
 
endcase
end

task data_read;
input [31:0] adr;
input first;
begin
	vpa <= `FALSE;
	vda <= `TRUE;
	rwo <= `TRUE;
	ado <= seg + adr;
end
endtask

task data_write;
input [31:0] adr;
input [7:0] dat;
input first;
begin
    if (!cs_prefix) begin
        vpa <= `FALSE;
        vda <= `TRUE;
        rwo <= `FALSE;
        ado <= seg + adr;
        dbo <= dat;
	end
end
endtask

task data_nack;
begin
	vpa <= `FALSE;
	vda <= `FALSE;
	rwo <= `TRUE;
//	ado <= 32'h000000;
//	dbo <= 8'h00;
end
endtask

task set_task_regs;
input [23:0] amt;
begin
    tskm_we <= TRUE;
    tskm_wr <= TRUE;
    tskm_wa <= tr;
`ifdef SUPPORT_SEG
    cs_i <= cs;
    ds_i <= ds;
`else
    cs_i <= 32'd0;
    ds_i <= 32'd0;
`endif
    if (PC24)
        pc_i <= pc + amt;
    else
        pc_i <= {pc[23:16],pc[15:0] + amt[15:0]};
    acc_i <= acc;
    x_i <= x;
    y_i <= y;
    sp_i <= sp;
    sr_i <= sr8;
    srx_i <= {3'b0,ssm,1'b0,mib,m832,m816};
    dbr_i <= dbr;
    dpr_i <= dpr;
    bl_i <= back_link;
end
endtask

task do_fill_inc;
input [5:0] ns;
begin
    if (ir9==`FILL) begin
        if (m832)
            acc <= acc_dec;
        else
            acc[15:0] <= acc_dec[15:0];
        if (xb32)
            y <= y_inc;
        else if (xb16)
            y <= {16'h0000,y_inc[15:0]};
        else
            y <= {24'h0000,y_inc[7:0]};
        tGoto(ns);
    end
end
endtask

`include "FT833misc_task.v"

task tGoto;
input [5:0] nxt;
begin
	state <= nxt;
end
endtask

task inc_pc;
input [23:0] amt;
begin
if (PC24)
    pc <= pc + amt;
else
    pc[15:0] <= pc[15:0] + amt[15:0];
end
endtask

function [127:0] fnStateName;
input [5:0] state;
case(state)
RESET1:	fnStateName = "RESET1     ";
IFETCH:	fnStateName = "IFETCH     ";
STORE1:	fnStateName = "STORE1     ";
STORE2:	fnStateName = "STORE2     ";
RTS1:	fnStateName = "RTS1       ";
IY3:	fnStateName = "IY3        ";
BYTE_IX5:	fnStateName = "BYTE_IX5   ";
BYTE_IY5:	fnStateName = "BYTE_IY5   ";
DECODE:	fnStateName = "DECODE    ";
CALC:	fnStateName = "CALC      ";
BUS_ERROR:	fnStateName = "BUS_ERROR  ";
LOAD_MAC1:	fnStateName = "LOAD_MAC1  ";
LOAD_MAC2:	fnStateName = "LOAD_MAC2  ";
LOAD_MAC3:	fnStateName = "LOAD_MAC3  ";
LOAD_DCACHE:	fnStateName = "LOAD_DCACHE";
LOAD_ICACHE:	fnStateName = "LOAD_ICACHE";
LOAD_IBUF1:		fnStateName = "LOAD_IBUF1 ";
LOAD_IBUF2:		fnStateName = "LOAD_IBUF2 ";
LOAD_IBUF3:		fnStateName = "LOAD_IBUF3 ";
ICACHE1:		fnStateName = "ICACHE1    ";
ICACHE2:		fnStateName = "ICACHE2    ";
ICACHE3:		fnStateName = "ICACHE3    ";
IBUF1:			fnStateName = "IBUF1      ";
DCACHE1:		fnStateName = "DCACHE1    ";
MVN816:			fnStateName = "MVN816     ";
TSK1:           fnStateName = "TSK1       ";
LDT1:           fnStateName = "LDT1       ";
INF1:           fnStateName = "INF1       ";
SSM1:           fnStateName = "SSM1       ";
default:		fnStateName = "UNKNOWN    ";
endcase
endfunction

endmodule


// ============================================================================
// Cache Memories
// ============================================================================
module ft832_icachemem(wclk, wce, wr, wa, i, rclk, rce, pc, insn);
input wclk;
input wce;
input wr;
input [7:0] i;
input rclk;
input rce;
output [127:0] insn;
reg [127:0] insn;

`ifdef ICACHE_4K
input [11:0] wa;
input [11:0] pc;
reg [127:0] mem [0:255];
reg [11:0] rpc,rpcp16;
wire [127:0] insn0 = mem[rpc[11:4]];
wire [127:0] insn1 = mem[rpcp16[11:4]];
`elsif ICACHE_16K
input [13:0] wa;
input [13:0] pc;
reg [127:0] mem [0:1023];
reg [13:0] rpc,rpcp16;
wire [127:0] insn0 = mem[rpc[13:4]];
wire [127:0] insn1 = mem[rpcp16[13:4]];
`endif

genvar g;
generate
begin : wstrobes
for (g = 0; g < 16; g = g + 1)
always_ff @(posedge wclk)
`ifdef ICACHE_4K
	if (wce & wr && wa[3:0]==g) mem[wa[11:4]][g*8+7:g*8] <= i;
`elsif ICACHE_16K
	if (wce & wr && wa[3:0]==g) mem[wa[13:4]][g*8+7:g*8] <= i;
`endif
end
endgenerate

always_ff @(posedge rclk)
	if (rce) rpc <= pc;
always_ff @(posedge rclk)
	if (rce) rpcp16 <= pc + 16'd16;
always_comb
case(rpc[3:0])
4'h0:	insn <= insn0;
4'h1:	insn <= {insn1[7:0],insn0[127:8]};
4'h2:	insn <= {insn1[15:0],insn0[127:16]};
4'h3:	insn <= {insn1[23:0],insn0[127:24]};
4'h4:	insn <= {insn1[31:0],insn0[127:32]};
4'h5:	insn <= {insn1[39:0],insn0[127:40]};
4'h6:	insn <= {insn1[47:0],insn0[127:48]};
4'h7:	insn <= {insn1[55:0],insn0[127:56]};
4'h8:	insn <= {insn1[63:0],insn0[127:64]};
4'h9:	insn <= {insn1[71:0],insn0[127:72]};
4'hA:	insn <= {insn1[79:0],insn0[127:80]};
4'hB:	insn <= {insn1[87:0],insn0[127:88]};
4'hC:	insn <= {insn1[95:0],insn0[127:96]};
4'hD:	insn <= {insn1[103:0],insn0[127:104]};
4'hE:	insn <= {insn1[111:0],insn0[127:112]};
4'hF:	insn <= {insn1[119:0],insn0[127:120]};
endcase

endmodule

module ft832_itagmem(wclk, wce, wr, wa, invalidate, invalidate_line, rclk, rce, pc, hit0, hit1);
input wclk;
input wce;
input wr;
input [31:0] wa;
input invalidate;
input invalidate_line;
input rclk;
input rce;
input [31:0] pc;
output hit0;
output hit1;

`ifdef ICACHE_4K
wire [20:0] tag0,tag1;
reg [31:12] mem [0:255];
reg [0:255] tvalid;
`elsif ICACHE_16K
wire [18:0] tag0,tag1;
reg [31:14] mem [0:1023];
reg [0:1023] tvalid;
`endif
reg [31:0] rpc,rpcp16;

always @(posedge rclk)
	if (rce) rpc <= pc;
always @(posedge rclk)
	if (rce) rpcp16 <= pc + 32'd16;

`ifdef ICACHE_4K
always @(posedge wclk)
	if (wce & wr) mem[wa[11:4]] <= wa[31:12];
always @(posedge wclk)
        if (invalidate) tvalid <= 256'd0;
        else if (invalidate_line) tvalid[wa[11:4]] <= 1'b0;
        else if (wce & wr) tvalid[wa[11:4]] <= 1'b1;
assign tag0 = {mem[rpc[11:4]],tvalid[rpc[11:4]]};
assign tag1 = {mem[rpcp16[11:4]],tvalid[rpcp16[11:4]]};

assign hit0 = tag0 == {rpc[31:12],1'b1};
assign hit1 = tag1 == {rpcp16[31:12],1'b1};

`elsif ICACHE_16K
always @(posedge wclk)
	if (wce & wr) mem[wa[13:4]] <= wa[31:14];
always @(posedge wclk)
        if (invalidate) tvalid <= 1024'd0;
        else if (invalidate_line) tvalid[wa[13:4]] <= 1'b0;
        else if (wce & wr) tvalid[wa[13:4]] <= 1'b1;
assign tag0 = {mem[rpc[13:4]],tvalid[rpc[13:4]]};
assign tag1 = {mem[rpcp16[13:4]],tvalid[rpcp16[13:4]]};

assign hit0 = tag0 == {rpc[31:14],1'b1};
assign hit1 = tag1 == {rpcp16[31:14],1'b1};
`endif

endmodule

module task_mem(wclk, wce, wr, wa,
    cs_i, ds_i, pc_i, acc_i, x_i, y_i, stksz_i, sp_i, sr_i, srx_i, db_i, dpr_i, bl_i,
    rclk, rce, ra,
    cs_o, ds_o, pc_o, acc_o, x_o, y_o, stksz_o, sp_o, sr_o, srx_o, db_o, dpr_o, bl_o
);
input wclk;
input wce;
input wr;
input [`TASK_MEM_ABIT:0] wa;
input [31:0] cs_i;
input [31:0] ds_i;
input [23:0] pc_i;
input [31:0] acc_i;
input [31:0] x_i;
input [31:0] y_i;
input [1:0] stksz_i;
input [27:0] sp_i;
input [7:0] sr_i;
input [7:0] srx_i;
input [7:0] db_i;
input [15:0] dpr_i;
input [`TASK_MEM_ABIT:0] bl_i;
input rclk;
input rce;
input [`TASK_MEM_ABIT:0] ra;
output [31:0] cs_o;
output [31:0] ds_o;
output [23:0] pc_o;
output [31:0] acc_o;
output [31:0] x_o;
output [31:0] y_o;
output [27:0] sp_o;
output [1:0] stksz_o;
output [7:0] sr_o;
output [7:0] srx_o;
output [7:0] db_o;
output [15:0] dpr_o;
output [`TASK_MEM_ABIT:0] bl_o;
reg [`TASK_MEM_ABIT+256:0] mem [`TASK_MEM-1:0];
always @(posedge wclk)
  if (wce & wr)
    mem[wa] <= {bl_i,cs_i,ds_i,pc_i,acc_i,x_i,y_i,stksz_i,2'b00,sp_i,sr_i,srx_i,db_i,dpr_i};
wire [`TASK_MEM_ABIT+256:0] memo;
reg [`TASK_MEM_ABIT:0] rra;
always @(posedge rclk)
  rra <= ra;
assign memo = mem[rra];
assign dpr_o = memo[15:0];
assign db_o = memo[23:16];
assign srx_o = memo[31:24];
assign sr_o = memo[39:32];
assign stksz_o = memo[71:70];
assign sp_o = memo[67:40];
assign y_o = memo[103:72];
assign x_o = memo[135:104];
assign acc_o = memo[167:136];
assign pc_o = memo[191:168];
assign ds_o = memo[223:192];
assign cs_o = memo[255:224];
assign bl_o = memo[`TASK_MEM_ABIT+256:256];

endmodule
