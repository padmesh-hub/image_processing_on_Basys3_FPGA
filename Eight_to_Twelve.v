`timescale 1ns / 1ps

module Eight_to_Tweleve(
    
    input Clock_In,        // Input clock
    input [7:0]Byte_In,    // Input Byte
    input Reset,           // For Register
    input Byte_Ready,      // Ready signal for byte ( Sending end )
    
    output reg Data_Valid, // Output ready signal
    output [11:0]Data_Out  // Ouput data  
    );
    
    // States
    parameter Idle = 1'b0;
    parameter Data = 1'b1;
    
    // Registers
    reg Current_State, Next_State;
    reg [3:0]Current_Red, Next_Red;
    
    // Updation Logic Current
    always @ ( posedge Clock_In, posedge Reset )  begin
        
        if ( Reset ) begin
        
            Current_State <= Idle;
            Current_Red <= 0;
        end
        
        else begin
            
            Current_State <= Next_State;
            Current_Red <= Next_Red;
        end
    end
    
    // Updation Logic Next
    always @ * begin
        
        Next_State <= Current_State;
        Next_Red <= Current_Red;
        Data_Valid <= 1'b0;
        
        case ( Current_State )
        
            Idle: begin
                
                if ( Byte_Ready ) begin
                    
                    Next_State <= Data;
                    Next_Red <= Byte_In[3:0];
                end 
            end
            
            Data: begin
                
                if ( Byte_Ready ) begin
                    
                    Next_State <= Idle;
                    Data_Valid <= 1'b1; 
                end
            end
        endcase
    end
    
    
    // Output Logic
    assign Data_Out = { Current_Red, Byte_In}; 
    
endmodule