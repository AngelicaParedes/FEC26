module popcount12_tb;
    reg [11:0] i_vec; //entrada que yo controlo en el testbench - VECTOR
    wire [3:0] o_weight; // salida: 4 pines que representan el peso de Hamming del vector de entrada

    popcount12 poprcount_inst (
        .i_vec(i_vec),
        .o_weight(o_weight)
    );

    initial begin
        i_vec = 12'b100111001111; // Entrada de prueba

        #10; // Esperar 10 unidades de tiempo para que se propague la señal y_weight

        //Resultado
        $display("\ni_vec=%b  \no_weight=%d\n", i_vec, o_weight);
        $finish; //Terminar la simulacion
    end
endmodule