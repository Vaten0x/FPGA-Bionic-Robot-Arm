module gesture_decoder (
    input clk,
    input reset, //reset button is active low for DE1-SOC

    // FIFO Interface
    input [7:0] fifo_rd_data,
    input fifo_empty,
    output reg fifo_rd_en,

    output reg [4:0] pwm_out
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        READ = 2'b01,
        EXECUTE = 2'b10,
        WAIT = 2'b11
    } state_t;

    state_t state, next_state;

    // Gesture latch (captured from FIFO)
    reg [7:0] gesture_code;
    
    // Wait timer: 500ms at 50MHz = 25,000,000 cycles
    localparam WAIT_CYCLES = 25_000_000;
    reg [24:0] wait_counter;

    reg [15:0] width_thumb = 16'd1500;
    reg [15:0] width_index = 16'd1500;
    reg [15:0] width_middle = 16'd1500;
    reg [15:0] width_ring = 16'd1500;
    reg [15:0] width_pinky = 16'd1500;

    // instantiate 5 servo PWM generators
    servo_pwm pwm_instance_1 (.clk(clk), .width_us(width_thumb), .pwm(pwm_out[0]));
    servo_pwm pwm_instance_2 (.clk(clk), .width_us(width_index), .pwm(pwm_out[1]));
    servo_pwm pwm_instance_3 (.clk(clk), .width_us(width_middle), .pwm(pwm_out[2]));
    servo_pwm pwm_instance_4 (.clk(clk), .width_us(width_ring), .pwm(pwm_out[3]));
    servo_pwm pwm_instance_5 (.clk(clk), .width_us(width_pinky), .pwm(pwm_out[4]));

    // State, next_state
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition
    always @(*) begin
        next_state = state;
        case (state)
            IDLE    : if (!fifo_empty) next_state = READ;
            READ    : next_state = EXECUTE;
            EXECUTE : next_state = WAIT;
            WAIT    : if (wait_counter == WAIT_CYCLES - 1) next_state = IDLE;
        endcase
    end

    // FIFO read enable - only pulse for 1 cycle in READ state
    always @(posedge clk or negedge reset) begin
        if (!reset)
            fifo_rd_en <= 1'b0;
        else
            fifo_rd_en <= (state == IDLE && !fifo_empty); // Assert when transitioning to READ
    end

    // Capture gesture code from FIFO
    always @(posedge clk or negedge reset) begin
        if (!reset)
            gesture_code <= 8'b0;
        else if (state == READ)
            gesture_code <= fifo_rd_data;
    end

    // Wait counter
    always @(posedge clk or negedge reset) begin
        if (!reset)
            wait_counter <= 0;
        else if (state == WAIT)
            wait_counter <= wait_counter + 1;
        else
            wait_counter <= 0;
    end

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            width_thumb <= 16'd1500;
            width_index <= 16'd1500;
            width_middle <= 16'd1500;
            width_ring <= 16'd1500;
            width_pinky <= 16'd1500;
        end else if (gesture_code != 8'b00000000) begin
            case(gesture_code)
                8'b00000001: begin // Rock
                    width_thumb <= 16'd1900;
                    width_index <= 16'd2000;
                    width_middle <= 16'd1800;
                    width_ring <= 16'd2000;
                    width_pinky <= 16'd2000;
                end
                8'b00000010: begin // Paper
                    width_thumb <= 16'd1000;
                    width_index <= 16'd1100;
                    width_middle <= 16'd1000;
                    width_ring <= 16'd1000;
                    width_pinky <= 16'd1300;
                end 
                8'b00000011: begin // Scissors
                    width_thumb <= 16'd1900;
                    width_index <= 16'd1100;
                    width_middle <= 16'd1000;
                    width_ring <= 16'd2000;
                    width_pinky <= 16'd2000;
                end
                8'b00000100: begin // Thumb only
                    width_thumb <= 16'd1900;
                    width_index <= 16'd1100;
                    width_middle <= 16'd1000;
                    width_ring <= 16'd1000;
                    width_pinky <= 16'd1300;
                end
                8'b00000101: begin // Index only
                    width_thumb <= 16'd1000;
                    width_index <= 16'd2000;
                    width_middle <= 16'd1000;
                    width_ring <= 16'd1000;
                    width_pinky <= 16'd1300;
                end
                8'b00000110: begin // Middle only
                    width_thumb <= 16'd1000;
                    width_index <= 16'd1100;
                    width_middle <= 16'd1800;
                    width_ring <= 16'd1000;
                    width_pinky <= 16'd1300;
                end
                8'b00000111: begin // Ring only
                    width_thumb <= 16'd1000;
                    width_index <= 16'd1100;
                    width_middle <= 16'd1000;
                    width_ring <= 16'd2000;
                    width_pinky <= 16'd1300;
                end
                8'b00001000: begin // Pinky only
                    width_thumb <= 16'd1000;
                    width_index <= 16'd1100;
                    width_middle <= 16'd1000;
                    width_ring <= 16'd1000;
                    width_pinky <= 16'd2000;
                end
                8'b00001001: begin // Pinky Promise Sign
                    width_thumb <= 16'd1000;
                    width_index <= 16'd2000;
                    width_middle <= 16'd1800;
                    width_ring <= 16'd2000;
                    width_pinky <= 16'd1300;
                end
                8'b00001010: begin // Rock Sign
                    width_thumb <= 16'd1000;
                    width_index <= 16'd1100;
                    width_middle <= 16'd1800;
                    width_ring <= 16'd2000;
                    width_pinky <= 16'd1300;
                end
                default: begin // Default case
                    width_thumb <= width_thumb;
                    width_index <= width_index;
                    width_middle <= width_middle;
                    width_ring <= width_ring;
                    width_pinky <= width_pinky;
                end
            endcase
        end else begin //maintain current widths if gesture_code is 0
                width_thumb <= width_thumb;
                width_index <= width_index;
                width_middle <= width_middle;
                width_ring <= width_ring;
                width_pinky <= width_pinky;
        end
    end
    
endmodule