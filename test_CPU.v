`timescale 1ns/1ps

module test_cpu;
    reg [10:0] i;
    reg CLOCK = 1'b0;
    reg reset = 1'b0;
    reg [31:0] Cycles = 0;
    reg [31:0] instruction = 0;
    CPU cpu(CLOCK, reset);


    always begin
        if (cpu.pipereg2.instruction !== 32'hffffffff)begin
            reset <= 1;
            #100
            CLOCK <= ~CLOCK;
            #100
            CLOCK <= ~CLOCK;
            Cycles = Cycles + 1;
        end
        else begin
            #100
            CLOCK = ~CLOCK;
            #100
            CLOCK = ~CLOCK;
            Cycles = Cycles + 1;
            #100
            CLOCK = ~CLOCK;
            #100
            CLOCK = ~CLOCK;
            Cycles = Cycles + 1;
            #100
            CLOCK = ~CLOCK;
            #100
            CLOCK = ~CLOCK;
            Cycles = Cycles + 1;

            for (i=0; i<512; i = i+1) begin
                $display("%b", cpu.mainmemory.DATA_RAM[i]);
            end
            $finish;
        end
    end
endmodule