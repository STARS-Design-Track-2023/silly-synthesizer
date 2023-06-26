module sequential_divider(input logic clk, nrst, clk_div,
                            input logic [17:0] divisor, input logic [17:0] oscillator_out,
                            output logic [7:0] q_out);
//
logic [25:0] remainder;
logic [17:0] in_divide;
logic [17:0] next_divide;
logic [4:0] count;
logic [4:0] next_count;

//these variables control the enable for the divider
logic in_buffer;
logic next_buffer;

//these variables exist to perform the sequential division operation next state logic
logic comp;
logic [7:0] next_Q;
logic [25:0] next_remainder;
logic [7:0] shaped_sig;

logic [7:0] next_out;

//FSM to control division and numerical output 
typedef enum logic [1:0] {off, div, done} div_mode;
div_mode mode;
div_mode next_mode;

always_ff @ (posedge clk, negedge nrst) begin
    if(~nrst)
        mode <= off;
    else
        mode <= next_mode;
end

always_comb begin
    next_mode = mode;
    if(in_buffer) begin
        case(mode)
        off: next_mode = div;
        div: next_mode = done;
        done: next_mode = div;
        default: next_mode = off; 
        endcase
    end
    else
        next_mode = mode;
end

//Controlling the primary inputs to the divider so that they are updated only when the previous division is complete
always_ff @ (posedge clk, negedge nrst) begin
    if(~nrst) begin
        in_buffer <= 1'b0;
        count <= 5'b0;
    end
    else begin
        in_buffer <= next_buffer;
        count <= next_count;
    end
end

always_comb begin
    next_count = count;
    next_buffer = 1'b0;
    if(count == 5'b10010) begin
        next_count = 5'b0;
        next_buffer = 1'b1;
    end
    else begin
        next_count = count + 1;
        next_buffer = 1'b0;
    end
end

//Every 18 clock cycles, remainder becomes oscillator_out and in_divide becomes divisor.
always_ff @ (posedge clk, negedge nrst) begin
    if(~nrst) begin
        shaped_sig <= 8'b0;
        remainder <= 26'b0;
        in_divide <= 18'b0;
    end
    else begin
        shaped_sig <= next_Q;
        remainder <= next_remainder;
        in_divide <= next_divide;
    end
end

always_comb begin
    comp = 1'b0;
    next_Q = shaped_sig;
    next_remainder = remainder;
    next_divide = in_divide;
    if(in_buffer) begin
        next_remainder = {oscillator_out,8'b0};
        next_divide = divisor;
        next_Q = 8'b0;
    end
    else if(mode == div) begin
        comp = ({10'b0, (remainder[24:17])} >= in_divide);
        next_Q = (shaped_sig << 1) + {7'b0, comp};
        next_remainder = comp ? ((remainder << 1) - {8'b0, (in_divide << 8)}) : (remainder << 1);
        next_divide = in_divide;
    end
    else begin
        comp = 1'b0;
        next_Q = shaped_sig;
        next_remainder = remainder;
        next_divide = in_divide;
    end
end

//After the division is complete, output signal is gated by the "done" state of the FSM, so that only completed operations are outputted.
always_ff @ (posedge clk, negedge nrst) begin
    if(~nrst) begin
        q_out <= 8'b0;
    end
    else begin
        q_out <= next_out;
    end
end
always_comb begin
    if(mode == done) begin
        next_out = shaped_sig;
    end
    else begin
        next_out = q_out;
    end
end

endmodule