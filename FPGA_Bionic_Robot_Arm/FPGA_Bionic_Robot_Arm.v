module FPGA_Bionic_Robot_Arm (
    input CLOCK_50,
    output pwm1,
    output pwm2,
    output pwm3,
    output pwm4,
    output pwm5
);

    wire [4:0] pwm;

    pwm_test pwm_inst (
        .clk(CLOCK_50),
        .pwm_out(pwm)
    );

    assign pwm1 = pwm[0];
    assign pwm2 = pwm[1];
    assign pwm3 = pwm[2];
    assign pwm4 = pwm[3];
    assign pwm5 = pwm[4];

endmodule
