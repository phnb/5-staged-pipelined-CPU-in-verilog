/* Detect the hazard of lw
**
*/

`timescale 100fs/100fs
module HazardDetection
    (   //Inputs
        input [31:0] address,
        input [31:0] instruction, instructionD,

        //Outputs
        output reg refresh1
    );

    always @(*) begin
        if ((instructionD[31:26] == 6'b100011) && ((instructionD[20:16] == instruction[15:11]) || (instructionD[20:16] == instruction[20:16]) || (instructionD[20:16] == instruction[25:21])) && (instruction != instructionD)) begin
            refresh1 = 1;        //Solve lw data hazard and jr hazard
        end 
        else refresh1 = 0;
    end

endmodule