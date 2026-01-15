module FIFO #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input clk,
    input reset_n, //active-low button
    input wr_en,
    input [DATA_WIDTH-1:0] wr_data,
    input rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic full,
    output logic empty,
    output logic almost_full,
    output logic almost_empty
);

    // With DEPTH 16, ADDR_WIDTH is 4
    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic [ADDR_WIDTH-1:0] wr_ptr;
    logic [ADDR_WIDTH-1:0] rd_ptr;
    logic [ADDR_WIDTH:0] counter; // Extra bit for representing 16 when it's full
    logic [DATA_WIDTH-1:0] memory [DEPTH-1:0];

    assign full = (counter == DEPTH);
    assign empty = (counter == 0);
    assign almost_full = (counter >= DEPTH - 2);
    assign almost_empty = (counter <= 2);

    always @(posedge clk) begin
        if (!reset_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            counter <= 0;
        end else if (wr_en && rd_en && !full && !empty) begin
            // Simultaneous read and write logic
            memory[wr_ptr] <= wr_data;
            wr_ptr <= (wr_ptr == 5'd15) ? 5'd0 : wr_ptr + 1'b1;
            rd_data <= memory[rd_ptr];
            rd_ptr <= (rd_ptr == 5'd15) ? 5'd0 : rd_ptr + 1'b1;
            counter <= counter;
        end else if (wr_en && !full) begin
            memory[wr_ptr] <= wr_data;
            wr_ptr <= (wr_ptr == 5'd15) ? 5'd0 : wr_ptr + 1'b1;
            counter <= counter + 1'b1;
        end else if (rd_en && !empty) begin
            rd_data <= memory[rd_ptr];
            rd_ptr <= (rd_ptr == 5'd15) ? 5'd0 : rd_ptr + 1'b1;
            counter <= counter - 1'b1;
        end else begin
            wr_ptr <= wr_ptr;
            rd_ptr <= rd_ptr;
            counter <= counter;
            memory <= memory;
        end
    end

endmodule