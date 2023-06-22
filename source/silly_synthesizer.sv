`default_nettype none
module silly_synthesizer (
    // HW
    input logic clk, nrst,
    
    // Wrapper
    input logic cs, // Chip Select (Active Low)
    inout logic [33:0] gpio // Breakout Board Pins
);

logic pulse;

assign gpio[0] = cs ? 1'bz : pulse;

clock_div4Hz cdiv (clk, nrst, pulse);

endmodule