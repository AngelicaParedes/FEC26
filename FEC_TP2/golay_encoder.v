//Codificador: arma la palabra de codigo (24bits)

module golay_encoder (
    input wire i_clk, i_rst, //reloj y reset (entradas de 1 bit)
    input wire [11:0] i_msg, // Entrada de 12 bits - Mensja
    output reg [23:0] o_cw // Salida de 24 bits (12 bits de mensaje + 12 bits de paridad) -Palabra de codigo
);

    wire [11:0] paridad;

    golay_mult_b mult_b_inst (
        .i_vec(i_msg), 
        .o_vec(paridad)
    );

    /*bloque que corre en cada flanco positivo del reloj */
    always @(posedge i_clk) begin
        if (i_rst)
            o_cw <= 24'b0; // asignacion dentro de always, se usa <= para indicar que es una asignacion no bloqueante
        else
            o_cw <= {i_msg, paridad};
    end

endmodule