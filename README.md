# 📦 Synchronous FIFO in Verilog

A Verilog-based **Synchronous FIFO (First-In, First-Out)** memory buffer designed for temporary data storage and sequential data transfer in digital systems. This project implements a **32-bit wide, 32-entry deep FIFO** using read and write pointers, a data counter, and status flags.

The FIFO supports independent read and write operations, simultaneous read/write operation, overflow and underflow protection, and includes a Verilog testbench to verify the complete functionality through simulation.

## 📌 Features

### Data Storage

* 32-bit data width
* 32-entry FIFO depth
* First-In, First-Out data ordering
* Internal memory array for data storage
* Read and write pointer-based memory access

### FIFO Control

* Independent write enable (`we`)
* Independent read enable (`re`)
* `FULL` status flag
* `EMPTY` status flag
* FIFO occupancy tracking using a counter
* Automatic read and write pointer incrementing
* Automatic pointer wrapping

### Protection Features

* Prevents writes when the FIFO is full
* Prevents reads when the FIFO is empty
* Overflow protection
* Underflow protection

### Simultaneous Operations

* Supports simultaneous read and write requests
* FIFO count remains unchanged when both operations are valid
* Read and write pointers operate independently

### Verification

* Complete Verilog testbench
* Functional simulation using Xilinx Vivado Simulator
* FIFO fill verification
* FIFO empty verification
* Overflow testing
* Underflow testing
* Simultaneous read/write testing

## ⚙️ Module Inputs

| Signal    | Width | Description                      |
| --------- | ----: | -------------------------------- |
| `clk`     |     1 | System clock                     |
| `reset`   |     1 | Asynchronous active-high reset   |
| `we`      |     1 | Write enable signal              |
| `re`      |     1 | Read enable signal               |
| `data_in` |    32 | Input data written into the FIFO |

## 📤 Module Outputs

| Signal     | Width | Description                      |
| ---------- | ----: | -------------------------------- |
| `data_out` |    32 | Data read from the FIFO          |
| `FULL`     |     1 | Indicates that the FIFO is full  |
| `EMPTY`    |     1 | Indicates that the FIFO is empty |

## 📊 FIFO Configuration

The FIFO is configured with the following parameters:

```verilog
parameter DEPTH = 32;
parameter ADDR_WIDTH = 5;
```

The design stores **32 entries**, with each entry containing **32 bits of data**.

```text
Data Width : 32 bits
FIFO Depth : 32 entries
Capacity   : 32 × 32 bits
```

## 🔄 FIFO Architecture

The FIFO uses an internal memory array to store incoming data.

```verilog
reg [31:0] mem [0:DEPTH-1];
```

Two pointers are used to control access to the FIFO memory:

| Component | Description                                                 |
| --------- | ----------------------------------------------------------- |
| `w_pt`    | Write pointer that identifies the next location for writing |
| `r_pt`    | Read pointer that identifies the next location for reading  |
| `count`   | Tracks the number of valid entries currently stored         |

The FIFO status is determined using the occupancy counter.

```verilog
assign FULL  = (count == DEPTH);
assign EMPTY = (count == 0);
```

## 🚀 How It Works

1. After reset, the FIFO starts in an empty state.
2. When `we` is asserted and the FIFO is not full, `data_in` is stored in memory.
3. The write pointer advances to the next memory location.
4. When `re` is asserted and the FIFO is not empty, data is read from memory.
5. The read pointer advances to the next memory location.
6. The `count` register tracks the number of elements currently stored.
7. When `count` reaches `32`, the `FULL` flag is asserted.
8. When `count` reaches `0`, the `EMPTY` flag is asserted.
9. Write operations are ignored while the FIFO is full.
10. Read operations are ignored while the FIFO is empty.
11. When a valid read and write occur simultaneously, the FIFO occupancy remains unchanged.

The FIFO maintains **First-In, First-Out** ordering, meaning the first value written is the first value read.

## ✍️ Write Operation

A write operation occurs when:

```text
we = 1 and FULL = 0
```

During a valid write:

```verilog
mem[w_pt] <= data_in;
w_pt <= w_pt + 1;
```

The input data is stored at the location pointed to by `w_pt`, and the write pointer moves to the next memory location.

If the FIFO is full, additional write requests are ignored to prevent overflow.

## 📖 Read Operation

A read operation occurs when:

```text
re = 1 and EMPTY = 0
```

During a valid read:

```verilog
data_out <= mem[r_pt];
r_pt <= r_pt + 1;
```

The stored data is transferred to `data_out`, and the read pointer moves to the next memory location.

If the FIFO is empty, additional read requests are ignored to prevent underflow.

## 🔁 Simultaneous Read and Write

The FIFO supports read and write operations during the same clock cycle.

The occupancy counter is controlled using:

```verilog
case ({we && !FULL, re && !EMPTY})
    2'b10: count <= count + 1;
    2'b01: count <= count - 1;
    2'b11: count <= count;
    default: count <= count;
endcase
```

| Write   | Read    | FIFO Count |
| ------- | ------- | ---------- |
| Valid   | Invalid | Increment  |
| Invalid | Valid   | Decrement  |
| Valid   | Valid   | No Change  |
| Invalid | Invalid | No Change  |

## 🚦 FIFO Status

### EMPTY

The `EMPTY` flag is asserted when no valid data is stored in the FIFO.

```text
count = 0
EMPTY = 1
FULL  = 0
```

### FULL

The `FULL` flag is asserted when all 32 FIFO locations contain valid data.

```text
count = 32
EMPTY = 0
FULL  = 1
```

### Partially Filled

When the FIFO contains between 1 and 31 entries:

```text
EMPTY = 0
FULL  = 0
```

## 🧪 Testbench

The included `FIFO_TB.v` testbench verifies the following scenarios:

✅ FIFO reset operation
✅ Writing data into the FIFO
✅ Filling the FIFO to its maximum capacity
✅ `FULL` flag generation
✅ Overflow attempt when the FIFO is full
✅ Reading all stored FIFO data
✅ `EMPTY` flag generation
✅ Underflow attempt when the FIFO is empty
✅ Simultaneous read and write operation

The testbench generates a clock with a period of **10 ns**.

```verilog
always #5 clk = ~clk;
```

## 📷 Simulation

The design can be simulated using **Xilinx Vivado Simulator**.

The simulation waveform can be used to observe:

* `clk`
* `reset`
* `we`
* `re`
* `data_in`
* `data_out`
* `FULL`
* `EMPTY`

### Simulation Waveform

Add your Vivado simulation waveform screenshot here.

```text
Simulation Waveform
```

## 🛠️ Tools Used

* Verilog HDL
* Xilinx Vivado
* Vivado Simulator
* RTL Design
* Digital Logic Design

## 📚 Concepts Demonstrated

* Synchronous FIFO Design
* Sequential Logic Design
* Memory-Based Data Storage
* Read and Write Pointer Management
* FIFO Occupancy Counter
* First-In, First-Out Data Processing
* Overflow Protection
* Underflow Protection
* Simultaneous Read and Write Operations
* Verilog HDL Coding
* Testbench Development
* Functional Simulation

## 🎯 Applications

* FPGA-Based Data Buffering
* Digital Communication Systems
* Data Stream Processing
* Processor and Peripheral Interfaces
* Temporary Data Storage
* Pipeline Data Buffering
* Digital Electronics Projects
* Verilog HDL Learning
* RTL Design Practice

## 🚀 Future Improvements

* Parameterizable data width
* Automatic pointer width calculation using `$clog2`
* Automatic counter width calculation
* `ALMOST_FULL` status flag
* `ALMOST_EMPTY` status flag
* Self-checking testbench
* SystemVerilog assertions
* Randomized verification
* Improved boundary handling for simultaneous read/write operations
* Asynchronous FIFO implementation for clock-domain crossing
* FPGA hardware implementation

## 🤝 Contributing

Contributions, improvements, and suggestions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push the branch.
5. Open a Pull Request.

## 📄 License

This project is licensed under the MIT License.
