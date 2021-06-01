/*
**
*/

`timescale 100fs/100fs
module NumExtend
    (   //Inputs
        input [31:0] instructionE,
        input [15:0] num_in,
        input Extnum,    //"0": no extension    "1": sign number extension

        //Outputs
        output reg [31:0] num_out
    );

    always @(*) begin
        //Don't Need extension: xori 
        num_out = Extnum ? {{16{num_in[15]}}, num_in[15:0]} : {{16{1'b0}}, num_in[15:0]};
    end

endmodule

