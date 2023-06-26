module keypad(input logic [16:0] sync_keys, 
              output logic octave_key_up, octave_key_down, mode_key, output logic [4:0]keycode,
              output logic strobe);  
assign {keycode,strobe} = sync_keys[16] == 1? 6'b100001: 
                          sync_keys[15] == 1? 6'b011111: 
                          sync_keys[14] == 1? 6'b011101:  
                          sync_keys[13] == 1? 6'b011011:  
                          sync_keys[12] == 1? 6'b011001:  
                          sync_keys[11] == 1? 6'b010111:  
                          sync_keys[10] == 1? 6'b010101:  
                          sync_keys[9] == 1? 6'b010011:  
                          sync_keys[8] == 1? 6'b010001:  
                          sync_keys[7] == 1? 6'b001111:  
                          sync_keys[6] == 1? 6'b001011:  
                          sync_keys[5] == 1? 6'b001011: 
                          sync_keys[4] == 1? 6'b001001:  
                          sync_keys[3] == 1? 6'b000111:   
                          sync_keys[2] == 1? 6'b000101:  
                          sync_keys[1] == 1? 6'b000011:  
                          sync_keys[0] == 1? 6'b000001:  
                          6'b000000;
endmodule