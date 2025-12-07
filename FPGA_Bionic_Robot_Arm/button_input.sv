module button_input(
    input clk,
    input button, //button is active low for de1-soc
    input [7:0] sw,
    output reg [7:0] gesture
);

    // Double FF for metastability and prev state for falling edge detection
    reg button_sync1, button_sync2, prev_button; 

    always @(posedge clk) begin
        button_sync1 <= button;
        button_sync2 <= button_sync1;
        prev_button <= button_sync2;
        gesture <= (!button_sync2 && prev_button) ? sw : gesture;
    end

endmodule