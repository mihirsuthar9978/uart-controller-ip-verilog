# uart-controller-ip-verilog
# UART Controller IP Design in Verilog HDL

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) Controller IP in Verilog HDL.

The design consists of:

* UART Transmitter (TX)
* UART Receiver (RX)
* UART Controller Integration
* Loopback Verification Environment

The project was developed as part of RTL Design and Digital VLSI learning.

---

## Features

* Verilog HDL RTL Design
* FSM-Based UART Transmitter
* FSM-Based UART Receiver
* 8-bit Data Communication
* 1 Start Bit
* 1 Stop Bit
* No Parity
* Parameterized Baud Rate
* Loopback Verification
* Synthesizable RTL

---

## Project Architecture

UART Controller

TX Data → UART TX → Serial Line → UART RX → RX Data

The controller integrates transmitter and receiver modules to perform serial communication.

---

## RTL Modules

### UART TX

State Machine:

IDLE → START → DATA → STOP

Function:

* Accepts parallel data
* Converts data into serial format
* Transmits LSB first

---

### UART RX

State Machine:

IDLE → START → RECV → STOP

Function:

* Detects start bit
* Samples incoming serial data
* Reconstructs received byte
* Generates data_ready pulse

---

### UART Controller

Integrates:

* UART TX
* UART RX

Provides complete UART communication functionality.

---

## Verification

### UART TX Verification

Verified transmission of:

* 8'h3C

FSM transitions:

START → DATA → STOP → IDLE

Result: PASS

---

### UART RX Verification

Verified reception of:

* 8'h3C

Outputs:

data_out = 8'h3C

data_ready = 1

Result: PASS

---

### Loopback Verification

TX Output connected to RX Input

Transmitted:

8'h3C

Received:

8'h3C

Result: PASS

---

## Tools Used

* Verilog HDL
* Verilator
* GTKWave
* Ubuntu Linux

---

## Project Results

✓ UART TX Verified

✓ UART RX Verified

✓ UART Controller Verified

✓ Loopback Verification Passed

---

## Future Improvements

* Baud Rate Generator Integration
* FIFO Buffers
* Parity Support
* APB Interface
* AXI-Lite Interface
* RISC-V SoC Integration

---

## Author

Mihir Suthar

Electronics and Communication Engineering

Government Engineering College, Gandhinagar
