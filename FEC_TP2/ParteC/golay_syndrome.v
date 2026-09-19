module golay_syndrome(
    input wire [23:0] i_rx, // palabra de codigo = mensaje + paridad
    output wire [11:0] o_syn // sale el sindrome
);
    wire [11:0] mult_result;

    golay_mult_b mult_inst (
        .i_vec(i_rx[23:12]),   // la parte del mensaje de i_rx
        .o_vec(mult_result)
    );

    assign o_syn = mult_result ^ i_rx[11:0];   // XOR con la parte de paridad de i_rx

endmodule