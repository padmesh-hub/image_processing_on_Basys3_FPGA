`timescale 1ns / 1ps
module Memory_Block(
    
    input Clock_In,             // Input Clock.
    input Reset,                // Reset signal
    input Data_Ready,           // To Indicate when one can write the data.
    input Read_Enable,          // To indicate when one can read the data.
    input [11:0]Data_In,        // Incoming data.
    input [16:0]Read_Address,   // Address location to read data from. ( 17 bits )
    
    output [11:0]Data_Out     // Data that is given to the VGA.
    );
    
    wire Write_Enable;
    wire [16:0]Write_Address;   // To indicate where to write the data.
    
    // The RAM
    blk_mem_gen_0 MEM 
    (
        .clka  ( Clock_In ),       // Input Clock Write side
        .ena    ( 1'b1 ),           // Another Write Enable
        .wea    ( Write_Enable ),   // Write Enable
        .addra  ( Write_Address ),  // Write Address
        .dina   (Data_In),          // Input Data
        
        .clkb   ( Clock_In ),       // Input Clock Read side
        .enb    ( Read_Enable ),    // Read Enable
        .addrb  ( Read_Address ),   // Read Address
        .doutb  ( Data_Out )        // To VGA 
    );
    
    // Write Address generator
    Address_Generator ADDW
    (
        .Clock_In( Clock_In ),         // The input clock
        .Data_Valid( Data_Ready ),     // Act as the Enable Signal
        .Reset( Reset ),               // Reset signal
        .Address( Write_Address ),     // Output to Write Address
        .Write_Enable( Write_Enable )  // Output to Block_RAM for 
    );
    
    //Address_VGA 
    
    Address_VGA AVGA
    (
     .Clock_In(Clock_In),
     .Data_Valid(Data_Valid),
     .Reset(Reset),
     .Rd_Enable(Read_Enable),
     .Rd_Address(Read_Address)
    );
    
    // Instantiating VGA controller to get Data__Valid signal
    VGA_controller VGA
    (
     .Clock_In(Clock_In),
     .Reset(Reset),
     .Data_Valid(Data_Valid),
     .Hsync(Hsync),
     .Vsync(Vsync),
     .video_on(video_on)    
    );
    
endmodule

