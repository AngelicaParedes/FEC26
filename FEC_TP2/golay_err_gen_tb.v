module golay_err_gen_tb;
    reg [11:0] i_syn, i_q, i_res_syn, i_res_q;
    reg [3:0] i_w_syn, i_w_q, i_idx_syn, i_idx_q;
    reg i_found_syn, i_found_q;
    wire [23:0] o_err;
    wire o_uncorrectable;

    golay_err_gen dut (
        .i_syn(i_syn), .i_q(i_q), .i_res_syn(i_res_syn), .i_res_q(i_res_q),
        .i_w_syn(i_w_syn), .i_w_q(i_w_q), .i_idx_syn(i_idx_syn), .i_idx_q(i_idx_q),
        .i_found_syn(i_found_syn), .i_found_q(i_found_q),
        .o_err(o_err), .o_uncorrectable(o_uncorrectable)
    );

    initial begin
        // ----- r1: Caso 2 esperado -----
        i_syn = 12'hEAA; i_w_syn = 4'd7; i_found_syn = 1'b1;
        i_idx_syn = 4'd11; i_res_syn = 12'b000000000011;
        i_q = 12'd0; i_w_q = 4'd0; i_found_q = 1'b0; i_idx_q = 4'd0; i_res_q = 12'd0;
        #10;
        $display("\nr1: err=%b (%h) \nuncorrectable=%b (esperado err=000000000011000000000001)",
                   o_err, o_err, o_uncorrectable);

        // ----- r2: Caso 4 esperado -----
        i_syn = 12'h1B2; i_w_syn = 4'd5; i_found_syn = 1'b0;
        i_idx_syn = 4'd0; i_res_syn = 12'd0;
        i_q = 12'hEAA; i_w_q = 4'd7; i_found_q = 1'b1;
        i_idx_q = 4'd11; i_res_q = 12'h003;
        #10;
        $display("\nr2: err=%b (%h) \nuncorrectable=%b (esperado err=000000000011000000000001)",
                   o_err, o_err, o_uncorrectable);

        // ----- r3: no corregible esperado -----
        i_syn = 12'h00F; i_w_syn = 4'd4; i_found_syn = 1'b0;
        i_idx_syn = 4'd0; i_res_syn = 12'd0;
        i_q = 12'h7BC; i_w_q = 4'd8; i_found_q = 1'b0;
        i_idx_q = 4'd0; i_res_q = 12'd0;
        #10;
        $display("\nr3: uncorrectable=%b (esperado 1)", o_uncorrectable);

        $finish;
    end
endmodule