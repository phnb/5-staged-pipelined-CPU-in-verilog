/* Pipeline register between EX stage and MEM stage
**
*/

`timescale 100fs/100fs
module PipeReg_IDEX
    (   //Inputs
        input clk, 
        input [31:0] j_addrD,
        input refresh, WrRegDataD, MemtoRegD, MemRWD, RegWriteD, ExtnumD,
        input [1:0] RegDstD,
        input [5:0] opcodeD,
        input [1:0] PCSrcD,
        input [31:0] instructionD,
        input [31:0] readData1D, readData2D,
        input ALUSrcD,
        input [3:0] ALUControlD,

        //Outputs
        output reg [31:0] j_addrE,
        output reg WrRegDataE, MemtoRegE, MemRWE, RegWriteE, ExtnumE, 
        output reg [1:0] RegDstE,
        output reg [5:0] opcodeE,
        output reg [1:0] PCSrcE,
        output reg [31:0] instructionE,
        output reg [31:0] readData1E, readData2E,
        output reg ALUSrcE,
        output reg [3:0] ALUControlE
    );

    always @(posedge clk) begin
        if (refresh == 0) begin
            j_addrE <= j_addrD;
            WrRegDataE <= WrRegDataD;
            MemtoRegE <= MemtoRegD;
            MemRWE <= MemRWD;
            RegWriteE <= RegWriteD;
            ExtnumE <= ExtnumD;
            RegDstE <= RegDstD;
            opcodeE <= opcodeD;
            PCSrcE <= PCSrcD;
            instructionE <= instructionD;
            readData1E <= readData1D;
            readData2E <= readData2D;
            ALUSrcE <= ALUSrcD;
            ALUControlE <= ALUControlD;
        end 
        else begin
            j_addrE <= 0;
            WrRegDataE <= 0;
            MemtoRegE <= 0;
            MemRWE <= 0;
            RegWriteE <= 0;
            ExtnumE <= 0;
            RegDstE <= 0;
            opcodeE <= 0;
            PCSrcE <= 0;
            instructionE <= 0;
            readData1E <= 0;
            readData2E <= 0;
            ALUSrcE <= 0;
            ALUControlE <= 0;
        end 
    end    

endmodule