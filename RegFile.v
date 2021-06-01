/* Store data into registers and read data from registers
**
*/

`timescale 100fs/100fs
module RegFile
    (   //Inputs
        input [31:0] dataA, dataB,
        input MemtoReg,
        input [4:0] rs, rt, rtW, rdW,
        input clk, RegWrite, WrRegData,
        input [1:0] RegDst,
        input [31:0] address,  

        //Outputs
        output wire [31:0] readData1, readData2
    );

    reg [31:0] i_data;    //final data written back to register
    reg [31:0] memData;   //memory data writtrn back to register
    reg [4:0] tempReg;
    reg [31:0] register [0:31];

    integer i;
    initial begin
        for (i = 0; i < 32; i++) 
            register [i] = 0; 
    end

    always @(posedge clk) begin
        case (RegDst)
            2'b00: tempReg = 5'b11111;   //$ra
            2'b01: tempReg = rtW;
            2'b10: tempReg = rdW;
            default: tempReg = 0;
        endcase
        memData = MemtoReg ? dataA : dataB;       //choose between lw data and r-type data
        i_data = WrRegData ? memData : ((address - 3) * 4);    //choose between jal
        //In case the 0 register will not change
        if ((tempReg != 0) && (RegWrite == 1)) register[tempReg] = i_data;
     
    end

    assign readData1 = register[rs];
    assign readData2 = register[rt];

endmodule