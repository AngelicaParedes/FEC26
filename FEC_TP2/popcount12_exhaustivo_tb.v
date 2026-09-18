module popcount12_exhaustivo_tb;
    reg [11:0] i_vec;
    wire [3:0] o_weight;
    integer i, j, esperado, errores;

    popcount12 popcount_inst ( .i_vec(i_vec), .o_weight(o_weight) );

    initial begin
        errores = 0;
        for (i = 0; i < 4096; i = i + 1) begin
            i_vec = i[11:0];
            #1;
            esperado = 0;
            for (j = 0; j < 12; j = j + 1)
                esperado = esperado + i_vec[j];
            if (o_weight !== esperado[3:0]) begin
                errores = errores + 1;
                $display("\nERROR en i_vec=%h: o_weight=%d esperado=%d\n", i_vec, o_weight, esperado);
            end
        end
        if (errores == 0)
            $display("\nOK: popcount12 verificado para las 4096 combinaciones\n");
        else
            $display("\nFALLA: %0d errores\n", errores);
        $finish;
    end
endmodule