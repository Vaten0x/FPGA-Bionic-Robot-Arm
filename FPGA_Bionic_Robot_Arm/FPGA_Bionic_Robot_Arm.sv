// NOTE: Only use when you are testing with pwm_test.sv
module FPGA_Bionic_Robot_Arm (
    input  CLOCK_50,
    output [6:0] seven_seg_1, seven_seg_2, seven_seg_3, seven_seg_4,
    output pwm1, pwm2, pwm3, pwm4, pwm5,
);
    wire [4:0] pwm;
    wire [3:0][6:0] seven_segment_display;

    pwm_test pwm_inst (
        .clk(CLOCK_50),
        .seven_seg_display(seven_segment_display),
        .pwm_out(pwm)
    );

    assign pwm1 = pwm[0];
    assign pwm2 = pwm[1];
    assign pwm3 = pwm[2];
    assign pwm4 = pwm[3];
    assign pwm5 = pwm[4];

    assign seven_seg_1 = seven_segment_display[0];
    assign seven_seg_2 = seven_segment_display[1];
    assign seven_seg_3 = seven_segment_display[2];
    assign seven_seg_4 = seven_segment_display[3];

endmodule
