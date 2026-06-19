`timescale 1ns/1ps

module uart_controller_tb;

localparam CLKS_PER_BIT = 217;

reg clk;
reg rst_n;

reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

wire [7:0] rx_data;
wire rx_ready;

uart_controller #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
)
dut
(
    .clk(clk),
    .rst_n(rst_n),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .rx(tx),      // LOOPBACK

    .tx(tx),

    .rx_data(rx_data),
    .rx_ready(rx_ready),

    .tx_busy(tx_busy)
);

always #20 clk <= ~clk;

initial
begin

    clk = 0;
    rst_n = 0;

    tx_start = 0;
    tx_data  = 0;

    #100;

    rst_n = 1;

    #500;

    // Send 3C
    tx_data  = 8'h3C;
    tx_start = 1;

    #40;
    tx_start = 0;

    wait(tx_busy == 0);

    #50000;

    $finish;

end

always @(posedge clk)
begin
    if(rx_ready)
    begin
        $display("--------------------------------");
        $display("RX DATA = %h", rx_data);
        $display("--------------------------------");

        if(rx_data == 8'h3C)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");
    end
end

initial
begin
    $dumpfile("uart_controller.vcd");
    $dumpvars(0, uart_controller_tb);
end

endmodule
