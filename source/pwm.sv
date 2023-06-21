module pwm(
    input logic clk, nrst, 
    input logic [7:0] sample, 
    output logic pwm_unff);
    
    logic [7:0] count, next_count;

    always_comb begin
        next_count = count;
        if (count < 255)
            next_count = count + 1;
        if (count == 255)
            next_count = 0;
    end

    always_ff @ (posedge clk, negedge nrst) begin
        if (~nrst)
            count <= 0;
        else 
            count <= next_count;
    end

    always_comb begin
        if (count < sample)
            pwm_unff = 1;
        else 
            pwm_unff = 0;
    end
endmodule