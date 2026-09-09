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
        i_rx  = 24'hA5D9A6;                              // r1
        i_err = 24'b000000000001000000000011;            // el error que calculó golay_err_gen para r1
        #10;
        $display("cw=%h msg=%h (esperado cw=a5c9a5 msg=a5c)", o_cw, o_msg);
        $finish;
    end
endmodule