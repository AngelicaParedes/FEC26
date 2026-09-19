//Calcula el sindrome de la palabra de codigo recibida (24 bits)

module golay_syndrome_tb;
    reg [23:0] i_rx; //Palabra recibida
    wire [11:0] o_syn; //Sindrome resultante

    golay_syndrome syn_inst (
        .i_rx(i_rx),
        .o_syn(o_syn)
    );

    initial begin
        i_rx = 24'hA5D9A6;   // r1 del Ejercicio 3
        #10;
        $display("===========r1 del Ejercicio 3====================\n");
        $display("i_rx=%h  \nsindrome=%h \nbinario: %b \n", i_rx, o_syn, o_syn);
        #10;
        i_rx = 24'hA5F9A4;   // r2 del Ejercicio 3
        #10;
        $display("===========r2 del Ejercicio 3====================\n");
        $display("i_rx=%h  \nsindrome=%h \nbinario: %b \n", i_rx, o_syn, o_syn);
        #10;
        i_rx = 24'hA5C9AA;   // r3 del Ejercicio 3
        #10;            
        $display("===========r3 del Ejercicio 3====================\n");
        $display("i_rx=%h  \nsindrome=%h \nbinario: %b \n", i_rx, o_syn, o_syn);
        $finish;
    end
endmodule