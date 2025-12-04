// NOTE: Only use when you are testing with pwm_test.sv
module FPGA_Bionic_Robot_Arm (
    input  CLOCK_50,
    output pwm1, pwm2, pwm3, pwm4, pwm5
);

    wire [4:0] pwm;

    assign pwm1 = pwm[0];
    assign pwm2 = pwm[1];
    assign pwm3 = pwm[2];
    assign pwm4 = pwm[3];
    assign pwm5 = pwm[4];


endmodule
