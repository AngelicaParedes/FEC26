// Testbench: conecta interleaver + deinterleaver en cadena, manda bits
// aleatorios, y verifica que la salida reconstruye la entrada con un
// retardo fijo de (LAMBDA-1)*J*LAMBDA ciclos.
module conv_interleaver_tb;
    parameter LAMBDA = 24;
    parameter J = 1;

    reg i_clk, i_rst, i_bit;
    wire mid_bit, o_bit;

    conv_interleaver #(.LAMBDA(LAMBDA), .J(J)) inter_dut (
        .i_clk(i_clk), .i_rst(i_rst), .i_bit(i_bit), .o_bit(mid_bit)
    );
    conv_deinterleaver #(.LAMBDA(LAMBDA), .J(J)) deinter_dut (
        .i_clk(i_clk), .i_rst(i_rst), .i_bit(mid_bit), .o_bit(o_bit)
    );

    always #5 i_clk = ~i_clk;

    integer LATENCIA, N, i, errores;
    reg entrada [0:2047];
    reg salida  [0:2047];

    initial begin
        i_clk = 0; 
        i_rst = 1; 
        i_bit = 0;

        LATENCIA = (LAMBDA-1)*J*LAMBDA;   
        N = LATENCIA + 400;

        #12;
        i_rst = 0;

        // Genera bits aleatorios y guarda entrada/salida para comparar despues
        for (i = 0; i < N; i = i + 1) begin
            i_bit = $random;
            entrada[i] = i_bit;
            @(posedge i_clk);
            #1;
            salida[i] = o_bit;

            // Muestra los primeros 600 ciclos para ver que pasa
            if(i<600) begin
            $display ("Ciclo %0d: i_bit=%b | o_bit=%b", i, i_bit,o_bit);

        end
        end

        errores = 0;
        // La salida en el instante i debe ser igual a la entrada del instante i
        for (i = LATENCIA; i < N; i = i + 1) begin
            if (salida[i] !== entrada[i-LATENCIA+1]) begin
                
                errores = errores + 1;
                $display("\nERROR en i=%0d: Esperaba entrada[%0d]=%b, pero obtuve salida[%0d]=%b\n", 
                         i, i - LATENCIA, entrada[i - LATENCIA], i, salida[i]);
            end
        end

        if (errores == 0)
                $display("\nOK: reconstruye la entrada con latencia fija de %0d ciclos\n", LATENCIA);
        else
            $display("\nFALLA: %0d errores\n", errores);

        $finish;
    end
endmodule