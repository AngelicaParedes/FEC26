module golay_syndrome_codewords_tb;
    reg [11:0] i_msg;
    wire [11:0] paridad;
    reg [23:0] cw;
    wire [11:0] sindrome;
    integer i, errores;

    golay_mult_b mult_inst ( .i_vec(i_msg), .o_vec(paridad) );
    golay_syndrome syn_inst ( .i_rx(cw), .o_syn(sindrome) );

    initial begin
        errores = 0;
        for (i = 0; i < 4096; i = i + 1) begin
            i_msg = i[11:0];
            #1;
            cw = {i_msg, paridad};
            #1;
            if (sindrome !== 12'b0) begin
                errores = errores + 1;
                $display("\nERROR: mensaje=%h sindrome=%b\n", i_msg, sindrome);
            end
        end
        if (errores == 0)
            $display("\nOK: sindrome nulo verificado para las 4096 palabras codigo\n");
        else
            $display("\nFALLA: %0d errores\n", errores);
        $finish;
    end
endmodule