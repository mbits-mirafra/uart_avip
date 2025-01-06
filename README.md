# UART-AVIP
The idea of using Accelerated VIP is to push the synthesizable part of the testbench into the separate top module along with the interface and it is named as HDL TOP and the unsynthesizable part is pushed into the HVL TOP. This setup provides the ability to run the longer tests quickly. This particular testbench can be used for the simulation as well as the emulation based on mode of operation

Link:- https://github.com/mbits-mirafra/uart_avip/tree/main
====
UART-AVIP (Universal Asynchronous Receiver-Transmitter - Accelerated VIP )
====
1. UART-AVIP is a highly specialized verification intellectual property used to test and validate UART interfaces in hardware designs, typically in system-on-chip (SoC) environments.
2. UART is a widely used communication protocol for serial data transmission, and the AVIP provides tools for verifying that a UART interface behaves correctly according to its specification.
3. It Supports various UART configurations like baud rate, data width, parity, flow control, and stop bits

Features Supported
====
1)Data-Tranmission
    1. Asynchronous communication: Does not require a clock signal for synchronization.
    2. Full-duplex communication: Allows simultaneous data transmission and reception.
    3. Serial data transmission: Sends data one bit at a time over a single line.
    4. Data framing:
    Configurable frame format: Start bit, data bits, parity bit (optional), and stop bit(s).
    Typical frame: Start bit + Data bits (5-9) + Parity bit (optional) + Stop bit (1-2).

2) Buffering and Data Handling
    1. Transmit (TX) buffer: Data waiting to be sent is stored in a FIFO or register.
    2. Receive (RX) buffer: Incoming data is stored in a FIFO or register until it is processed.
    3. FIFO support: Reduces processor overhead by buffering multiple bytes.
       Common FIFO depths: 8, 16, or 64 bytes.
    4.Interrupt-driven operation: Generates interrupts for events like TX empty, RX full, or errors.
3) Communication Modes
   1. Loopback mode: Allows internal testing without external connections.
   2. Multi-processor communication mode: Supports communication with multiple UART devices in a bus configuration.

UART is simple, widely used, and requires only two main lines (TX and RX) for communication.


