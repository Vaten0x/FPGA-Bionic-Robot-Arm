module gesture_decoder (
    input clk,
    input [7:0] gesture,
    output reg [4:0] pwm_out
);

    wire [7:0] width_thumb, width_index, width_middle, width_ring, width_pinky;
    
    // instantiate 5 servo PWM generators
    servo_pwm pwm_instance_1 (.clk(clk), .width_us(width_thumb), .pwm(pwm_out[0]));
    servo_pwm pwm_instance_2 (.clk(clk), .width_us(width_index), .pwm(pwm_out[1]));
    servo_pwm pwm_instance_3 (.clk(clk), .width_us(width_middle), .pwm(pwm_out[2]));
    servo_pwm pwm_instance_4 (.clk(clk), .width_us(width_ring), .pwm(pwm_out[3]));
    servo_pwm pwm_instance_5 (.clk(clk), .width_us(width_pinky), .pwm(pwm_out[4]));

    always @(posedge clk) begin
        case(gesture)
            8'b00000001: begin // Fist
                assign width_thumb = 8'd1000;
                assign width_index = 8'd1000;
                assign width_middle = 8'd1000;
                assign width_ring = 8'd1000;
                assign width_pinky = 8'd1000;
            end
            8'b00000010: begin // Open Hand
                assign width_thumb = 8'd2000;
                assign width_index = 8'd2000;
                assign width_middle = 8'd2000;
                assign width_ring = 8'd2000;
                assign width_pinky = 8'd2000;
            end
            8'b00000100: begin // Pointing
                assign width_thumb = 8'd1500;
                assign width_index = 8'd2000;
                assign width_middle = 8'd1000;
                assign width_ring = 8'd1000;
                assign width_pinky = 8'd1000;
            end
            default: begin // Neutral
                assign width_thumb = 8'd1500;
                assign width_index = 8'd1500;
                assign width_middle = 8'd1500;
                assign width_ring = 8'd1500;
                assign width_pinky = 8'd1500;
            end
        endcase
    end
    
endmodule;