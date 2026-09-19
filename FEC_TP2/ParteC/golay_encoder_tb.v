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

        #10; 

        i_rst = 0; // Desactivar reset
        i_msg = 12'hA5C; // Mensaje del Ejercicio 1

        #10; 

        
        $display("\nmensaje=%h \nmensaje (bin)=%b \n", i_msg, i_msg);
        $display("\nPalabra de codigo=%h \nPalabra de codigo (bin)=%b \n", o_cw, o_cw);
        $finish; 
    end

endmodule
