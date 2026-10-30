`timescale 1ns / 1ps

module UART_TOP
    #(
    
    parameter D_Bits = 8,
    parameter Sampleing_Tick = 16,
    parameter Baud_Counter_Limit = 54,
    parameter Baud_Counter_Bits = 6
    )
    (
    input Clock_In_100_MHz,
    input Reset,
    input RX_Dataline,
    input VGA_Start,
    
    output [11:0]Data_Out,
    output Hsync,
    output Vsync
    );
    
    wire Sampleing_Tick_1;
    wire [7:0]Data_Out_UART;
    wire Byte_Valid;
    wire Data_Ready;
    wire [11:0]Data_Out_Pipeline;
    wire [16:0]Read_Address;
    wire Read_Enable;
    // 1st
    BAUD_RATE_GEN 
        #(
        
            .M( Baud_Counter_Limit ),
            .N( Baud_Counter_Bits )
        )
        Baud_rate_generator
        (
            .Clock_In_100_MHz( Clock_In_100_MHz ),
            .Reset( Reset ),
            .S_Tick( Sampleing_Tick_1 )
        );
     
     // 2nd
     UART_RX 
        #( 
            .D_Bits( D_Bits ),
            .Sampleing_Tick_Num( Sampleing_Tick )
         )
         Receiver
         (
           .Clock_In_100_MHz( Clock_In_100_MHz ),
           .Reset( Reset ),
           .Sampleing_Tick( Sampleing_Tick_1 ),
           .RX_Dataline( RX_Dataline ),
           .Data_Valid( Byte_Valid ),
           .Data_Out( Data_Out_UART )
         );
     
     // 3rd
     Eight_to_Tweleve pipeline_1
        (  
           .Clock_In( Clock_In_100_MHz ),
           .Reset( Reset ),
           .Byte_Ready( Byte_Valid ),
           .Byte_In( Data_Out_UART ),
           .Data_Valid( Data_Ready ),
           .Data_Out( Data_Out_Pipeline )
        );
        
     //4th
     Memory_Block Mem
          (  
             .Clock_In( Clock_In_100_MHz ),
             .Reset( Reset ),
             .Data_Ready( Data_Ready ),
             .Read_Enable( 1'b1 ),
             .Data_In( Data_Out_Pipeline ),
             .Read_Address( Read_Address ),
             .Data_Out( Data_Out )
          );
     
     //5th
     VGA_controller VGA
       (
          .Clock_In(Clock_In_100_MHz),
          .Reset(Reset),
          .Hsync(Hsync),
          .Vsync(Vsync)
       );
     
endmodule
