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

    logic block_reset, block_reset_int, gated_reset;
    assign gated_reset = ~ncs & nrst;

    // Reset Synchronizer
    always_ff @ (posedge clk, negedge gated_reset) begin : RESET_SYNCHRONIZER
        block_reset_int <= 1'b1;
        block_reset <= block_reset_int;
    end

  logic out;
  assign gpio_out[33] = gpio_oeb[33] ? 1'b0 : out;

  silly_synthesizer synth (clk, nrst /* TODO: Replace with synced and gated reset */, ncs, gpio_in[16:0], out);

endmodule
