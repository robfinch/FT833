# FT833 CPU and System-On-Chip

The core has not been worked on in a while. Originating sometime around 2017.

# Features
* Proposed 65832 CPU compatible.
* 32-bit datapath
* Expanded 32-bit address capabilities
* Instruction Cache 
* Single step mode
* Combinational signed branches (test both N and Z)
* Long branching
* Multiply Instruction
* Enhanced support for variable data sizes
* Expanded interrupt capabilities
* Status register extended to 16-bits

# Future Changes
The CS, DS, and SS registers are going. Replaced by a paged MMU.

# Instruction Cache
The instruction cache is organized as 256 lines of 16 bytes or 4kB.
The leading byte of an instruction cache line fetch is signalled with both VPA and VDA being active at the same time.
This is like the first byte of an opcode fetch signaled on the 65816.

# New Address Modes
32-bit indirect address modes are denoted with {} characters, as in LDA {$23},Y

# Operand Size Prefixes
The '833 has operand size prefixes allowing the size of a load or store operation to be specified.


# FT833 FPU
There is an FPU in the works. The FPU is a memory mapped I/O device mapped into a range of zero page addresses at $6x.
It has 64 48-bit registers.
The FPU processes using a 48-bit floating-point format.
The native format for the FPU is non-IEEE. It is has a 10-bit exponent and 38 bit significand which is in two's complement format.
There are conversion functions to convert to or from a more standard 48-bit format.
Operations supported include FADD, FSUB, FMUL, FDIV, I2F, F2I, FABS, FNABS, FNEG.
The FPU is implemented using a sequential state machine which runs at a 100 MHz+. It can take many clock cycles for an operation to complete.
There is a status register which has a busy indicator along with other status results.


