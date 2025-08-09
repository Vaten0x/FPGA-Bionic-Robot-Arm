module pwm_test (
    input clk,
    output reg [4:0] pwm_out,
    output blink_led        // <-- Connect this in Pin Planner to an onboard LED
);

    reg [19:0] counter = 0;
    reg [19:0] high_time = 50000;  // Start at 1ms
    reg direction = 0;             // 0: increasing, 1: decreasing

    parameter PWM_PERIOD = 1000000;  // 20ms @ 50MHz

    // Simple blink counter for debugging
    reg [24:0] blink_counter = 0;
    assign blink_led = blink_counter[24];  // Toggles ~every 0.67s

    always @(posedge clk) begin
        blink_counter <= blink_counter + 1;

        counter <= (counter == PWM_PERIOD) ? 0 : counter + 1;

        // Generate PWM
        if (counter < high_time)
            pwm_out <= 5'b11111;
        else
            pwm_out <= 5'b00000;

        // Update high_time every 20ms (at counter reset)
        if (counter == PWM_PERIOD) begin
            if (!direction)
                high_time <= high_time + 1000; // step +1000 cycles = +20us
            else
                high_time <= high_time - 1000;

            // Reverse direction at bounds
            if (high_time >= 100000)
                direction <= 1;
            else if (high_time <= 50000)
                direction <= 0;
        end
    end
endmodule
