module sound_driver (
    input logic clk, nrst,
    input logic [17:0] divider,
    input logic [1:0] mode,
    input logic strobe,
    output logic pwm_output
);

logic [17:0] signal;
logic [7:0] scaled_signal, wave;
logic pulse, pwm_signal;

oscillator sig_gen (divider, clk, nrst, signal);
clock_div39kHz sample_rate (clk, nrst, pulse);
//seq_div
waveshaper shaper (divider, signal, scaled_signal, mode, wave);
pwm output_gen (clk, nrst, strobe, wave, pwm_signal);

always_ff @(posedge clk, negedge nrst) begin
    if (~nrst)
        pwm_output <= 0;
    else
        pwm_output <= pwm_signal;
end

endmodule