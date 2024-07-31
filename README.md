# Hardware-Accelerator-using-modified-systolic-array_architecture
Accelerator used to perform matrix multiplication operations. Seamlessly integrates with a CPU via AXI4 interfaces. Key components: AXI4 Slave/Master interfaces, Controller, Input/Weight/Output memories, 9x9 Processing Elements. Implements interrupt handling. Designed using Verilog.
# Key-Feature
+ AXI4 Slave Interface: Allows the CPU to configure and control the accelerator's operation by writing to specific registers.
+ Controller: Orchestrates the overall operation of the AI accelerator, managing data flow and controlling the execution of convolution and matrix multiplication operations.
+ AXI4 Master Interface: Enables the accelerator to access external memory (e.g., DRAM) for fetching input data and storing output data.
+ Input & Weight Memory: Stores input data (e.g., images or feature maps) and convolution kernels or weights required for computation.
+ Output Memory: Stores the results of convolution and matrix multiplication operations.
+ Processing Elements: Each processing element constitutes a 9x9 grid, capable of performing maximum matrix multiplication of 9x9 and convolution operations with a kernel size of 3x3.
+ Interrupt Handling: Implements interrupt mechanisms to signal task completion, enabling efficient coordination between the CPU and the accelerator.
