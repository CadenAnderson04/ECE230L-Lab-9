`timescale 1ns / 1ps

module d_latch(
    input D, E,
    output reg Q,
    output NotQ
    );
    
    always @(D, E) begin
        if (E) 
            if (D)
                Q <= 1;
            else if (~D)
                Q <= 0;
// ; for E if ?
    end
    
    assign NotQ = ~Q;
endmodule
