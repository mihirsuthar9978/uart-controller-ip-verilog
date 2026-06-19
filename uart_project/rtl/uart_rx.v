`timescale 1ns/1ps

module uart_rx
#(
    parameter CLKS_PER_BIT = 217
)
(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       serial_in,

    output reg [7:0] data_out,
    output reg       data_ready
);

localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam RECV  = 2'd2;
localparam STOP  = 2'd3;

reg [1:0] state;

reg [7:0] clk_count;
reg [2:0] bit_index;
reg [7:0] data_buf;

// Synchronizer
reg rx_meta;
reg rx_sync;

always @(posedge clk)
begin
    rx_meta <= serial_in;
    rx_sync <= rx_meta;
end

always @(posedge clk)
begin
    if(!rst_n)
    begin
        state      <= IDLE;
        clk_count  <= 0;
        bit_index  <= 0;
        data_buf   <= 0;
        data_out   <= 0;
        data_ready <= 0;
    end
    else
    begin

        data_ready <= 1'b0;

        case(state)

        //--------------------------------
        IDLE:
        //--------------------------------
        begin
            clk_count <= 0;
            bit_index <= 0;

            if(rx_sync == 1'b0)
                state <= START;
        end

        //--------------------------------
        START:
        //--------------------------------
        begin
            if(clk_count == (CLKS_PER_BIT/2))
            begin
                clk_count <= 0;

                if(rx_sync == 1'b0)
                    state <= RECV;
                else
                    state <= IDLE;
            end
            else
                clk_count <= clk_count + 1;
        end

        //--------------------------------
        RECV:
        //--------------------------------
        begin
            if(clk_count == CLKS_PER_BIT-1)
            begin
                clk_count <= 0;

                data_buf[bit_index] <= rx_sync;

                if(bit_index == 3'd7)
                begin
                    bit_index <= 0;
                    state <= STOP;
                end
                else
                    bit_index <= bit_index + 1;
            end
            else
                clk_count <= clk_count + 1;
        end

        //--------------------------------
        STOP:
        //--------------------------------
        begin
            if(clk_count == CLKS_PER_BIT-1)
            begin
                clk_count <= 0;

                if(rx_sync == 1'b1)
                begin
                    data_out <= data_buf;
                    data_ready <= 1'b1;
                end

                state <= IDLE;
            end
            else
                clk_count <= clk_count + 1;
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule
