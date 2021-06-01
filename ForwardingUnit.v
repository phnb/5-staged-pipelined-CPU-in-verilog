/* Used for solving datahazard
**
*/

`timescale 100fs/100fs
module ForwardingUnit
    (   //Inputs
        input clk,
        input [31:0] instructionE, instructionM, instructionW,     //used for hazard detection conditions
        input [31:0] readData1E, readData2E,       //Fetch data fromregister
        input [31:0] resultM, dataA, dataB,    //used for Multiplexer data
        input MemtoReg, RegWrite1, RegWrite2, RegDstM, RegDstW,

        //Outputs
        output reg [31:0] datain1, datain2    
    );


    wire [31:0] memData;      //Forward data from MEM/WB
    assign memData = MemtoReg ? dataA : dataB;  

    always @(*) begin
        //First input of alu
        if (RegWrite1 && (instructionM[15:11] != 0) && (instructionM[15:11] == instructionE[25:21])) datain1 = resultM;
        else if (RegWrite1 && (instructionW[15:11] != 0) && (instructionW[15:11] == instructionE[25:21])) datain1 = memData; 
        else if ((RegDstM == 2'b01) && (instructionM[20:16] != 0) && (instructionM[20:16] == instructionE[25:21])) datain1 = resultM;  
        else if ((RegDstW == 2'b01) && (instructionW[20:16] != 0) && (instructionW[20:16] == instructionE[25:21])) datain1 = memData; 
        else datain1 = readData1E;

        //Second input of alu
        if (RegWrite1 && (instructionM[15:11] != 0) && (instructionM[15:11] == instructionE[20:16])) datain2 = resultM;
        else if (RegWrite1 && (instructionW[15:11] != 0) && (instructionW[15:11] == instructionE[20:16])) datain2 = memData;
        else if ((RegDstW == 2'b01) && (instructionW[20:16] != 0) && (instructionW[20:16] == instructionE[20:16])) datain2 = memData;   //For solving lw data hazard
        else datain2 = readData2E;
    end

endmodule