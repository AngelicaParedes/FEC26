module golay_decoder_tb;
    reg i_clk, i_rst;
    reg [23:0] i_rx;
    wire [11:0] o_msg;
    wire [23:0] o_err;
    wire o_corrected, o_uncorrectable;

    golay_decoder dut (
        .i_clk(i_clk), .i_rst(i_rst), .i_rx(i_rx),
        .o_msg(o_msg), .o_err(o_err),
        .o_corrected(o_corrected), .o_uncorrectable(o_uncorrectable)
    );

    always #5 i_clk = ~i_clk;

    initial begin
        i_clk = 0;
        i_rst = 1;
        i_rx = 24'h000000;
        #10;
        i_rst = 0;

        i_rx = 24'hA5D9A6;   // r1 del Ejercicio 3
        #30;
        $display("\nr1=%h -> msg=%h (%b) \ncorregido=%b \nno_corregible=%b (esperado msg=A5C)",
                  i_rx, o_msg, o_msg, o_corrected, o_uncorrectable);

        i_rx = 24'hA5F9A4;   // r2 del Ejercicio 3
        #30;
        $display("\nr2=%h -> msg=%h (%b) \ncorregido=%b \nno_corregible=%b (esperado msg=A5C)",
                  i_rx, o_msg, o_msg, o_corrected, o_uncorrectable);

        i_rx = 24'hA5C9AA;   // r3 del Ejercicio 3
        #30;
        $display("\nr3=%h -> msg=%h (%b) \ncorregido=%b \nno_corregible=%b (esperado no_corregible=1)",
                  i_rx, o_msg, o_msg, o_corrected, o_uncorrectable);

        $finish;
    end
endmodule