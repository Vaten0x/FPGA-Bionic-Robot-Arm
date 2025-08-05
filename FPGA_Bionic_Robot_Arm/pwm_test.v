//Purpose for testing moving arm with FPGA
module pwm_test (
    input clk,
    output reg [4:0] pwm_out
);

    reg [19:0] counter = 0;

    // 20ms = 1,000,000 cycles at 50MHz
    // 1.5ms = 75,000 cycles
    parameter PWM_PERIOD = 1000000;
    parameter HIGH_TIME = 75000;

    always @(posedge clk) begin
        counter <= (counter == PWM_PERIOD) ? 0 : counter + 1;

        // Set all outputs high for HIGH_TIME, low otherwise
        if (counter < HIGH_TIME) begin
            pwm_out <= 5'b11111;
        end else begin
            pwm_out <= 5'b00000;
        end
    end
endmodule

