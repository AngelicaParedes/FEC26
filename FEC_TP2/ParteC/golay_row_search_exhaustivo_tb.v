module golay_row_search_exhaustivo_tb;
    reg [11:0] i_vec;
    wire o_found;
    wire [3:0] o_idx;
    wire [11:0] o_res;

    golay_row_search row_inst ( .i_vec(i_vec), .o_found(o_found), .o_idx(o_idx), .o_res(o_res) );

    reg [11:0] B [0:11];   // copia de B, para calcular el resultado esperado
    integer i, k, errores;
    reg esperado_found;
    reg [3:0] esperado_idx;
    reg [11:0] esperado_res, cand;
    integer peso;

    initial begin
        B[0]=12'h98F;  B[1]=12'h4E7;  B[2]=12'h357;  B[3]=12'hBE2;
        B[4]=12'hDD1;  B[5]=12'h7CC;  B[6]=12'h53D;  B[7]=12'h2BE;
        B[8]=12'h87B;  B[9]=12'hE74;  B[10]=12'hF1A; B[11]=12'hEA9;

        errores = 0;
        for (i = 0; i < 4096; i = i + 1) begin
            i_vec = i[11:0];

            esperado_found = 1'b0;
            esperado_idx = 4'd0;
            esperado_res = 12'b0;
            for (k = 0; k < 12; k = k + 1) begin
                cand = i_vec ^ B[k];
                peso = cand[0]+cand[1]+cand[2]+cand[3]+cand[4]+cand[5]+
                       cand[6]+cand[7]+cand[8]+cand[9]+cand[10]+cand[11];
                if (!esperado_found && peso <= 2) begin
                    esperado_found = 1'b1;
                    esperado_idx = k[3:0];
                    esperado_res = cand;
                end
            end

            #1;
            if (o_found !== esperado_found || o_idx !== esperado_idx || o_res !== esperado_res) begin
                errores = errores + 1;
                $display("ERROR en i_vec=%h\n", i_vec);
            end
        end

        if (errores == 0)
            $display("\nOK: golay_row_search verificado para las 4096 combinaciones\n");
        else
            $display("\nFALLA: %0d errores\n", errores);
        $finish;
    end
endmodule