/* For jal and j, pre-excuted the address
**
*/

`timescale 100fs/100fs
module PCAddr
    (   //Inputs
        input clk,
        input [25:0] target,
        input [31:0] address,

        //Outputs
        output reg [31:0] addr
    );

    wire [31:0] num;
    assign num = {{6{target[25]}}, target[25:0]};
    always @(posedge clk) begin
        addr <= num;     //first four bits of current address + target address << 2
    end

endmodule