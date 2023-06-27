module keypad(input logic [16:0] sync_keys, 
              output logic octave_key_up, octave_key_down, mode_key, goof_key,  output logic [4:0]keycode,
              output logic strobe);  
assign {octave_key_up, octave_key_down, mode_key, goof_key, keycode, strobe} = 
                          sync_keys[16] == 1? 10'b1000000001: 
                          sync_keys[15] == 1? 10'b0100000001: 
                          sync_keys[14] == 1? 10'b0010000001:  
                          sync_keys[13] == 1? 10'b0001000001:  
                          
                          
                          
                          sync_keys[12] == 1? 10'b0000011001:  
                          sync_keys[11] == 1? 10'b0000010111:  
                          sync_keys[10] == 1? 10'b0000010101:  
                          sync_keys[9]  == 1? 10'b0000010011:  
                          sync_keys[8]  == 1? 10'b0000010001:  
                          sync_keys[7]  == 1? 10'b0000001111:  
                          sync_keys[6]  == 1? 10'b0000001011:  
                          sync_keys[5]  == 1? 10'b0000001011: 
                          sync_keys[4]  == 1? 10'b0000001001:  
                          sync_keys[3]  == 1? 10'b0000000111:   
                          sync_keys[2]  == 1? 10'b0000000101:  
                          sync_keys[1]  == 1? 10'b0000000011:  
                          sync_keys[0]  == 1? 10'b0000000001:  
                                              10'b0000000000;
endmodule