/*  By connecting the various modules to achieve the purpose of running the CPU
**
*/

`timescale 100fs/100fs
module CPU
    (   //Inputs
        input clk, reset
    );

    //Data path: 
    wire [31:0] instruction, instructionD, instructionE, instructionM, instructionW;
    wire [31:0] readData1D, readData1E, readData1M, readData1W, readData2D, readData2E, readData2M;
    wire [31:0] resultE, resultM, resultW;     //result of alu excution
    wire [31:0] j_addr, j_addrD, j_addrE, j_addrM;      //jump address of jal, j
    wire [31:0] extendDataE, extendDataM, extendDataW;     //data after extension
    wire [31:0] memDataW;
    wire [31:0] datain1, datain2;     //Data into alu
    wire [31:0] dataOutM, dataOutW;
    wire flagE, flagM;
    wire enable;
    wire opcodeD, opcodeE, opcodeM, opcodeW;
    wire [31:0] address, addressF, addressD;
    wire [15:0] imme;
    wire refresh, refresh1;
    assign enable = 1;

    //Control signals
    wire RegWriteD, RegWriteE, RegWriteM, RegWriteW;
    wire MemtoRegD, MemtoRegE, MemtoRegM, MemtoRegW; 
    wire MemRWD, MemRWE, MemRWM;
    wire ALUSrcD, ALUSrcE;
    wire ExtnumD, ExtnumE; 
    wire WrRegDataD, WrRegDataE,  WrRegDataM,  WrRegDataW;
    wire [3:0] ALUControlD, ALUControlE;
    wire [1:0] PCSrcD, PCSrcE, PCSrcM, PCSrcW;
    wire [1:0] RegDstD, RegDstE, RegDstM, RegDstW;



    PC pc(clk, reset, refresh1, instructionW[31:26], flagM, PCSrcW, extendDataW, j_addrM, readData1W, address, refresh);

    //First clk: IF
    InstructionRAM instructionram(clk, reset, enable, address, instruction);

    HazardDetection hazarddetection(address, instruction, instructionD, refresh1);

    PCAddr pcaddr(clk, instruction[25:0], address, j_addr);

    //Second clk: ID
    PipeReg_IFID pipereg2(clk, j_addr, refresh1, refresh, instruction[31:26], instruction, address,
        j_addrD, opcodeD, instructionD, addressD);

    ControlUnit controlunit(instructionD, instructionD[31:26], instructionD[5:0], reset, clk, RegWriteD, MemtoRegD, MemRWD, ALUSrcD, ExtnumD, WrRegDataD, ALUControlD, PCSrcD, RegDstD);

    RegFile regfile(dataOutM, resultW, MemtoRegW, instructionD[25:21], instructionD[20:16], instructionW[20:16], instructionW[15:11], clk, RegWriteW, WrRegDataW, RegDstW, addressD, readData1D, readData2D);

    //Third clk: EX
    PipeReg_IDEX pipereg3(clk, j_addrD, refresh, WrRegDataD, MemtoRegD, MemRWD, RegWriteD, ExtnumD, RegDstD, opcodeD, PCSrcD, instructionD, readData1D, readData2D, ALUSrcD, ALUControlD,
        j_addrE, WrRegDataE, MemtoRegE, MemRWE, RegWriteE, ExtnumE, RegDstE, opcodeE, PCSrcE, instructionE, readData1E, readData2E, ALUSrcE, ALUControlE);

    NumExtend numextend(instructionE, instructionE[15:0], ExtnumE, extendDataE);

    ForwardingUnit forwardingunit(clk, instructionE, instructionM, instructionW, readData1E, readData2E, resultM, dataOutM, resultW, MemtoRegW, RegWriteW, RegWriteM, RegDstM, RegDstW, datain1, datain2);

    ALU alu(datain1, datain2, extendDataE, instructionE[10:6], clk, ALUSrcE, ALUControlE, resultE, flagE);

    //Fourth clk: MEM
    PipeReg_EXMEM pipereg4(clk, j_addrE, refresh, extendDataE, instructionE, WrRegDataE, MemtoRegE, RegWriteE, RegDstE, opcodeE, flagE, PCSrcE, resultE, MemRWE, datain1, datain2,
        j_addrM, extendDataM, instructionM, WrRegDataM, MemtoRegM, RegWriteM, RegDstM, opcodeM, flagM, PCSrcM, resultM, MemRWM, readData1M, readData2M);

    MainMemory mainmemory(clk, reset, enable, resultM , {{MemRWM}, resultM[31:0], readData2M[31:0]}, dataOutM);

    //Fifth clk: WB
    PipeReg_MEMWB pipereg5(clk, refresh, extendDataM, instructionM, WrRegDataM, opcodeM, MemtoRegM, RegWriteM, PCSrcM, RegDstM, resultM, dataOutM, readData1M,
        extendDataW, instructionW, WrRegDataW, opcodeW, MemtoRegW, RegWriteW, PCSrcW, RegDstW, resultW, dataOutW, readData1W);


endmodule
