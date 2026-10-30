`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2026 15:32:23
// Design Name: 
// Module Name: memory_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory_fsm( input clk_24mhz,rst,dataready, input wire[7:0]data_in, output reg[11:0]data_out );
reg[3:0]d_1;
reg[7:0]d_2;

parameter idle=1'b0;
parameter split=1'b1;

reg ps,ns;
reg count=0;

always @ (posedge clk_24mhz or posedge rst) begin
      if(rst) begin
      ps<=idle;
      count<=0;
      end
      else if (dataready) begin
         ps<=ns;
         if(count==1) begin
           data_out<={d_1,d_2};
           count<=0;
           end
         else count<=count+1;
      end
end

always @ (*) begin
       case (ps) 
       idle: if(count==1) ns=split;
       split: if(count==1) ns=idle;
       default:ns=idle;
       endcase
end

always @ (ps) begin
      case (ps)
      idle: begin
      d_1=data_in[3:0];
      d_2=8'b0;
      end
      split:begin
      d_2=data_in[7:0];
      d_1=4'b0;
      end
      default: begin
      d_1=4'b0;
      d_2=8'b0;
      end
      endcase
end

endmodule
