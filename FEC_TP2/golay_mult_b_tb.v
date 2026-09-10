module golay_mult_b_tb;
    reg [11:0] i_vec;
    wire [11:0] o_vec;

    golay_mult_b mult_inst (
        .i_vec(i_vec),
        .o_vec(o_vec)
    );

    initial begin
        
        i_vec = 12'hA5C; // Entrada de prueba
        #10; 
       
        $display("\ni_vec=%b  \ni_vec=%h", i_vec, i_vec); 
        $display("\no_vec=%b  \no_vec=%h\n", o_vec, o_vec);
        $finish; 
    end
endmodule