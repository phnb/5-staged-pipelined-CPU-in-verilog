/* The program Counter
**
*/

`timescale 100fs/100fs
module PC
    (   //Inputs
        input clk, reset, refresh1,
        input [5:0] opcode,
        input flag,
        input [1:0] PCSrc,
        input [31:0] imm, addr, Rout1,

        //Outputs
        output reg [31:0] address,
        output reg refresh
    );


    always @(posedge clk or negedge reset) begin

        if (reset == 0) begin        //Reset signal 
            address = -1;
        end 
        else begin
            if ((PCSrc == 2'b00) || (opcode == 6'b000100 && flag == 0) || (opcode == 6'b000101 && flag == 1)) begin
                address = address + 1;    //normal simtuation
                refresh = 0;
            end
            else if ((opcode == 6'b000100 && flag == 1) || (opcode == 6'b000101 && flag == 0)) begin
                address = imm*1 + address - 4;     //branch
                refresh = 1;
            end
            else if (PCSrc == 2'b10) begin
                address = Rout1 / 4;        //jr
                refresh = 1;
            end
            else if (PCSrc == 2'b11) begin
                address = addr;     //jal, j
                refresh = 1;
            end
            else begin
                address = address + 1;
                refresh = 0;
            end
        end

        if (refresh1 == 1) address = address - 1;
    end     

endmodule

