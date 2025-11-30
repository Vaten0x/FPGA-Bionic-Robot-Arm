module pwm_test_tb();

    reg clk;
    wire [3:0][6:0] seven_seg_display;
    wire [4:0] pwm_out;

    pwm_test pwm_instance (clk, seven_seg_display, pwm_out);

    initial begin 
        clk = 0; 
        forever #10 clk = ~clk; // 50 MHz clock same as in pwm_test
    end

    initial begin
        $fsdbDumpon;
        $fsdbDumpvars(0, pwm_test_tb);

        #1000000;
        $fsdbDumpoff;
        $finish;
    end

endmodule