module top_module_tb();

    reg clk;
    reg KEY0, KEY1;
    reg [7:0] SW;
    wire pwm1, pwm2, pwm3, pwm4, pwm5;

    FPGA_Bionic_Robot_Arm dut (
        .CLOCK_50(clk),
        .KEY0(KEY0),
        .KEY1(KEY1),
        .SW(SW),
        .pwm1(pwm1),
        .pwm2(pwm2),
        .pwm3(pwm3),
        .pwm4(pwm4),
        .pwm5(pwm5)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; //50MHz clk
    end

    initial begin
        #100;
        KEY0 = 1'b1;
        KEY1 = 1'b0;
        #100;
        KEY0 = 1'b0;
        #100;
    end

endmodule