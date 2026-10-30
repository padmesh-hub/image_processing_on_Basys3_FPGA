# Image Processing On Basys 3 FPGA 📸

This is the repository for the Image Processing on FPGA project, built on the Basys 3 development board. The aim of this project is to develop a custom, hardware-accelerated image viewer and processor, written in Verilog, that runs on an FPGA and shows its output on a VGA monitor.

## Project Overview

The system stores an image in the FPGA's internal memory, applies processing in hardware, and sends the outcome to a VGA monitor.
<img width="2720" height="1400" alt="image_streaming_uart_elaborated_design" src="https://github.com/user-attachments/assets/cd858253-50c2-4d04-81e2-d9b56389ea47" />


### Key Functionality

**Image Input:** The image data is loaded into the FPGA's internal memory. The image is stored as RGB444 pixels (4 bits each for red, green and blue).

**On-Chip Storage:** The Block RAM (BRAM) inside the FPGA holds the full image, so it can be read quickly and continuously while the screen is refreshed.

**Display:** A custom VGA (Video Graphics Array) controller reads the stored image and shows it on a 640x480 @ 60 Hz display by generating the horizontal and vertical sync signals and the pixel addresses.

**Mode Control:** Physical switches on the board control what is shown. They select between the original image and the processed output.

**Image Processing:** The processing logic runs on dedicated hardware and works on every pixel as it is read out for display, so the result appears on screen in real time.

## Tools and Technologies
<img width="807" height="330" alt="Screenshot 2026-10-30 170445" src="https://github.com/user-attachments/assets/3e0a71ee-d229-40fc-877f-89bd389d5bf6" />

## RTL Modules
## RTL Architecture & Module Breakdown

* **`UART_TOP`**: Top-level integration module instantiating the baud rate generator and receiver modules to establish asynchronous serial reception from the host/peripheral interface.
* **`Baud_rate_generator`**: Frequency divider that divides the system clock down to match standard communication speeds (e.g., 9600 or 115200 baud), generating precise sampling ticks for data reception.
* **`UART_Rx`**: Finite State Machine (FSM) based serial receiver that samples the incoming serial line, detects start and stop framing bits, and deserializes 8-bit payloads into parallel registers.
* **`pipeline-Eight_to_twelve`**: Data format alignment and repacking pipeline that captures sequential 8-bit stream inputs and packs/downscales them into 12-bit parallel RGB444 color format words for display processing.
* **`BRAM Memory_Block`**: Dual-port on-chip Block RAM IP serving as a shared video frame buffer—allowing asynchronous write access from the capture/serial clock domain and read access from the VGA display clock domain.
* **`Address_Generator`**: Synchronous indexing unit that tracks write pointers during packet assembly and computes linear read addresses (`(Y * 320) + X`) synchronized to the raster scan timings.
* **`VGA Controller`**: Hardware timing generator that produces industry-standard horizontal (`HSYNC`) and vertical (`VSYNC`) synchronization signals, blanking porch intervals, and coordinates `(X, Y)` for a 640×480 @ 60 Hz display output.
  ![Uploading Screenshot 2026-10-30 171909.png…]()

