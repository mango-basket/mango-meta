# 07-09-2025

- [x] Implement labels
- [x] If statements

# 08-09-2025

- [x] add support for comments
- [x] remove logical from isa (unnecessary)
- [x] Bitwise & | ^ ~ << >>
- [x] Logical && ||
- [x] basic loop
- [x] split up codebase

# 09-09-2025

- [x] registers
  - [x] design changes to instruction set to include registers

# 10-09-2025

- [x] modulo operator

- [x] pointers
  - @a to get pointer *a to deref
  - 16 bit, obviously
  - new instuctions
    - LOADP - pops address from stack and pushes value from that address
    - STOREP - pops value then address from stack, pushes value into the address
  - [x] lexer
  - [x] parser
  - [x] type checker

# 11-09-2025

- [x] symantic analysis
  - How do we know if p in `*p = a` is a valid derefence?
    - parser guarantees its a deref in the first place (parse_reassign is only triggered with ident or *)
    - type checker guarantees deref is valid, and only valid derefs are of ref types, and only valid ref types are identifiers (also guaranteed by the parser and type checker)

- [x] grammar
- [x] isa
- [x] codegen
- [x] vm
  - [x] allow access to stack and frame pointers through registers r4 and r5

- [x] add slices to all the errors ever

- [x] writing output (hacky)
  - I'm going to use a disp keyword followed by an expression which will write that information ("magically" converts ints and bools) into video memory
  - new instructions
    - PRINT - pops from the stack and writes the lower 8 bits to the video memory at cursor
    - MVCUR i8 - move the cursor relative to current position
  - [x] lexer
  - [x] parser
  - [x] type checker
  - [x] semantics (not really needed)
  - [x] isa and grammar
  - [x] codegen

    ### Sidequest alert!
    - [x] call and ret instructions with print subroutine at the bottom of the file
    - [x] assmebler emiting object files
    - [x] linker

    - [x] compiler
    - [x] binary gen

  - [x] vm
    - [x] must inc ip as soon as instruction is fetched for ret and call purposes
    - [x] new instructions
    - [x] implement video memory
    - [x] implement print video memory with crossterm
    - [x] implement instructions

# 12-09-2025

- [x] debugger upgrade

# 13-09-2025

- [x] refactor assembler
- [x] refactor linker

# 14-09-2025

- [x] split compiler into compiler, assembler and linker
- [x] enable vm to check for magic number in binary
- [x] rewrite hardcoded print subroutine in assembly

# 15-09-2025

- [x] functions
  - [x] func def
    - [x] parsing
    - [x] type checking - disallow redefs
    - [x] semantincs

# 16-09-2025

- [x] func calling
  - [x] parsing
  - [x] type checking
  - [x] symantics
- [x] instructions for memory access wrt pointer registers
- [x] get rid of the whole slots situation actually, use stack pointer offsets

## Major deprication in the ISA

    - LOAD8 and STORE8 will no longer be used

## New conundrum

    - what if the stack is dirty when calling ret?
    - return values, where do they go?

## The answer?

    - Calling convention!

- [x] codegen

# 18-09-2025

- [x] give main function special thingies like
  - [x] no params
  - [x] no return
  - [x] no RET, straight to HALT
- [x] assembler
- [x] linker?
- [x] implement new ops on vm
- [x] require main function

# 19-09-2025

- [x] fix bug in typechecker that ignores returns nested inside other structures
  - took out hunting for a return statement in the function. that wont be good long term

# 20-09-2025

## Plan of action

- [x] renames slices to span
- [x] modify AST to handle slices properly and accurately

# 21-09-2025

- [x] handle return type problem (does not even check for returns in a function now)

### The `RetStatus` Situation

- Allow `Maybe`s when type checking, throw errors at it in the analyzer run

- [x] modify AST to carry types, set by type checker
- [x] `analyzer.rs` should handle main function checking, breaks/continues, reference validation
- [x] seperating if statements and if expressions (relevant for type and return checking)

- [x] fix loop print 1-10 code bug
- [x] calling convention fix in `type_check.rs` `declare_function`

## Calling convention

Stack grows down (top of stack is higher memory)

```
+---------------------------+
|       Optional return     | <- only if function returns non-unit
+---------------------------+
|        Parameter n        |
+---------------------------+
|        Parameter ...      |
+---------------------------+
|        Parameter 1        |
+---------------------------+
|       Return address      | <- (fp + 4) caller’s return location
+---------------------------+
|           Old FP          | <- (fp + 2) previous FP
+---------------------------+
|      Local variables      | <- (fp + 0) allocated downward from fp_offset
+---------------------------+
|           ...             | <- lower memory
```

# 22-09-2025

- [x] fix branching and pushing 0 or 1 mess
  - [x] send the condition into a seperate function -> if condition is not binaryop, evalute with gen_instrs and return -> if its a binary op, gen left and right recursively -> if its ||/&&, handle accordingly -> if its comparison, handle accordingly, plug in the correct branch instrs
- [x] found another bug, when a function is called, locals arent allocated, which makes `sp` dip down into the locals in some cases
- [x] debugger TUI overhaul

# 23-09-2025

- [x] char datatype
  - [x] lexer/parser
  - [x] single byte
    - [x] allow comparisons
    - [x] no arithmetic operations allowed on it
  - [x] allow convertions to and from char to int
    - [x] `as` keyword implementation

    ### Conversion Rules
    - `int as char` int & 0xF
    - `bool as int` reinterpret
    - `char as int` reinterpret

  - [x] change functionality of disp to print one `char` w/o newline
  - [x] rewrite a `print` subroutine (move away from using `PRINT` and `MVCUR`, they're pretty high level for assembly instructions and I wanna move away from them)
- [x] Hello, world!
- [x] mod instruction
- [x] hex numbers in assembly

## NOTE

- Can't reliably print numbers because no data structure to store and reverse the order of the digits haha

- [x] constants in assembly
- [x] rewrite print subroutine with the constants
- [x] stack allocated arrays
  - [x] lexer
  - [x] ast
    - [x] indexing
  - [x] parser
    - [x] allow shorthand `var a[b: type]` where `b` has to be an int literal. ??? type?
    - [x] allow `var a = [1, 2, 3, 4];`
    - [x] indexing
    - [x] type definitions
    - [x] disallow empty arrays
  - [x] type checker
    - [x] type checking for new ast nodes
    - [x] handle type definitions
    - [x] handle assigning to an index

## ASSUMPTION

> Each statements leaves the sp where it found it (ideally)

- When this assumption fails, the stack allocated arrays fall. And it could fail, ALL THE TIME.
- Should I enforce it?
  - I will proceed assuming it leaves it untouched and see if there are any serious offenders
  - Dead code analysis could fix all of this, but I digress
  - Look into stack balancing

  - [x] codegen
    - [x] generate code for new ast kinds
    - [x] `var a[4]`, evaluating `a` in `var x = a`, `x` would get a pointer to the array;

## HUGE BUG

- The way `TypedAstNode::from_ast` works, everything gets an eval type of Unit passed down to it from statements getting unit.

# 25-09-2025

- [x] each element in a `char` or `bool` array may only take up 1 byte + padding
  - [x] new instructions `LOADPB` and `STOREPB` for byte addressing
  - Whats the strategy?
    - Allocate the stack first
    - Compute each element
    - Pack it in

- [x] allow size ambigious array type definitions in function parameters
  - [x] must be mandatory for vardef, but not in function parameter context
- [x] introduced a tiny optimization for labels and jumps
- [x] strings!
  - [x] null terminated
  - [x] lexer
  - [x] parser
  - [x] typechecker - pass as `[char]`
  - [x] analyzer
  - [x] codegen

- [x] store strings in data section of binary
  - [x] introduce sections into the assembly format
    - [x] `@section data` and `@section text` in the assembly
    - [x] data section needs to only handle strings for now.

## Assembly file structure

```
; constants
@define X = 42
@define Y = 0x2E

; data section allow labelled and unlabelled data
@section data
msg = "Hello, world!\n"

; text section
@section text

start:
  CALL main
  HALT
main:
  PUSH16 msg
  POPR   r0
  CALL   print
  RET
```

- [x] new pseudo-instruction `DATA`
- [x] update linker
- [x] update binary format
- [x] update vm

# 26-09-2025

- [x] update compiler
  - [x] write `@section text` above the instructions
  - [x] generate arrays in reverse so that the indeces goes up
  - [x] use data section for strings

## Immediate plans for VM

### VM v0.1.1

# 07-10-2025

- [x] reduce/simplify instruction set
  - [x] warnings in the VM for depricated instructions
  - [x] convenience instructions (or macros/subroutines) are expanded out in the assembler
  - [x] remove depricated instructions from the compiler
  - [x] implement mul, div and mod subroutines
    - [x] expand to 8 GPRs, just makes life easier writing subroutines
      - r0-r5 caller-saved (volatile)
      - r6-r7 callee-saved (preserved)
      - r8 sp
      - r9 fp

# 08-10-2025

### Sidequest ALERT

- [x] Interrupt/like command to put a character on the screen
  - [x] Tear out video memory from the VM
  - [x] Implement it as a seperate array in the debug screen
  - This is relevant because it DRASTICALLY reduces the code size for debugging purposes
  - Kinda magic-y atm

# 09-10-2025

- [x] fix the horrible bug, i suspect something is getting messed up in the indexing logic
  - it was failure to clear r0 in the beginning of the mul subroutine
- [x] new bug because of ordering of value and addr in `STW` cant match with `STR`
  - [x] rearrange ordering

# 10-10-2025

- proper interrupts
  - [x] emulate a disk with 65,536 (2 bytes) sectors, each sector 256 bytes. total 16 MB of storage
    - [x] decide a file format for the disk for efficient data storage, we dont want to bloat up the RAM on the host device when loading the disk
      - there will be a folder called `disk`
        - there will be a `table.bin` file that keeps track of which sectors and occupied and which are empty
        - empty sectors have no corresponding files, occupied sectors have a corresponding file called `sector_XXXX.bin`, `XXXX` being the sector address in hex.
  - [x] update linker with option to modify base offset
    - [x] kernel mode and user mode
      - [x] switch to kernel mode when calling `INT`
      - [x] `IRET` switches back to user mode
      - [x] user mode only allows writing to stack (and allocated parts of heap but we dont have a heap right now)
      - [x] kernel mode can modify anywhere, except rom, nothing can write to rom

# 11-10-2025

- [x] first sector contains BIOS, its loaded by the host from the ROM
- [x] the BIOS then gets executed, which saves the IVT, and loads the Interrupt handlers into memory
  - [x] lets define 8 interrupts for now
    - [x] 0 - print char
    - [x] rest can `IRET` straight back
  - [x] MMIO definitions for disk and terminal
  - [x] enterrupt handlers can live in sectors 1-8 and will be loaded in by the BIOS
  - [x] user code can live in sector 9-72 (16KB) (64 sectors)

## Memory Layout

| Start  | Stop   | Size              | Purpose                                      |
| ------ | ------ | ----------------- | -------------------------------------------- |
| 0x0000 | 0x00FF | 256B              | ROM - BIOS gets loaded in here from sector 1 |
| 0x0100 | 0x010F | 32B               | IVT - Loaded in by the BIOS                  |
| 0x0110 | 0x090F | 2KB               | Interrupt Handlers                           |
| 0x0910 | 0x490F | 16KB              | User code                                    |
| 0x4910 | 0x4A0F | 256B              | MMIO                                         |
| 0x4A10 | 0xFEFF | 46,320B ~ 45.23KB | Heap memory                                  |
| 0xFF00 | 0xFFFF | 256B              | Stack Memory                                 |

## MMIO Layout

| Name        | Stop   | Size | Purpose                                                               |
| ----------- | ------ | ---- | --------------------------------------------------------------------- |
| PRINT       | 0x4910 | 1B   | Data write to terminal, cleared after read                            |
| INPUT       | 0x4911 | 1B   | Last key pressed (sticky, for backward compat)                        |
| INPUT_RD    | 0x4912 | 1B   | Read-once input buffer - pops next buffered key or returns 0 if empty |
| DISK_SEC    | 0x4920 | 2B   | Sector address to load                                                |
| DISK_ADR    | 0x4922 | 2B   | Address to read/write to/from                                         |
| DISK_CMD    | 0x4924 | 1B   | 0 = idle , 1 = read, 2 = write (unsupported)                          |
| DISK_STATUS | 0x4925 | 1B   | 0 = ready, 1 = busy, 2 = error                                        |

### Input Buffer

The VM maintains an internal ring buffer (capacity 10). When a key is pressed:

1. The key code is written to `INPUT` (0x4911) - sticky, always shows last key
2. The key code is pushed into the internal input buffer

To read input in a program:

1. Read from `INPUT_RD` (0x4912) via `LDB`
2. If the return value is 0, no input is currently available
3. If non-zero, the value is the next buffered key and has been removed from the buffer
4. Subsequent reads from `INPUT_RD` return the next buffered key, or 0 if the buffer is empty

The legacy `INPUT` address (0x4911) still contains the most recent key press for backward compatibility.

- [x] split shift instructions to `SHL` and `SHR`
- [x] immediate instructions for arithmetics and moves
- [x] imul and idiv subroutines are horribly inefficient. fix that
- [x] normal running mode to run at full speed

# 14-10-2025

- [x] fix nasty jump bug for the loop on `fib.mg`
  - [x] found it. 8 bit jumps arent doing it anymore
    - [x] Add 16 bit rel jump instructions

# 17-11-2025

- [x] while loops

# 25-11-2025

- [x] introduce shorthand syntax for variable updations (`+=`, `-=`, etc.)
  - [x] lexer
  - [x] AST
  - [x] parser
  - [x] type checker
  - [x] pass semantic
  - [x] codegen

# 30-11-2025

## Restructuring plans

- [x] Split up the project into **compiler**, **assembler**, **linker**, **VM core** and **video interface**

# 01-12-2025

> squeeze in a couple of optimization layers in between semantic analyzer and code generation

## Optimization

What IRs do I already have?

- Typed AST
- Proto-assembly (rust enum)

# 02-12-2025

- [x] constant folding (on the ast)
  - [x] arithmetic
  - [x] constant type casts

# 03-12-2025

- [x] logical and airthmetic optimizations (on the ast)
  - [x] chained pos/neg/not folding
  - [x] add/sub by 0
  - [x] mul/div/mod with 0
  - [x] mul/div/mod by 1
  - [x] and with false is false
  - [x] or with true is true
  - [x] and with true is redundant
  - [x] or with false is redundant

# 21-12-2025

- [x] handle not just literals, but anything that evaluates into ints/bools for optimizations
  - [x] bug c1: spans arent calculated accurately when constant folding happens

- [x] bug c2: variable allocation dead assembly when there are no locals

# 30-12-2025

- [x] stack balancing - ir builder level
  - [x] every `statement` should leave the stack pointer where it was after execution
- [x] bug c3: variable udpation syntax adds some redundant code

# 22-07-2026

- [x] memory mapped keyboard input
  - [x] memory location updates on key press for specific keys
  - [x] input ring buffer implementation (10 bytes)
  - [x] fixed input not being cleared after read

- [x] Removed deprecated `stdlib/print.masm` (direct video memory writes blocked by MMIO guard in user mode)

# 23-07-2026

- [ ] support for library mg files
  - [ ] imports like `import math` or `import io`
  - [ ] compiler preprocessing replaces that declaration with that file, no namespaces yet, maybe in the future

> I went down this rabithole of features and now here's a new

## SIDE QUEST - `mgbuild`, `.mif` files, and libraries!

The new pipeline goes as follows

### 1. Path one

- compiler compiles `.mg` library source (no `main` function, compile with the `--lib` flag) to `.masm` assembly and the **new** `.mif` interface file! `.mif` files work like c header files, storing the type signatures of whats exposed publicly in a `.mg`. these `.mif` can also be handwritten if I need to write library in `.masm` and wish to expose it to the compiler.
- assembler takes the `.masm` and `.mif` (optionally) and makes a `.mobj` file with a **new** metadata section which stores this interfacing info in binary, which will then be reffered to by the compiler when imports are used in an `.mg` and typechecks with them, no need to compile, just jump to the metadata of the `.mobj` and see the interfaces.
- linker then links all the given `.mobj`s, into one solid `.mbin` file that can get executed in the vm!

### 2. Path two

- **new** `mango` builder application looks for `main.mg` in the current working directory _or_ takes in a file, and makes a run, makes sure all the libraries imported are compiled into `.mobj`s, if not compiles them, and then follows the path one route automatically, finally spitting out a standalone binary

### Steps:

#### Assembler

- [ ] udpdate `.mobj` format
  - [ ] add `metadata_len` field, and bump up version to 3
  - [ ] set it to 0 for now
- [ ] define `.mif` format
- [ ] define metadata binary format
- [ ] write a `.mif` parser in the assembler
- [ ] edit the assembler to allow an optional interface file and embed the metadata into the output object file
- [ ] add a `--dump-meta` option to the assembler which reads the metadata in a file and prints the `.mif`

#### Linker

- [ ] make sure linker works properly with version 3

#### Compiler

- [ ] add a `pub` keyword to the language which can be used with functions
- [ ] add `use` keyword for importing libraries
- [ ] imports are handled by finding the correct object files and scanning the metadata, and adding the functions to the symbol table
- [ ] lack of `main` function is ignored when the compiler is run with the `--lib` flag. compiler also generates a `.mif` interface file along with the assembly.

#### Builder

- [ ] `mgbuild` utility that unifies everything into an easy pipeline and makes sure the imports are also compiled
  - [ ] environment variables can be used to set paths for the compiler and builder to check for libraries
  - [ ] if source file is newer than the object file, recompile

# Future

- [ ] a new io library in the stblib folder for print and input
  - [ ] input function for the high level mangolang

- [ ] mid to low level IR implementation for optimizations
  - [ ] reduces `while` loops to normal `loop`s

- [ ] ARM-64 target support

## Control flow graphs!

- [ ] dead code analysis (on the ast)
  - [ ] unused variables/functions; remove unused declarations
  - [ ] ifs or loops that are never entered
- [ ] loop invariance hoisting (on the ast)
- [ ] jump optimizations (on the proto-assembly)

- [ ] make optimizer pass optional

- [ ] Add READMEs describing how to use each binary
- [ ] update grammar docs

- [ ] introduce `uint` type
- [ ] allow only `uint`s to index
- [ ] send all errors together instead of bubbling up
- [ ] heap allocation!
- [ ] vectors!
- [ ] floats?
- [ ] constants
- [ ] functions as parameters
- [ ] register based arithmetic instructions
- [ ] allow multiple files
  - [ ] implement modules and namespaces
  - [ ] some level of label scrambling for handling namespace collisions on the assembler level
  - [ ] enforce main function on the assembler level not codegen level
  - [ ] allow only function headers to pass through for functions implemented in assembly
    - [ ] new syntax for letting a function pass through the undefined functions check
  - [ ] new syntax for imports

## Plans for the vm

> Not touching this anytime soon. VM is simple enough now, might get rid of a few instructions but let it stay a stack machine

- Focus on flushing out all the bugs in the codegen, and then focus on vm
  - [/] redesign the ISA, a lot of bloat instructions that can be avoided
  - [x] move away from purely stack based design into more register/stack design
  - [ ] ideally take inspiration from or entirely emulate an alreay existing CPU of similar power
  - [ ] Seperate the VM project from the rest of the compiler
  - [x] Macros in the assembly? (inspiriation from the jdh video)
