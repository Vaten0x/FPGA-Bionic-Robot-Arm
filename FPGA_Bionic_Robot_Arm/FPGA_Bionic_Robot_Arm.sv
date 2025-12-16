module FPGA_Bionic_Robot_Arm (
    input  CLOCK_50,
    input KEY0,
    input KEY1,
    input [7:0] SW,
    output pwm1, pwm2, pwm3, pwm4, pwm5
);

    wire [4:0] pwm;

    assign pwm1 = pwm[0];
    assign pwm2 = pwm[1];
    assign pwm3 = pwm[2];
    assign pwm4 = pwm[3];
    assign pwm5 = pwm[4];

    wire [7:0] gesture_input;

    button_input button_input_inst (
        .clk(CLOCK_50),
        .button(KEY1),
        .sw(SW),
        .gesture(gesture_input)
    );

    gesture_decoder gesture_decoder_inst (
        .clk(CLOCK_50),
        .reset(KEY0),
        .gesture(gesture_input),
        .pwm_out(pwm)
    );

endmodule
