module rng( 
    input logic clk, nrst,
    output reg [15:0] out, [5:0] note  
);
    logic feedback;
    assign feedback= ~(out[10]^(out[12]^(out[13]^out[15])));
    logic feedback_2; 
    assign feedback_2 = ~(note[3]^(note[4]^note[5]));

    always_ff @ (posedge clk, negedge nrst) begin  
        if (~nrst)
            out <= 16'b1010010001010101;
        else
            out <= {out[14:0],feedback}; 
    end  
    always_ff @ (posedge clk, negedge nrst) begin 
        if (out[15] == 1)
            note <= ~{note[4:0],feedback_2};
        else  if (~nrst)
            note <= 6'b101100; 
            else 
            note <= {note[4:0],feedback_2};
    end
endmodule 

