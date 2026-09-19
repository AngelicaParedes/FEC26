module golay_mult_b (
input wire [11:0] i_vec,
output wire [11:0] o_vec
);

    assign o_vec[11] = i_vec[11] ^ i_vec[8] ^ i_vec[7] ^ i_vec[3] ^ i_vec[2] ^ i_vec[1] ^ i_vec[0]; //Columna 0
    assign o_vec[10] = i_vec[10] ^ i_vec[7] ^ i_vec[6] ^ i_vec[5] ^ i_vec[2] ^ i_vec[1] ^ i_vec[0]; // Columna 1
    assign o_vec[9] = i_vec[9] ^ i_vec[8] ^ i_vec[6] ^ i_vec[4] ^ i_vec[2] ^ i_vec[1] ^ i_vec[0]; // Columna 2
    assign o_vec[8] = i_vec[11] ^ i_vec[9] ^ i_vec[8] ^ i_vec[7] ^ i_vec[6] ^ i_vec[5] ^ i_vec[1];  // Columna 3
    assign o_vec[7] = i_vec[11] ^ i_vec[10] ^ i_vec[8] ^ i_vec[7] ^ i_vec[6] ^ i_vec[4] ^ i_vec[0]; // Columna 4
    assign o_vec[6] = i_vec[10] ^ i_vec[9] ^ i_vec[8] ^ i_vec[7] ^ i_vec[6] ^ i_vec[3] ^ i_vec[2]; // Columna 5
    assign o_vec[5] = i_vec[10] ^ i_vec[8] ^ i_vec[5] ^ i_vec[4] ^ i_vec[3] ^ i_vec[2] ^ i_vec[0]; // Columna 6
    assign o_vec[4] = i_vec[9] ^ i_vec[7] ^ i_vec[5] ^ i_vec[4] ^ i_vec[3] ^ i_vec[2] ^ i_vec[1]; // Columna 7
    assign o_vec[3] = i_vec[11] ^ i_vec[6] ^ i_vec[5] ^ i_vec[4] ^ i_vec[3] ^ i_vec[1] ^ i_vec[0]; // Columna 8
    assign o_vec[2] = i_vec[11] ^ i_vec[10] ^ i_vec[9] ^ i_vec[6] ^ i_vec[5] ^ i_vec[4] ^ i_vec[2]; // Columna 9
    assign o_vec[1] = i_vec[11] ^ i_vec[10] ^ i_vec[9] ^ i_vec[8] ^ i_vec[4] ^ i_vec[3] ^ i_vec[1]; //Columna 10
    assign o_vec[0] = i_vec[11] ^ i_vec[10] ^ i_vec[9] ^ i_vec[7] ^ i_vec[5] ^ i_vec[3] ^ i_vec[0]; //Columna 11

endmodule
