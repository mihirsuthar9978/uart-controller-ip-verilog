`timescale 1ns/1ps

module uart_controller
#(
    parameter CLKS_PER_BIT = 217
)
(
    input wire clk,
    input wire rst_n,

    // TX Interface
    input wire tx_start,
    input wire [7:0] tx_data,

    // RX Serial Input
    input wire rx,

    // UART Pins
    output wire tx,

    // RX Output
    output wire [7:0] rx_data,
    output wire rx_ready,

    // TX Status
    output wire tx_busy
);

uart_tx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
)
u_tx
(
    .clk(clk),
    .rst_n(rst_n),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
)
u_rx
(
    .clk(clk),
    .rst_n(rst_n),
    .serial_in(rx),
    .data_out(rx_data),
    .data_ready(rx_ready)
);

endmodule
