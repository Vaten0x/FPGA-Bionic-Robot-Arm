module button_input(
    input clk,
    input button, //button is active low for de1-soc
    input [7:0] sw,
    output reg fifo_wr_en,
    output reg [7:0] fifo_wr_data
);

    // Double FF for metastability and third FF for edge detection
    reg button_sync_0, button_sync_1, button_prev;

    always @(posedge clk) begin
        button_sync_0 <= button;
        button_sync_1 <= button_sync_0;
        button_prev <= button_sync_1;

        if (button_prev && !button_sync_1) begin
            fifo_wr_en <= 1'b1; // no need to check if fifo is full since it will be ignored on its own within FIFO
            fifo_wr_data <= sw;
        end else begin
            fifo_wr_en <= 1'b0;
            fifo_wr_data <= fifo_wr_data; // hold data (doesn't matter, wr_en is low)
        end
    end

endmodule