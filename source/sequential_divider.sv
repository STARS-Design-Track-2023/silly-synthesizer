module sequential_divider(input logic clk, nrst, sample_now,
                            input logic [17:0] divisor, input logic [17:0] oscillator_out,
                            output logic [7:0] q_out,
                            output logic done);
logic [4:0] count, next_count;
logic start, next_start, div, next_div;
logic [26:0] a_part1, q, next_q, q_part1, a, next_a, next_m, m;
//logic [17:0] store_count, store_divisor;

always_comb begin
    if(sample_now) begin
        next_a = 0;
        next_m = {1'b0, 8'b0, divisor};
        next_q = {1'b0, oscillator_out, 8'b0};
        next_count = 0;
        a_part1 = 0;
        q_part1 = 0;
        done = 0;

        next_start = 1;
        next_div = 0;

        q_out = 0;
    end
    else if(count < (27) & (start)) begin
        {a_part1, q_part1} = {a, q} << 1;
        next_m = m;

        if(a_part1[26] == 1'b1) begin
            next_a = a_part1 + m;
        end
        else begin
            next_a = a_part1 - m;
        end

        if(next_a[26] == 1'b1) begin
            next_q = q_part1;
        end
        else begin
            next_q = q_part1 + 1;
        end

        next_count = count + 1;
        done = 0;

        next_start = 1;
        next_div = 1;

        q_out = 0;
    end
    else if(div) begin
        done = 1;
        next_q = q;
        q_part1 = 0;
        next_m = m;
        next_a = a;
        a_part1 = 0;
        next_count = count;

        next_start = 0;
        next_div = 0;

        q_out = q[7:0];
    end
    else begin
        done = 0;
        next_q = q;
        q_part1 = 0;
        next_m = m;
        next_a = a;
        a_part1 = 0;
        next_count = count;

        next_start = 0;
        next_div = 0;

        q_out = q[7:0];
    end
end

always_ff @(posedge clk, negedge nrst) begin
    if(!nrst) begin
        count <= 0;
        q <= 0;
        m <= 0;
        a <= 0;

        start <= 0;
        div <= 0;
    end else begin
        count <= next_count;
        q <= next_q;
        m <= next_m;
        a <= next_a;

        start <= next_start;
        div <= next_div;
    end
end
endmodule

/*
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
    if(clk_div) begin
        case(mode)
        off: next_mode = div;
        div: next_mode = done;
        done: next_mode = div;
        default: next_mode = off; 
        endcase
    end
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
    next_count = count + 1;
    next_buffer = 1'b0;
    if(count == 5'b10010) begin
        next_count = 5'b0;
        next_buffer = 1'b1;
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
        next_Q = (shaped_sig << 1) + {7'b0, ({5'b0, remainder[24:12]} >= in_divide)};
        next_remainder = ({5'b0, remainder[24:12]} >= in_divide) ? ((remainder << 1) - {8'b0, (in_divide << 8)}) : (remainder << 1);
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
*/