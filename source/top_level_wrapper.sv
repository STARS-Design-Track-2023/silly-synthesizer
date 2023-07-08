`default_nettype none
module top_level_wrapper (
    // HW
    input logic clk, nrst,
    
    // Wrapper
    input logic ncs, // Chip Select (Active Low)
    input logic [33:0] gpio_in, // Breakout Board Pins
    output logic [33:0] gpio_out, // Breakout Board Pins
    output logic [33:0] gpio_oeb // Active Low Output Enable
);

    // Reset Synchronizer
    logic ff1, ff2;
    assign gated_reset = ~ncs & nrst;

    always_ff @(posedge clk, negedge gated_reset) begin
        if(~gated_reset) begin
            ff1 <= 1'b0; 
            ff2 <= 1'b0; 
        end
        else begin
            ff1 <= 1'b1; 
            ff2 <= ff1; 
        end

    end

    assign gpio_oeb = {1'b0, {33{1'b1}}};

    silly_synthesizer synth (clk, ff2, ncs, gpio_in[16:0], gpio_out[33]);

    assign gpio_out[32:0] = {33{1'b0}};

endmodule
