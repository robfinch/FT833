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

## Datapath
The datapath is 32-bits wide. The size of data worked on is controlled in the same manner as for the 65816, with bits in the status register.
Because there are now multiple data sizes, the load and store instructions may load varying sized data if they are prefixed with size prefixes.
This allows byte and half-word data to be loaded when the CPU is in 32-bit mode.

## New Address Modes
There are new "extra long" address modes which use a 32-bit absolute address.
32-bit indirect address modes are denoted with {} characters, as in LDA {$23},Y

## Instruction Cache
The instruction cache is organized as 256 lines of 16 bytes or 4kB.
The leading byte of an instruction cache line fetch is signalled with both VPA and VDA being active at the same time.
This is like the first byte of an opcode fetch signaled on the 65816.

## Single Step Mode
The CPU features a single step mode which traps after the execution of each instruction.

## Long Branches
Branches support an additional 16-bit displacement if the displacement byte is $FF which would otherwise branch backwards to the displacement byte.

## Multiply
There is a single multiply instruction allowing the .A and .X register may be multiplied together.

# Future Changes
The CS, DS, and SS registers are going. Replaced by a paged MMU.


# FT833 FPU
There is an FPU in the works. The FPU is a memory mapped I/O device mapped into a range of zero page addresses at $6x.
It has 64 48-bit registers.
The FPU processes using a 48-bit floating-point format.
The native format for the FPU is non-IEEE. It is has a 10-bit exponent and 38 bit significand which is in two's complement format.
There are conversion functions to convert to or from a more standard 48-bit format.
Operations supported include FADD, FSUB, FMUL, FDIV, I2F, F2I, FABS, FNABS, FNEG.
The FPU is implemented using a sequential state machine which runs at a 100 MHz+. It can take many clock cycles for an operation to complete.
There is a status register which has a busy indicator along with other status results.

# FT833 MMU
The MMU is a simple page mapper. It maps virtual addresses to pages of memory. The page size is 1kB.
The mapping table has 32768 entries in it allowing a maximum of 32MB of physical memory.
The MMU works using 32 address spaces of a 1 MB maximum each.
The entire 64kB mapping table is present in all virtual address spaces.

# Performance
This core currently does not have good performance. Current timing allows it to run about 20 MHz.
This is partly due to the complex nature of the core.
The FPU and MMU will likely run at six times the CPU frequency.
This allows FPU ops to be completed relatively faster.
For example a FMUL takes about 100 FPU clocks which turns into about 17 CPU clocks.
Teh much higher frequency of the MMU allows it to map an address within the same CPU clock cycle as is issued.
So, there is no slow-down due to virtual addressing.

# Core Size
The core is relatively small, only about 10,000 LUTs (16,000 LC's) in size.
