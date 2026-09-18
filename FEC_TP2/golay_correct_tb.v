module golay_correct_tb;
    reg [23:0] i_rx, i_err;
    wire [23:0] o_cw;
    wire [11:0] o_msg;
    wire o_corrected;

    golay_correct dut (
        .i_rx(i_rx), .i_err(i_err),
        .o_cw(o_cw), .o_msg(o_msg), .o_corrected(o_corrected)
    );

    initial begin
        i_rx  = 24'hA5D9A6;                              // r1 del Ejercicio 3
        i_err = 24'b000000000001000000000011;            // el error que calculó golay_err_gen para r1
        #10;
        $display("===========r1 del Ejercicio 3====================\n");
        $display("i_rx=%h \ncw=%h (Palabra de codigo) \nmsg=%h (mensaje) \n(esperado cw=a5c9a5 msg=a5c)\n", i_rx, o_cw, o_msg);
        #10;

        i_rx  = 24'hA5F9A4;                              // r2 del Ejercicio 3
        i_err = 24'b000000000011000000000001;            // el error que calculó golay_err_gen para r2
        #10;
        $display("===========r2 del Ejercicio 3====================\n");
        $display("i_rx=%h \ncw=%h (Palabra de codigo) \nmsg=%h (mensaje) \n(esperado cw=a5c9a5 msg=a5c)\n", i_rx, o_cw, o_msg);

        $finish;
    end
endmodule