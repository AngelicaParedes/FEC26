/*Decodificador: recibe la palabra de codigo (24 bits) y devuelve el mensaje (12 bits) 
y el vector de error (24 bits)*/

module golay_decoder (
    input wire i_clk, i_rst,
    input wire [23:0] i_rx,
    output reg [11:0] o_msg,
    output reg [23:0] o_err,
    output reg o_corrected,
    output reg o_uncorrectable
);

    // -------------ETAPA 1: Sindrome -----------------
    wire [11:0] s_comb;
    golay_syndrome syn_inst ( .i_rx(i_rx), .o_syn(s_comb) );

    reg [23:0] r_e1;
    reg [11:0] s_e1;

    always @(posedge i_clk) begin
        if (i_rst) begin
            r_e1 <= 24'b0;
            s_e1 <= 12'b0;
        end else begin
            r_e1 <= i_rx;
            s_e1 <= s_comb;
        end
    end

    // -------------ETAPA 2 -----------------
    wire [3:0] w_s_comb;
    popcount12 pop_s_inst ( .i_vec(s_e1), .o_weight(w_s_comb) );

    wire found_s_comb;
    wire [3:0] idx_s_comb;
    wire [11:0] res_s_comb;
    golay_row_search search_s_inst (
        .i_vec(s_e1), .o_found(found_s_comb), .o_idx(idx_s_comb), .o_res(res_s_comb)
    );

    wire [11:0] q_comb;
    golay_mult_b mult_q_inst ( .i_vec(s_e1), .o_vec(q_comb) );

    wire [3:0] w_q_comb;
    popcount12 pop_q_inst ( .i_vec(q_comb), .o_weight(w_q_comb) );

    wire found_q_comb;
    wire [3:0] idx_q_comb;
    wire [11:0] res_q_comb;
    golay_row_search search_q_inst (
        .i_vec(q_comb), .o_found(found_q_comb), .o_idx(idx_q_comb), .o_res(res_q_comb)
    );

    reg [23:0] r_e2;
    reg [11:0] s_e2, q_e2, res_s_e2, res_q_e2;
    reg [3:0] w_s_e2, w_q_e2, idx_s_e2, idx_q_e2;
    reg found_s_e2, found_q_e2;

    always @(posedge i_clk) begin
        if (i_rst) begin
            r_e2 <= 24'b0; s_e2 <= 12'b0; q_e2 <= 12'b0;
            res_s_e2 <= 12'b0; res_q_e2 <= 12'b0;
            w_s_e2 <= 4'b0; w_q_e2 <= 4'b0;
            idx_s_e2 <= 4'b0; idx_q_e2 <= 4'b0;
            found_s_e2 <= 1'b0; found_q_e2 <= 1'b0;
        end else begin
            r_e2 <= r_e1;
            s_e2 <= s_e1;
            q_e2 <= q_comb;
            res_s_e2 <= res_s_comb;
            res_q_e2 <= res_q_comb;
            w_s_e2 <= w_s_comb;
            w_q_e2 <= w_q_comb;
            idx_s_e2 <= idx_s_comb;
            idx_q_e2 <= idx_q_comb;
            found_s_e2 <= found_s_comb;
            found_q_e2 <= found_q_comb;
        end
    end

    // -------------ETAPA 3 -----------------
    wire [23:0] err_comb;
    wire uncorrectable_comb;
    golay_err_gen errgen_inst (
        .i_syn(s_e2), .i_q(q_e2), .i_res_syn(res_s_e2), .i_res_q(res_q_e2),
        .i_w_syn(w_s_e2), .i_w_q(w_q_e2), .i_idx_syn(idx_s_e2), .i_idx_q(idx_q_e2),
        .i_found_syn(found_s_e2), .i_found_q(found_q_e2),
        .o_err(err_comb), .o_uncorrectable(uncorrectable_comb)
    );

    wire [23:0] cw_comb;
    wire [11:0] msg_comb;
    wire corrected_comb;
    golay_correct correct_inst (
        .i_rx(r_e2), .i_err(err_comb),
        .o_cw(cw_comb), .o_msg(msg_comb), .o_corrected(corrected_comb)
    );

    always @(posedge i_clk) begin
        if (i_rst) begin
            o_msg <= 12'b0; o_err <= 24'b0;
            o_corrected <= 1'b0; o_uncorrectable <= 1'b0;
        end else begin
            o_msg <= msg_comb;
            o_err <= err_comb;
            o_corrected <= corrected_comb & ~uncorrectable_comb;
            o_uncorrectable <= uncorrectable_comb;
        end
    end

endmodule