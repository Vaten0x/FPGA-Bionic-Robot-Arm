// Generates 5 PWM signals for hobby servos (50 Hz, 1000us to 2000us pulse width)
module pwm_test (
    input  wire       clk,       // 50 MHz clock
    output wire [4:0] pwm_out
);
    // slow tick for width updates (~200 Hz)
    reg [23:0] slow = 0;
    always @(posedge clk) slow <= slow + 1;
    wire tick = (slow == 24'd0);

    // sweep width between 1000us and 2000us
    reg dir = 1'b1;
    reg [15:0] width_us = 16'd1500;

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
    servo_pwm u0 (.clk(clk), .width_us(width_us), .pwm(pwm_out[0]));
    servo_pwm u1 (.clk(clk), .width_us(width_us), .pwm(pwm_out[1]));
    servo_pwm u2 (.clk(clk), .width_us(width_us), .pwm(pwm_out[2]));
    servo_pwm u3 (.clk(clk), .width_us(width_us), .pwm(pwm_out[3]));
    servo_pwm u4 (.clk(clk), .width_us(width_us), .pwm(pwm_out[4]));

endmodule
