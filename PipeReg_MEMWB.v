/* Pipeline register between MEM stage and WB stage
**
*/

`timescale 100fs/100fs
module PipeReg_MEMWB
    (   //Inputs
        input clk, refresh,
        input [31:0] extendDataM, instructionM,
        input WrRegDataM,
        input [5:0] opcodeM, 
        input MemtoRegM, RegWriteM,
        input [1:0] PCSrcM, RegDstM,
        input [31:0] resultM, dataOutM, readData1M, 

        //Outputs
        output reg [31:0] extendDataW, instructionW,
        output reg WrRegDataW,
        output reg [5:0] opcodeW, 
        output reg MemtoRegW, RegWriteW,
        output reg [1:0] PCSrcW, RegDstW,
        output reg [31:0] resultW, dataOutW, readData1W
    );

    always @(posedge clk) begin
        if (refresh == 0) begin
            readData1W <= readData1M;
            extendDataW <= extendDataM;
            instructionW <= instructionM;
            WrRegDataW <= WrRegDataM;
            opcodeW <= opcodeM;
            MemtoRegW <= MemtoRegM;
            RegWriteW <= RegWriteM;
            PCSrcW <= PCSrcM;
            RegDstW <= RegDstM;
            resultW <= resultM;
            dataOutW <= dataOutM;
        end
        else begin
            readData1W <= 0;
            extendDataW <= 0;
            instructionW <= 0;
            WrRegDataW <= 0;
            opcodeW <= 0;
            MemtoRegW <= 0;
            RegWriteW <= 0;
            PCSrcW <= 0;
            RegDstW <= 0;
            resultW <= 0;
            dataOutW <= 0;
        end
    end
endmodule