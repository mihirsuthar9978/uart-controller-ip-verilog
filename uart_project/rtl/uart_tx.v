`timescale 1ns/1ps

module uart_tx
#(
    parameter CLKS_PER_BIT = 217
)
(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output reg        tx,
    output reg        tx_busy
);

localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

reg [1:0] state;
reg [7:0] clk_count;
reg [2:0] bit_index;
reg [7:0] data_buf;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        state      <= IDLE;
        tx         <= 1'b1;
        tx_busy    <= 1'b0;
        clk_count  <= 8'd0;
        bit_index  <= 3'd0;
        data_buf   <= 8'd0;
    end
    else
    begin

        case(state)

        //--------------------------------
        IDLE:
        //--------------------------------
        begin
            tx <= 1'b1;
            tx_busy <= 1'b0;

            if(tx_start)
            begin
                data_buf <= tx_data;
                state <= START;
                tx_busy <= 1'b1;
            end
        end

        //--------------------------------
        START:
        //--------------------------------
        begin
            tx <= 1'b0;

            if(clk_count == CLKS_PER_BIT-1)
            begin
                clk_count <= 0;
                state <= DATA;
            end
            else
                clk_count <= clk_count + 1;
        end

        //--------------------------------
        DATA:
        //--------------------------------
        begin
            tx <= data_buf[bit_index];

            if(clk_count == CLKS_PER_BIT-1)
            begin
                clk_count <= 0;

                if(bit_index == 7)
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
            tx <= 1'b1;

            if(clk_count == CLKS_PER_BIT-1)
            begin
                clk_count <= 0;
                tx_busy <= 1'b0;
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
