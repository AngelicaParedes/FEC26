module golay_decoder_exhaustivo_tb;
    reg i_clk, i_rst;
    reg [23:0] i_rx;
    wire [11:0] o_msg;
    wire [23:0] o_err;
    wire o_corrected, o_uncorrectable;

    golay_decoder deco_inst (
        .i_clk(i_clk), .i_rst(i_rst), .i_rx(i_rx),
        .o_msg(o_msg), .o_err(o_err),
        .o_corrected(o_corrected), .o_uncorrectable(o_uncorrectable)
    );

    always #5 i_clk = ~i_clk;

    integer a, b, c, d, errores;
    reg [23:0] err;

    task probar;
        input [23:0] patron;
        input integer peso;
        begin
            i_rx = patron;
            @(posedge i_clk);
            @(posedge i_clk);
            @(posedge i_clk);
            #1;
            if (peso <= 3) begin
                if (o_msg !== 12'b0 || o_err !== patron || o_corrected !== 1'b1 || o_uncorrectable !== 1'b0) begin
                    errores = errores + 1;
                    $display("\nERROR peso=%0d err=%h msg=%h uncorr=%b\n", peso, patron, o_msg, o_uncorrectable);
                end
            end else begin
                if (o_uncorrectable !== 1'b1) begin
                    errores = errores + 1;
                    $display("\nERROR peso=%0d err=%h esperaba no corregible\n", peso, patron);
                end
            end
        end
    endtask

    initial begin
        i_clk = 0; i_rst = 1; i_rx = 24'b0;
        errores = 0;
        #10; i_rst = 0;

        // Peso 0 (1 patron)
        probar(24'b0, 0);

        // Peso 1 (24 patrones)
        for (a = 0; a < 24; a = a + 1) begin
            err = 24'b0; err[a] = 1'b1;
            probar(err, 1);
        end

        // Peso 2 (276 patrones)
        for (a = 0; a < 24; a = a + 1)
            for (b = a+1; b < 24; b = b + 1) begin
                err = 24'b0; err[a]=1'b1; err[b]=1'b1;
                probar(err, 2);
            end

        // Peso 3 (2024 patrones)
        for (a = 0; a < 24; a = a + 1)
            for (b = a+1; b < 24; b = b + 1)
                for (c = b+1; c < 24; c = c + 1) begin
                    err = 24'b0; err[a]=1'b1; err[b]=1'b1; err[c]=1'b1;
                    probar(err, 3);
                end

        // Peso 4 (10626 patrones, todos deben dar no corregible)
        for (a = 0; a < 24; a = a + 1)
            for (b = a+1; b < 24; b = b + 1)
                for (c = b+1; c < 24; c = c + 1)
                    for (d = c+1; d < 24; d = d + 1) begin
                        err = 24'b0; err[a]=1'b1; err[b]=1'b1; err[c]=1'b1; err[d]=1'b1;
                        probar(err, 4);
                    end

        if (errores == 0)
            $display("\nOK: decoder verificado para pesos 0-4 (12951 patrones, igual tabla del Ejercicio 7)\n");
        else
            $display("\nFALLA: %0d errores\n", errores);
        $finish;
    end
endmodule