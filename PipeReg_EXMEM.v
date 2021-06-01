/* Pipeline register between EX stage and MEM stage
**
*/

`timescale 100fs/100fs
module PipeReg_EXMEM
    (   //Inputs
        input clk, 
        input [31:0] j_addrE,
        input refresh,
        input [31:0] extendDataE, instructionE,
        input WrRegDataE, MemtoRegE, RegWriteE, 
        input [1:0] RegDstE,
        input [5:0] opcodeE,
        input flagE,
        input [1:0] PCSrcE,
        input [31:0] resultE,
        input MemRWE,
        input [31:0] readData1E, readData2E,

        //Outputs
        output reg [31:0] j_addrM,
        output reg [31:0] extendDataM,instructionM,
        output reg WrRegDataM, MemtoRegM, RegWriteM, 
        output reg [1:0] RegDstM,
        output reg [5:0] opcodeM,
        output reg flagM,
        output reg [1:0] PCSrcM,
        output reg [31:0] resultM,
        output reg MemRWM,
        output reg [31:0] readData1M, readData2M
    );

    always @(posedge clk) begin
        if (refresh == 0) begin
            j_addrM <= j_addrE;
            extendDataM <= extendDataE;
            instructionM <= instructionE;
            WrRegDataM <= WrRegDataE;
            MemtoRegM <= MemtoRegE;
            RegWriteM <= RegWriteE;
            RegDstM <= RegDstE;
            opcodeM <= opcodeE;
            flagM <= flagE;
            PCSrcM <= PCSrcE;
            resultM <= resultE;
            MemRWM <= MemRWE;
            readData1M <= readData1E;
            readData2M <= readData2E;
        end
        else begin
            j_addrM <= 0;
            extendDataM <= 0;
            instructionM <= 0;
            WrRegDataM <= 0;
            MemtoRegM <= 0;
            RegWriteM <= 0;
            RegDstM <= 0;
            opcodeM <= 0;
            flagM <= 0;
            PCSrcM <= 0;
            resultM <= 0;
            MemRWM <= 0;
            readData1M <= 0;
            readData2M <= 0;
        end
    end

endmodule
