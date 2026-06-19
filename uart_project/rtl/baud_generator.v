`timescale 1ns/1ps


module baud_generator
#(
    parameter CLKS_PER_BIT = 217
)
(
    input wire clk,
    input wire rst_n,

    output reg baud_tick
);

reg [7:0] counter;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        counter   <= 8'd0;
        baud_tick <= 1'b0;
    end

    else
    begin
        if(counter == CLKS_PER_BIT-1)
        begin
            counter   <= 8'd0;
            baud_tick <= 1'b1;
        end

        else
        begin
            counter   <= counter + 1'b1;
            baud_tick <= 1'b0;
        end
    end
end

endmodule
