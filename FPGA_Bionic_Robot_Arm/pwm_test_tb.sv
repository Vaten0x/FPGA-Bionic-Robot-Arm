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
        //$fsdbDumpon;

        #100;
        assert(pwm_instance.width_us == 16'd1510) else $error("Initial width_us wrong");
        assert(pwm_instance.direction == 1'b1) else $error("Initial direction wrong");
        $display("Test 1 finished");

        @(posedge pwm_instance.tick);
        #100;
        assert(pwm_instance.width_us == 16'd1520) else $error("Width_us didn't go up by 10");
        assert(pwm_instance.direction == 1'b1) else $error("Direction changed when it shouldn't");
        $display("Test 2 finished");

        repeat(5) begin
            automatic int expected_width = pwm_instance.width_us + 10;
            @(posedge pwm_instance.tick);
            @(posedge clk);
            #100;

            $display("Width check: expected=%0d, actual=%0d", expected_width, pwm_instance.width_us);

            assert(pwm_instance.width_us == expected_width) else $error("Width_us didn't increase correctly");
            assert(pwm_instance.direction == 1'b1) else $error("Direction changed when it shouldn't");
        end
        $display("Test 3 finished");

        // pwm_instance.width_us should now be 1560 here

        while (pwm_instance.width_us < 2000) begin
            @(posedge pwm_instance.tick);
        end

        #100;

        assert(pwm_instance.width_us == 2000) else $error("Width_us didn't reach 2000us");
        assert(pwm_instance.direction == 1'b0) else $error("Direction didn't change to down at 2000us");

        $display("Test 4 finished");

        //$fsdbDumpoff;
        $finish;
    end

    property pwm_width_range;
        @(posedge clk) (pwm_instance.width_us >= 16'd1000 && pwm_instance.width_us <= 16'd2000);
    endproperty

    assert property (pwm_width_range) else $error("width_us out of range");

endmodule