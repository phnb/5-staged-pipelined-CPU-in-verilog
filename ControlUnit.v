/*The control unit provides control signals for whole process
**   depend on Op code and Funct code
*/

`timescale 100fs/100fs
module ControlUnit
    (   //Inputs
        input [31:0] instruction,
        input [5:0] opcode,
        input [5:0] funct,
        input reset, clk,

        //Output
        output reg RegWrite, MemtoReg, MemRW, ALUSrc, Extnum, WrRegData,
        output reg [3:0] ALUControl,
        output reg [1:0] PCSrc, RegDst
    );

    initial begin
        RegWrite = 0;
        MemtoReg = 0;
        MemRW = 0;
        ALUSrc = 0;
        RegDst = 0;
        Extnum = 0;
        WrRegData = 0;
        ALUControl = 0;
        PCSrc = 0;
    end

    always @(*) begin 
        //Initialize the ALUSrc: "1": addi, addiu, andi, ori, xori, lw, sw
        if (opcode == 6'b001000 || opcode == 6'b001001 || opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110 || opcode == 6'b100011 || opcode == 6'b101011)
            ALUSrc = 1;
        else ALUSrc = 0;

        //Initialize the Extnum: "0": xori 
        if (opcode == 6'b001110 ) Extnum =0;
        else Extnum = 1;

        //Initialize the PCSrc
        case (opcode)
            6'b000010: PCSrc = 2'b11;   //j
            6'b000011: PCSrc = 2'b11;   //jal
            6'b000000: begin
                if (funct == 6'b001000) PCSrc = 2'b10;    //jr
            end
            6'b000100: PCSrc = 2'b01;   //beq
            6'b000101: PCSrc = 2'b01;   //beq
            default: PCSrc = 2'b00;
        endcase 

        //Initialize the ALUControl
        case (opcode)
            6'b000000: begin
                case (funct)
                    6'b100000: ALUControl = 4'b0000;   //add
                    6'b100001: ALUControl = 4'b0000;   //addu
                    6'b100100: ALUControl = 4'b1001;   //and
                    6'b100111: ALUControl = 4'b1010;   //nor
                    6'b100101: ALUControl = 4'b1011;   //or
                    6'b000000: ALUControl = 4'b0101;   //sll
                    6'b000100: ALUControl = 4'b0110;   //sllv
                    6'b000011: ALUControl = 4'b0111;   //sra
                    6'b000111: ALUControl = 4'b1000;   //srav
                    6'b000010: ALUControl = 4'b0011;   //srl
                    6'b000110: ALUControl = 4'b0100;   //srlv
                    6'b100010: ALUControl = 4'b0001;   //sub
                    6'b100011: ALUControl = 4'b0001;   //subu
                    6'b100110: ALUControl = 4'b1100;   //xor
                    6'b101010: ALUControl = 4'b0010;   //slt
                endcase
            end
            6'b001000: ALUControl = 4'b0000;   //addi
            6'b001001: ALUControl = 4'b0000;   //addiu
            6'b001100: ALUControl = 4'b1001;   //andi
            6'b001101: ALUControl = 4'b1011;   //ori
            6'b001110: ALUControl = 4'b1100;   //xori
            6'b000100: ALUControl = 4'b0001;   //beq
            6'b000101: ALUControl = 4'b0001;   //bne
            6'b100011: ALUControl = 4'b1101;   //lw
            6'b101011: ALUControl = 4'b1101;   //sw
        endcase

        //Initialize the MemtoReg: "1" for lw
        if (opcode == 6'b100011) MemtoReg = 1;
        else MemtoReg = 0;

        //Initialize the RegWrite: "0" for sw   "1" for add, addu, addi, addiu, sub, subu, and, andi, nor, or, ori, xor, xori, sll, sllv, srl, srlv, sra, srav, lw, jal
        if (opcode == 6'b101011) RegWrite = 0;
        else RegWrite = 1;

        //Initialize the WrRegData: "0" for jal...
        if (opcode == 6'b000011) WrRegData = 0;
        else WrRegData = 1;

        //Initialize the MemRW: "1" for sw (store data) "0" for lw (read data)
        if (opcode == 6'b101011) MemRW = 1;
        else MemRW = 0;

        //Initialize the RegDst: "00": jal: $ra <- PC+4    "01": choose [20:16]  addi, addiu, andi, ori, xori, lw
        //"10": chooose [15:11]  add, addu, and, nor, or, sll, sllv, sra, srav, srl, srlv, sub, subu, xor, slt
        if (opcode == 6'b000011) RegDst = 2'b00;
        else if (opcode == 6'b001000 || opcode == 6'b001001 || opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110 || opcode == 6'b100011)
            RegDst = 2'b01;
        else RegDst = 2'b10;
    
    end
endmodule