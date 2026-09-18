module golay_row_search_tb;
    reg [11:0] i_vec;
    wire o_found;
    wire [3:0] o_idx;
    wire [11:0] o_res;

    golay_row_search golay_row_search_inst (
        .i_vec(i_vec),
        .o_found(o_found),
        .o_idx(o_idx),
        .o_res(o_res)
    );

    initial begin
        i_vec = 12'hEAA; //sindrome de r1 del Ejercicio 3
        #10;
        $display("\ni_vec=%h (%b) ->Sindrome de r1 \no_found=%b  \no_idx=%d  \no_res=%h\n", i_vec, i_vec, o_found, o_idx, o_res);
        #10;

        i_vec = 12'h1B2; //sindrome de r2 del Ejercicio 3
        #10;
        $display("\ni_vec=%h (%b) ->Sindrome de r2 \no_found=%b  \no_idx=%d  \no_res=%h\n", i_vec, i_vec, o_found, o_idx, o_res);
        
        $finish;
    end 

endmodule