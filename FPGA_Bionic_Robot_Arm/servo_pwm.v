module servo_pwm #(
    parameter CLK_HZ   = 50_000_000,
    parameter FRAME_US = 20_000,
    parameter MIN_US   = 1_000,
    parameter MAX_US   = 2_000
)(
    input  wire        clk,
    input  wire [15:0] width_us,
    output reg         pwm = 1'b0
);
    localparam integer TICKS_PER_US = CLK_HZ / 1_000_000;
    localparam integer FRAME_TICKS  = FRAME_US * TICKS_PER_US;

    reg [31:0] ctr = 0;
    reg [31:0] high_ticks;

    wire [15:0] w_us = (width_us < MIN_US) ? MIN_US :
                       (width_us > MAX_US) ? MAX_US : width_us;

    always @(posedge clk) begin
        high_ticks <= w_us * TICKS_PER_US;
        ctr <= (ctr == FRAME_TICKS-1) ? 0 : ctr + 1;
        pwm <= (ctr < high_ticks);
    end
endmodule
