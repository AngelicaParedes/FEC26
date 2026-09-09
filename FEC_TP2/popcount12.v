module popcount12 (
input wire [11:0] i_vec, //pines de entrada (12 bits) ivec[11]...ivec[0]
output wire [3:0] o_weight //pines de salida (4 bits)
);
    assign o_weight = i_vec[0] + i_vec[1] + i_vec[2] + i_vec[3] +
                      i_vec[4] + i_vec[5] + i_vec[6] + i_vec[7] +
                      i_vec[8] + i_vec[9] + i_vec[10] + i_vec[11];

endmodule
