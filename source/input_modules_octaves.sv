module octaves(input logic clk, n_rst,octave_key_up,octave_key_down, output logic octave); 
typedef enum logic [2:0] {s1, s2, s3, s4, s5} 
state_t; 
state_t state;
state_t next_state; 
always_ff @(posedge clk, negedge n_rst) begin 
if(n_rst==0) begin 
state<=s1; 
end 
else begin
state<=next_state; 
end 
end 
always_comb 
begin 
next_state=state;
 case(state) 
 s1:begin 
  if(octave_key_up==1 & octave_key_down==0)
   next_state = s2; 
  else if (octave_key_up==0 & octave_key_down==1)
   next_state = s1;
end
 s2:begin
  if(octave_key_up==1 & octave_key_down==0)
   next_state = s3;
  else if (octave_key_up==0 & octave_key_down==1)
   next_state = s1;
 end
 s3:begin
  if(octave_key_up==1 & octave_key_down==0)
   next_state = s4;
else if (octave_key_up==0 & octave_key_down==1)
   next_state = s2;
 end 
 s4:begin
  if(octave_key_up==1 & octave_key_down==0)
   next_state = s5;
  else if (octave_key_up==0 & octave_key_down==1)
   next_state = s3;
 end
 s5:begin
  if(octave_key_up==1 & octave_key_down==0)
   next_state = s5;
 else if (octave_key_up==0 & octave_key_down==1)
   next_state = s4;
 end
 default:next_state = s3;
 endcase
end
endmodule
