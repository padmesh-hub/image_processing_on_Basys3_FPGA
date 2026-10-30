`timescale 1ns / 1ps
//--------------

// Over Sampleing rate :- 16
// Baud rate :- 115200

// M-Counter :- M = 54 ( for 115200 )
// Calc of M :- ( 100 * (10^6) )/ ( Over-sampleing rate * Baud rate )

// Number of bits required ( N ) :- 6 bits for the counter.

//--------------
module BAUD_RATE_GEN
    #(
    parameter M = 54,      // The value after which the counter is required to reset,
    parameter N = 6        // Number of bits requied to store M
    )
    ( 
    input Clock_In_100_MHz, // Input Clock
    input Reset,            // To reset the counter
    output S_Tick           // Sampleing tick for 16 times over sampleing
    );
    
    // Counter Register
    reg [ N - 1 : 0 ] Counter;              // TO counter the number of clock cycles
    wire [ N - 1 : 0 ] Counter_Next_Value;  // To update the value of counter outside the always block
    
    // Updation logic
    always @ ( posedge Clock_In_100_MHz, posedge Reset ) begin
        
        if ( Reset ) 
            Counter <= 0;
            
        else 
            Counter <= Counter_Next_Value;
    end
    
    // Updating the value of counter by:-
    // 1) +1 is counter is smaller than M-1,
    // 2) reseting the valuse to zero is counter is equal to M, 
    
    assign Counter_Next_Value = ( Counter == M - 1 ) ?  1'b0 : Counter + 1; 
    
    
    // Output Logic ;-
    // 1) If Counter = M-1, Then output = 1,
    // 2) Else output equals 0
    
    assign S_Tick = ( Counter == M - 1 ) ?  1'b1 : 1'b0;
endmodule
