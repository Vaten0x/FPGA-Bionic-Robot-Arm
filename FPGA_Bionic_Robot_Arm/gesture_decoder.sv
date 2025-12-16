module gesture_decoder (
    input clk,
    input reset, //reset button is active low for DE1-SOC
    input [7:0] gesture,
    output reg [4:0] pwm_out
);

    reg [15:0] width_thumb = 16'd1500;
    reg [15:0] width_index = 16'd1500;
    reg [15:0] width_middle = 16'd1500;
    reg [15:0] width_ring = 16'd1500;
    reg [15:0] width_pinky = 16'd1500;

    // instantiate 5 servo PWM generators
    servo_pwm pwm_instance_1 (.clk(clk), .width_us(width_thumb), .pwm(pwm_out[0]));
    servo_pwm pwm_instance_2 (.clk(clk), .width_us(width_index), .pwm(pwm_out[1]));
    servo_pwm pwm_instance_3 (.clk(clk), .width_us(width_middle), .pwm(pwm_out[2]));
    servo_pwm pwm_instance_4 (.clk(clk), .width_us(width_ring), .pwm(pwm_out[3]));
    servo_pwm pwm_instance_5 (.clk(clk), .width_us(width_pinky), .pwm(pwm_out[4]));

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            width_thumb <= 16'd1500;
            width_index <= 16'd1500;
            width_middle <= 16'd1500;
            width_ring <= 16'd1500;
            width_pinky <= 16'd1500;
        end else begin
            case(gesture)
                8'b00000001: begin // Unknown Gesture
                    width_thumb <= 16'd1600;
                    width_index <= 16'd1600;
                    width_middle <= 16'd1600;
                    width_ring <= 16'd1600;
                    width_pinky <= 16'd1600;
                end
                8'b00000010: begin // Unknown Gesture
                    width_thumb <= 16'd1400;
                    width_index <= 16'd1400;
                    width_middle <= 16'd1400;
                    width_ring <= 16'd1400;
                    width_pinky <= 16'd1400;
                end
                default: begin // Default case
                    width_thumb <= width_thumb;
                    width_index <= width_index;
                    width_middle <= width_middle;
                    width_ring <= width_ring;
                    width_pinky <= width_pinky;
                end
            endcase
        end
    end
    
endmodule