`timescale 1ns/1ps

module uart_tx_tb;

localparam CLKS_PER_BIT = 217;

reg clk;
reg rst_n;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

uart_tx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
)
dut
(
    .clk(clk),
    .rst_n(rst_n),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

// 25 MHz clock
always #20 clk <= ~clk;

initial
begin
    clk      = 0;
    rst_n    = 0;
    tx_start = 0;
    tx_data  = 8'h00;

    #100;

    rst_n = 1;

    #100;

    // Send 0x3C
    tx_data  = 8'h3C;
    tx_start = 1;

    #40;
    tx_start = 0;

    wait(tx_busy == 0);

    #5000;

    $finish;
end

initial
begin
    $dumpfile("uart_tx.vcd");
    $dumpvars(0, uart_tx_tb);
end

always @(posedge clk)
begin
    if(tx_busy)
        $display("Time=%0t TX=%b", $time, tx);
end

endmodule
