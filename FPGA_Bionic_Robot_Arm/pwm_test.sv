// Generates 5 PWM signals for hobby servos (50 Hz, 1000us to 2000us pulse width) in a slow clock
module pwm_test (
    input  wire       clk,       // 50 MHz clock
    output wire [3:0][6:0] seven_seg_display,
    output wire [4:0] pwm_out
);
    // slow tick for width updates (~200 Hz)
    reg [23:0] slow = 0;
    always @(posedge clk) slow <= slow + 1;
    wire tick = (slow == 24'd0);

    // sweep width between 1000us and 2000us
    reg dir = 1'b1;
    reg [15:0] width_us = 16'd1500;

    seven_segment_display seven_seg_instance (
        .clk(clk),
        .tick(tick),
        .width_input(width_us),
        .seven_seg_display(seven_seg_display)
    );

    always @(posedge clk) if (tick) begin
        if (dir) begin
            if (width_us >= 16'd2000) begin
                dir <= 1'b0;
            end else begin
                width_us <= width_us + 10;
            end
        end else begin
            if (width_us <= 16'd1000) begin
                dir <= 1'b1;
            end else begin
                width_us <= width_us - 10;
            end
        end
    end

    // instantiate 5 servo PWM generators
    servo_pwm pwm_instance_1 (.clk(clk), .width_us(width_us), .pwm(pwm_out[0]));
    servo_pwm pwm_instance_2 (.clk(clk), .width_us(width_us), .pwm(pwm_out[1]));
    servo_pwm pwm_instance_3 (.clk(clk), .width_us(width_us), .pwm(pwm_out[2]));
    servo_pwm pwm_instance_4 (.clk(clk), .width_us(width_us), .pwm(pwm_out[3]));
    servo_pwm pwm_instance_5 (.clk(clk), .width_us(width_us), .pwm(pwm_out[4]));

endmodule
