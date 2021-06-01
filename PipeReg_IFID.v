/* Pipeline register between ID stage and EX stage
**
*/

`timescale 100fs/100fs
module PipeReg_IFID
    (   //Inputs
        input clk, 
        input [31:0] j_addr,
        input refresh1, refresh,
        input [5:0] opcode,
        input [31:0] instruction,
        input [31:0] addressF,

        //Outputs
        output reg [31:0] j_addrD,
        output reg [5:0] opcodeD,
        output reg [31:0] instructionD,
        output reg [31:0] addressD
        
    );

    always @(posedge clk) begin
        if ((refresh == 0) && (refresh1 == 0)) begin
            j_addrD <= j_addr;
            opcodeD <= opcode;
            instructionD <= instruction;
            addressD <= addressF;
        end
        else if ((refresh == 0) && (refresh1 == 1)) begin
            j_addrD <= 0;
            opcodeD <= 0;
            instructionD <= 0;
            addressD <= 0;
        end
        else begin
            j_addrD <= 0;
            opcodeD <= 0;
            instructionD <= 0;
            addressD <= 0;
        end
    end

endmodule