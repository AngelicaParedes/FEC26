module golay_mult_b_tb;
    reg [11:0] i_vec;
    wire [11:0] o_vec;

    golay_mult_b dut (
        .i_vec(i_vec),
        .o_vec(o_vec)
    );

    initial begin
        
        i_vec = 12'hA5C; // Entrada de prueba
        #10; // Esperar 10 unidades de tiempo para que se propague la señal o_vec
       
        $display("\ni_vec=%h  \no_vec=%h", i_vec, o_vec); //Hexadecimal
        $display("\ni_vec=%b  \no_vec=%b\n", i_vec, o_vec); //Binario
        $finish; // Terminar la simulación
    end
endmodule