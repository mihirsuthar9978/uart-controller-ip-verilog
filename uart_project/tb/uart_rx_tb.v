`timescale 1ns/1ps

module uart_rx_tb;

localparam CLKS_PER_BIT = 217;

reg clk;
reg rst_n;
reg serial_in;

wire [7:0] data_out;
wire data_ready;

uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
)
dut
(
    .clk(clk),
    .rst_n(rst_n),
    .serial_in(serial_in),
    .data_out(data_out),
    .data_ready(data_ready)
);

// 25 MHz clock
always #20 clk <= ~clk;

task send_byte;
input [7:0] data;
integer i;
begin

    // Start Bit
    serial_in = 0;
    #(CLKS_PER_BIT*40);

    // Data Bits (LSB First)
    for(i=0;i<8;i=i+1)
    begin
        serial_in = data[i];
        #(CLKS_PER_BIT*40);
    end

    // Stop Bit
    serial_in = 1;
    #(CLKS_PER_BIT*40);

end
endtask

initial
begin

    clk = 0;
    rst_n = 0;
    serial_in = 1;

    #100;

    rst_n = 1;

    #500;

    send_byte(8'h3C);

    #50000;

    $finish;

end

always @(posedge clk)
begin
    if(data_ready)
    begin
        $display("--------------------------------");
        $display("Received Data = %h", data_out);
        $display("--------------------------------");
    end
end

initial
begin
    $dumpfile("uart_rx.vcd");
    $dumpvars(0, uart_rx_tb);
end

endmodule
