module golay_row_search (
    input wire [11:0] i_vec, //vector de 12 bits
    output wire       o_found, 
    output wire [3:0]  o_idx,
    output [11:0] o_res
);

    //12 filas de la Matriz B
    wire [11:0] B0 = 12'h98F; //b0
    wire [11:0] B1 = 12'h4E7; //b1
    wire [11:0] B2 = 12'h357; //b2
    wire [11:0] B3 = 12'hBE2; //b3
    wire [11:0] B4 = 12'hDD1; //b4
    wire [11:0] B5 = 12'h7CC; //b5
    wire [11:0] B6 = 12'h53D; //b6
    wire [11:0] B7 = 12'h2BE; //b7
    wire [11:0] B8 = 12'h87B; //b8
    wire [11:0] B9 = 12'hE74; //b9
    wire [11:0] B10 = 12'hF1A; //b10
    wire [11:0] B11 = 12'hEA9; //b11

    reg found_r;
    reg [3:0] idx_r;
    reg [11:0] res_r;

    integer i; //contador
    reg [11:0] cand, fila_actual;
    reg [3:0] peso;

    always @(*) begin
        found_r = 1'b0;
        idx_r = 4'd0;
        res_r = 12'd0;

        for (i = 0; i < 12; i = i + 1) begin
            case (i)
                0: fila_actual = B0;
                1: fila_actual = B1;
                2: fila_actual = B2;
                3: fila_actual = B3;
                4: fila_actual = B4;
                5: fila_actual = B5;
                6: fila_actual = B6;
                7: fila_actual = B7;
                8: fila_actual = B8;
                9: fila_actual = B9;
                10: fila_actual = B10;
                11: fila_actual = B11;
                default: fila_actual = 12'b0;
            endcase

            cand = i_vec ^ fila_actual; // XOR entre el vector de entrada y la fila actual
            peso = cand [0]+cand [1]+cand [2]+cand [3]+cand [4]+cand [5]+cand [6]+cand [7]+cand [8]+cand [9]+cand [10]+cand [11]; // Calcular el peso del candidato

            if (!found_r &&peso <= 2) begin
                found_r = 1'b1; // Se encontro un candidato válido
                idx_r = i[3:0]; // Guardar el índice de la fila encontrada
                res_r = cand; // Guardar el resultado del candidato
            end
        end
    end

    assign o_found = found_r;
    assign o_idx = idx_r;   
    assign o_res = res_r;

endmodule