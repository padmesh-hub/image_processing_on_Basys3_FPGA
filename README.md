# Image Processing On Basys 3 FPGA 📸

This is the repository for the Image Processing on FPGA project, built on the Basys 3 development board. The aim of this project is to develop a custom, hardware-accelerated image viewer and processor, written in Verilog, that runs on an FPGA and shows its output on a VGA monitor.

## Project Overview

The system stores an image in the FPGA's internal memory, applies processing in hardware, and sends the outcome to a VGA monitor.

### Key Functionality

**Image Input:** The image data is loaded into the FPGA's internal memory. The image is stored as RGB444 pixels (4 bits each for red, green and blue).

**On-Chip Storage:** The Block RAM (BRAM) inside the FPGA holds the full image, so it can be read quickly and continuously while the screen is refreshed.

**Display:** A custom VGA (Video Graphics Array) controller reads the stored image and shows it on a 640x480 @ 60 Hz display by generating the horizontal and vertical sync signals and the pixel addresses.

**Mode Control:** Physical switches on the board control what is shown. They select between the original image and the processed output.

**Image Processing:** The processing logic runs on dedicated hardware and works on every pixel as it is read out for display, so the result appears on screen in real time.

## Tools and Technologies
<img width="807" height="330" alt="Screenshot 2026-10-30 170445" src="https://github.com/user-attachments/assets/3e0a71ee-d229-40fc-877f-89bd389d5bf6" />

