/* ALU gets the data from registers and control signals as inputs 
**   Then output the outcome and zero flag
*/

`timescale 100fs/100fs
module ALU
    (   //Inputs
        input [31:0] readData1, readData2, extendData,  //[25:21]      [20:16]      Immediate number after sign extend
        input [4:0] readData3,      //[10:6]
        input clk, ALUSrc,     //Select the ReadData2 or extendData
        input [3:0] ALUControl,

        //Outputs
        output reg signed[31:0] result,
        output reg flag
    );

    initial begin
        result = 0;
    end

    wire [31:0] datain;
    assign datain = ALUSrc ? extendData : readData2;


    always @(negedge clk) begin
        case (ALUControl)
            //"+": add, addi, addu, addiu, lw, sw,
            4'b0000: result = readData1 + datain;  

            //"-": sub, subu, beq, bne
            4'b0001: begin
                result = readData1 - datain;
                flag = (result == 0) ? 1 : 0;     //zero flag
            end

            //compare: slt
            4'b0010: result = readData1 < datain ? 1 : 0;

            //logic shift right: srl
            4'b0011: result = readData2 >> readData3; 

            //logic shift right: srlv
            4'b0100: result = readData2 >> readData1[4:0];       //pick low-order five bits. 

            //logic shift left: sll
            4'b0101: result = readData2 << readData3; 

            //logic shift left: sllv
            4'b0110: result = readData2 << readData1[4:0];     //pick low-order five bits. 

            //arithmetic shift right: sra
            4'b0111: result = ($signed(readData2)) >>> readData3; 

            //arithmetic shift right shamet: srav
            4'b1000: result = ($signed(readData2)) >>> readData1[4:0];  //pick low-order five bits. 

            //and, andi
            4'b1001: result = readData1 & datain;

            //nor
            4'b1010: result = readData1 ~| datain;  

            //or, ori
            4'b1011: result = readData1 | datain; 

            //xor, xori
            4'b1100: result = readData1 ^ datain;

            //"+": lw, sw,
            4'b1101: result = readData1 + datain / 4;   

            default: result = 32'hffffffff;
        endcase

    end

endmodule
