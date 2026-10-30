`timescale 1ns / 1ps



module Address_VGA(input Clock_In,Reset,Data_Valid,output Rd_Enable, reg[16:0]Rd_Address);
reg Rd_Enable_reg;
always @ (posedge Clock_In or posedge Reset) begin
          if(Reset) begin
          Rd_Enable_reg<=1'b0;
          Rd_Address<=0;
          end
          
          else if(Data_Valid) begin
          Rd_Enable_reg<=1'b1;
            if(Rd_Address==76799) Rd_Address<=17'b0;
            else Rd_Address<=Rd_Address+1;
          end
end
assign Rd_Enable=Rd_Enable_reg;

endmodule
