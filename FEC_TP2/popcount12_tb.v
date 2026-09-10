module popcount12_tb;
    reg [11:0] i_vec; //Entrada: 12 pines que representan el vector de bits de entrada
    wire [3:0] o_weight; // Salida: 4 pines que representan el peso de Hamming del vector de entrada

    popcount12 poprcount_inst (
        .i_vec(i_vec),
        .o_weight(o_weight)
    );

    initial begin
        i_vec = 12'b100111001111; // Entrada de prueba

        #10;

        $display("\ni_vec=%b  \no_weight=%d (peso) \n", i_vec, o_weight);
        $finish;
    end
endmodule