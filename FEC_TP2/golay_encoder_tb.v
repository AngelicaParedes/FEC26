module golay_encoder_tb;
    reg i_clk, i_rst;
    reg [11:0] i_msg;
    wire [23:0] o_cw;

    golay_encoder encoder_inst (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_msg(i_msg),
        .o_cw(o_cw)
    );

    always #5 i_clk = ~i_clk; //generador de reloj

    initial begin
        // Inicializar señales
        i_clk = 0; //clock inicia en 0
        i_rst = 1; // Activar reset
        i_msg = 12'h000; // Entrada de prueba

        #10; // Esperar 10 unidades de tiempo

        i_rst = 0; // Desactivar reset
        i_msg = 12'hA5C; // Cambiar la entrada de prueba

        #10; // Esperar 10 unidades de tiempo para que se propague la señal o_cw

        //Resultado
        $display("\nmensaje=%h \n\nPalabra de codigo=%h \n", i_msg, o_cw);
        $finish; 
    end

endmodule
