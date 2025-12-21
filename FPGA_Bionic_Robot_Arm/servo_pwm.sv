// Expects the input to be for HK-15298 Servo and clocked at 50MHz = 0.02us per tick
// Pulse signal should be every 50Hz = 20ms = 20,000us
// Minimum Pulse Width must be 1,000 us (0 degrees)
// Maximum Pulse Width must be 2,000 us (180 degrees)

module servo_pwm #(
    parameter CLK_HZ   = 50_000_000, // 50MHz clock
    parameter PULSE_SIGNAL_US = 20_000,
    parameter MIN_PULSE_WIDTH_US = 1_000,
    parameter MAX_PULSE_WIDTH_US = 2_000
)(
    input  wire        clk,
    input  wire [15:0] width_us, // e.g. 1500 for 90 degrees
    output reg         pwm = 1'b0
);
    localparam integer TICKS_PER_US = CLK_HZ / 1_000_000; // 50 ticks per us
    localparam integer FRAME_TICKS  = PULSE_SIGNAL_US * TICKS_PER_US; // 1,000,000 ticks for 20ms frame

    reg [31:0] counter = 0;

    wire [15:0] w_us = (width_us < MIN_PULSE_WIDTH_US) ? MIN_PULSE_WIDTH_US :
                       (width_us > MAX_PULSE_WIDTH_US) ? MAX_PULSE_WIDTH_US : width_us; // Truncate to valid range

    wire [31:0] high_ticks = w_us * TICKS_PER_US;

    // We want to create a PWM signal that is high for 'width_us' microseconds and repeat every 20ms using a counter here
    always @(posedge clk) begin
        
        if (counter == FRAME_TICKS - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        pwm <= (counter < high_ticks);
    end
endmodule
