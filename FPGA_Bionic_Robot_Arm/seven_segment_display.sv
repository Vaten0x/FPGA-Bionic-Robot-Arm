// Displays 4 digit seven segment displays for a given 16-bit input value
// Expects 16-bit input decimal value to be less than 9999, if over it will be truncated down to 9999.
// This file is mainly used for pwm_test.sv to display the current pulse width only
module seven_segment_display #(
    parameter max_value = 4'd9999
)(
    input wire clk,
    input wire tick,
    input wire [15:0] width_input,
    output wire [3:0][6:0] seven_seg_display
);
    // truncate anything over for 16-bit decimal value for 9999
    wire [15:0] clamped_input = (width_input > max_value) ? 4'd9999 : width_input;

    wire [3:0] digit3 = clamped_input / 1000;
    wire [3:0] digit2 = (clamped_input / 100) % 10;
    wire [3:0] digit1 = (clamped_input / 10) % 10;
    wire [3:0] digit0 = clamped_input % 10;

    function [6:0] bcd_to_7seg(input [3:0] bcd);
        case (bcd)
            4'd0: bcd_to_7seg = 7'b1000000; // 0
            4'd1: bcd_to_7seg = 7'b1111001; // 1
            4'd2: bcd_to_7seg = 7'b0100100; // 2
            4'd3: bcd_to_7seg = 7'b0110000; // 3
            4'd4: bcd_to_7seg = 7'b0011001; // 4
            4'd5: bcd_to_7seg = 7'b0010010; // 5
            4'd6: bcd_to_7seg = 7'b0000010; // 6
            4'd7: bcd_to_7seg = 7'b1111000; // 7
            4'd8: bcd_to_7seg = 7'b0000000; // 8
            4'd9: bcd_to_7seg = 7'b0010000; // 9
            default: bcd_to_7seg = 7'b1111111; // to avoid latch
        endcase
    endfunction

    always @(posedge clk) begin
        if (tick) begin
            seven_seg_display[3] = bcd_to_7seg(digit3);
            seven_seg_display[2] = bcd_to_7seg(digit2);
            seven_seg_display[1] = bcd_to_7seg(digit1);
            seven_seg_display[0] = bcd_to_7seg(digit0);
        end
    end
endmodule