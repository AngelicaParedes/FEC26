module golay_mult_b_exhaustivo_tb;
    reg [11:0] i_vec;
    wire [11:0] o_vec1, o_vec2;
    integer i;
    integer errores;

    golay_mult_b dut1 ( .i_vec(i_vec), .o_vec(o_vec1) );
    golay_mult_b dut2 ( .i_vec(o_vec1), .o_vec(o_vec2) );

    initial begin
        errores = 0;
        for (i = 0; i < 4096; i = i + 1) begin
            i_vec = i[11:0];
            #1;
            if (o_vec2 !== i_vec) begin
                errores = errores + 1;
                $display("ERROR en i_vec=%h: doble mult_b dio %h", i_vec, o_vec2);
            end
        end
        if (errores == 0)
            $display("OK: B^2=I verificado en hardware para las 4096 palabras");
        else
            $display("FALLA: %0d errores encontrados", errores);
        $finish;
    end
endmodule