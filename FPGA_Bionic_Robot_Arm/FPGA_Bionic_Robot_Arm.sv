module FPGA_Bionic_Robot_Arm (
    input  CLOCK_50,
    input KEY0, //This is RESET, resets both FIFO and current gesture
    input KEY1, //This is SEND
    input [7:0] SW,
    output pwm1, pwm2, pwm3, pwm4, pwm5
);

    wire [4:0] pwm;

    assign pwm1 = pwm[0];
    assign pwm2 = pwm[1];
    assign pwm3 = pwm[2];
    assign pwm4 = pwm[3];
    assign pwm5 = pwm[4];

    wire fifo_wr_en;
    wire [7:0] fifo_wr_data;
    wire fifo_rd_en;
    wire [7:0] fifo_rd_data;
    wire fifo_full, fifo_empty;
    wire fifo_almost_full, fifo_almost_empty;

    button_input button_input_inst (
        .clk(CLOCK_50),
        .button(KEY1),
        .sw(SW),
        .fifo_wr_en(fifo_wr_en),
        .fifo_wr_data(fifo_wr_data)
    );

    FIFO #(
        .DATA_WIDTH(8),
        .DEPTH(16)
    ) FIFO_inst (
        .clk(CLOCK_50),
        .reset_n(KEY0),
        .wr_en(fifo_wr_en),
        .wr_data(fifo_wr_data),
        .rd_en(fifo_rd_en),
        .rd_data(fifo_rd_data),
        .full(fifo_full),
        .empty(fifo_empty),
        .almost_full(fifo_almost_full),
        .almost_empty(fifo_almost_empty)
    );

    gesture_decoder gesture_decoder_inst (
        .clk(CLOCK_50),
        .reset(KEY0),
        .fifo_rd_data(fifo_rd_data),
        .fifo_empty(fifo_empty),
        .fifo_rd_en(fifo_rd_en),
        .pwm_out(pwm)
    );

endmodule
