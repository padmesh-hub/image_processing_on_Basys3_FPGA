`timescale 1ns / 1ps

module Address_Generator(
    
    input Clock_In,             // Input Clock
    input Data_Valid,           // Indicates that new pixel data is ready
    input Reset,                // Reset signal
    
    output reg [16:0] Address,  // BRAM write address
    output Write_Enable         // BRAM write enable
    
    );

    // Write Enable  
    assign Write_Enable = Data_Valid;

    // Address Counter
    always @(posedge Clock_In, posedge Reset) begin
        
        if (Reset) begin
            
            Address <= 17'd0;
            
        end
        
        else if (Data_Valid) begin
            
            if (Address == 17'd76799)
                Address <= 17'd0;
            
            else
                Address <= Address + 1'b1;     
        end 
    end
endmodule

