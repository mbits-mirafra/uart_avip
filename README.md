# UART-AVIP
The idea of using Accelerated VIP is to push the synthesizable part of the testbench into the separate top module along with the interface and it is named as HDL TOP and the unsynthesizable part is pushed into the HVL TOP. This setup provides the ability to run the longer tests quickly. This particular testbench can be used for the simulation as well as the emulation based on mode of operation

Link:- https://github.com/mbits-mirafra/uart_avip/tree/main
====
UART-AVIP (Universal Asynchronous Receiver-Transmitter - Accelerated VIP )
====
1. UART-AVIP is a highly specialized verification intellectual property used to test and validate UART interfaces in hardware designs, typically in system-on-chip (SoC) environments.
2. UART is a widely used communication protocol for serial data transmission, and the AVIP provides tools for verifying that a UART interface behaves correctly according to its specification.
3. It Supports various UART configurations like baud rate, data width, parity, flow control, and stop bits

# UART-AVIP
## UART AVIP ARCHITECTURE
![image](https://github.com/user-attachments/assets/7a37a021-88ac-4cbf-a1aa-09490f3d0837)
## DATA FORMAT
### Relationships Between Data Bit, BCLK, and UART Input Clock
![image](https://github.com/user-attachments/assets/990c8768-5e1e-45a2-ad59-1b2fac04e0c7)

#### Transmit/Receive for 5-bit data, parity Enable, 1 STOP bit
![image](https://github.com/user-attachments/assets/a7de8322-91fb-4bad-aec5-432e1b99f659)

- This is a 5-bit data transmission with a  start bit  (transitioning from 1 to 0) to indicate the beginning of data, a parity bit for error detection and one stop bit for synchronization. It ensures reliable data transfer in serial communication protocols.

#### Transmit/Receive for 6-bit data, parity Enable, 1 STOP bit
![image](https://github.com/user-attachments/assets/073ff532-01d3-444a-81c2-45631dcad368)

- This is a 6-bit data transmission with a  start bit  (transitioning from 1 to 0) to indicate the beginning of data, a parity bit for error detection and one stop bit for synchronization. It ensures reliable data transfer in serial communication protocols.

#### Transmit/Receive for 7-bit data, parity Enable, 1 STOP bit
![image](https://github.com/user-attachments/assets/ae27f986-4478-474d-aa27-a3bd2729f5da)

- This is a 7-bit data transmission with a  start bit  (transitioning from 1 to 0) to indicate the beginning of data, a parity bit for error detection and one stop bit for synchronization. It ensures reliable data transfer in serial communication protocols.

## TESTCASES
### UART FRAMING ERROR NO PARITY TEST:
![UartFramingErrorNoParityTest](https://github.com/user-attachments/assets/370929bc-2709-44a6-9b83-62cd772edf59)

### UART EVEN PARITY WITH ERROR TEST
![UartEvenParityWithErrorTest](https://github.com/user-attachments/assets/1272fd9e-49c8-4007-a20a-24d5d54c218c)


