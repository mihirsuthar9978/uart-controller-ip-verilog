`timescale 1ns/1ps

module baud_generator_tb;

reg clk;
reg rst_n;

wire baud_tick;

baud_generator uut
(
    .clk(clk),
    .rst_n(rst_n),
    .baud_tick(baud_tick)
);

// 25 MHz Clock
always #20 clk <= ~clk;

initial
begin
    clk   = 0;
    rst_n = 0;

    #100;

    rst_n = 1;

    #20000;

    $finish;
end

always @(posedge clk)
begin
    if(baud_tick)
        $display("Time=%0t ns | Baud Tick Generated", $time);
end

initial
begin
    $dumpfile("baud_generator.vcd");
    $dumpvars(0, baud_generator_tb);
end

endmodule
