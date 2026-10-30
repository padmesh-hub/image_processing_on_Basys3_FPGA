`timescale 1ns / 1ps

// UART Recevier :-

// 1) Number of data bits transfered Per data tansmission cycle = 8.
// 2) Start bits used = 1.
// 3) Stop bits used = 1.
// 4) Baud rate used = 115200,

module UART_RX  
    #(   
    parameter D_Bits = 8,               // Number of data bits in the data word. 
    parameter Sampleing_Tick_Num = 16  // Number of over_sampling ticks.
    )
    (
    input Clock_In_100_MHz,     // Input Clock from FPGA.
    input Sampleing_Tick,       // Sampleing tick rate from Baud rate generator.
    input Reset,                // To reset the recevier.
    input RX_Dataline,          // Serial data line.
    output [D_Bits-1:0]Data_Out,            // Ouput data.
    output reg Data_Valid           // When entire data is ready to go.
    );
    
    // There are four states that are being used: Idle , Start , Data and Stop.
    
    localparam [1:0] Idle = 2'b00;   // Recevier data line is kept at high.
    localparam [1:0] Start = 2'b01;  // First time the dataline is pulled low.
    localparam [1:0] Data = 2'b10;   // D_bits are transmitted from the transmitter.
    localparam [1:0] Stop = 2'b11;   // Dataline is held high agian.
    
    // Registers
    
    reg [1:0] Current_State , Next_State;
    reg [3:0] Tick_Count, Tick_Next;                                  // For number of sampleing ticks
    reg [2:0] Number_Of_Bits_Received, Number_Of_Bits_Received_Next;  
    reg [7:0] Data_Reg, Data_Next;    
    // Current Updation logic
    always @ ( posedge Clock_In_100_MHz, posedge Reset ) begin
        
        if ( Reset ) begin
            
            Current_State <= Idle;
            Tick_Count <= 0;
            Data_Reg <= 0;
            Number_Of_Bits_Received  <= 0;
        end
        
        else begin
        
            Current_State <= Next_State;
            Tick_Count <= Tick_Next;
            Data_Reg <= Data_Next;
            Number_Of_Bits_Received  <= Number_Of_Bits_Received_Next;
        end    
    end
    
    // Next Updation logic
    always @ * begin
        
        Next_State <= Current_State;
        Tick_Next <= Tick_Count;
        Number_Of_Bits_Received_Next <= Number_Of_Bits_Received;
        Data_Next <= Data_Reg;
        Data_Valid <= 1'b0;
        
        case ( Current_State )
            
            Idle: begin
                
                if ( !RX_Dataline ) begin  // Start ccndition
                    
                    Next_State <= Start;
                    Tick_Next <= 0;
                end
            end
             
            Start: begin
                
                if ( Sampleing_Tick ) begin
                    
                    if( Tick_Count == Sampleing_Tick_Num/2 -1 ) begin             // TO come in between of the Start bit.
                        
                        Tick_Next <= 0;
                        Number_Of_Bits_Received_Next <= 0;
                        Next_State <= Data;
                     end
                     
                    else Tick_Next <= Tick_Count + 1;                              // If not in middle the increment by 1.
                end
            end
             
            Data: begin
                
                if ( Sampleing_Tick ) begin
                    
                    if ( Tick_Count == Sampleing_Tick_Num - 1 ) begin                    // Going to the center of the data bit.
                        
                        Tick_Next <= 0;
                        Data_Next <= { RX_Dataline, Data_Reg[7:1]};                      // Serial Data to parallel data.
                        
                        if ( Number_Of_Bits_Received == D_Bits - 1 )
                            Next_State <= Stop; 
                            
                        else
                            Number_Of_Bits_Received_Next <= Number_Of_Bits_Received + 1;
                    end
                    
                    else                                                                 // Increment by 1 to reach to the center of the data bit.
                        Tick_Next <= Tick_Count + 1;
                end
            end
            
            Stop: begin                                                                  // Stop condition
                
                if ( Sampleing_Tick ) begin                                              
                    
                    if ( Tick_Count == Sampleing_Tick_Num - 1 ) begin                    // If Center of stop bit is reached.
                        
                        Next_State <= Idle;
                        Data_Valid <= 1'b1;
                    end
                    
                    else                                                                 // Increment by 1 to reach to the center of the stop bit.
                        Tick_Next <= Tick_Count + 1;     
                end 
            end
        endcase
    end
    
    // Output Logic
    assign Data_Out = Data_Reg;
endmodule
