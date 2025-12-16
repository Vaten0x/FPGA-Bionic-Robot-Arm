module button_input(
    input clk,
    input button, //button is active low for de1-soc
    input [7:0] sw,
    output reg [7:0] gesture
);

    // Double FF for metastability and third FF for edge detection
    reg button_sync_0, button_sync_1, button_prev;

    always @(posedge clk) begin
        button_sync_0 <= button;
        button_sync_1 <= button_sync_0;
        button_prev <= button_sync_1;

        if (button_prev && !button_sync_1) begin
            gesture <= sw;
        end else begin
            gesture <= 8'b00000000;
        end
    end

endmodule