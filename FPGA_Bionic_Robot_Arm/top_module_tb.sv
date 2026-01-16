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
        forever #10 clk = ~clk; // 50MHz
    end

    initial begin
        // Initialize at time 0
        SW = 8'b00000000;
        KEY0 = 1'b1;
        KEY1 = 1'b1;
        
        // Reset sequence
        #100;
        KEY0 = 1'b0;  // Reset on
        #100;
        KEY0 = 1'b1;  // Reset off
        #100;

        // Queue gesture 1 (Rock)
        SW = 8'b00000001;
        #100;
        KEY1 = 1'b0;  // Button press
        #100;
        KEY1 = 1'b1;  // Button release
        #1000;

        // Queue gesture 2 (Paper) - rapid press
        SW = 8'b00000010;
        #100;
        KEY1 = 1'b0;
        #100;
        KEY1 = 1'b1;
        #1000;

        // Queue gesture 3 (Scissors) - rapid press
        SW = 8'b00000011;
        #100;
        KEY1 = 1'b0;
        #100;
        KEY1 = 1'b1;
        
        // Wait for all gestures to execute (3 × 500ms = 1.5s = 75M cycles)
        // For simulation, let's use shorter wait time
        #100_000_000;  // 1 second

        $finish;
    end
    
    initial begin
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, top_module_tb);
    end
    
endmodule