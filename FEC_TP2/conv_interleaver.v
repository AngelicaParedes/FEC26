// Interleaver convolucional: "desparrama" los bits en el tiempo, con
// lambda ramas rotativas, cada una con un retardo distinto (i*J).
module conv_interleaver #(
    parameter LAMBDA = 24,
    parameter J = 1
) (
    input wire i_clk,
    input wire i_rst,
    input wire i_bit,
    output reg o_bit
);

    localparam WIDTH = (LAMBDA <= 1) ? 1 : $clog2(LAMBDA);

    // Conmutador: recorre las ramas 0..LAMBDA-1 en orden, una por ciclo
    reg [WIDTH-1:0] branch_sel;
    always @(posedge i_clk) begin
        if (i_rst)
            branch_sel <= {WIDTH{1'b0}};
        else if (branch_sel == LAMBDA-1)
            branch_sel <= {WIDTH{1'b0}};   // vuelve a la rama 0
        else
            branch_sel <= branch_sel + 1'b1;
    end

    wire [LAMBDA-1:0] delay_out;   // salida candidata de cada rama

    // Genera automaticamente una linea de retardo por rama (LAMBDA copias)
    genvar gi;
    generate
        for (gi = 0; gi < LAMBDA; gi = gi + 1) begin : rama
            localparam DEPTH = gi * J;   // profundidad de esta rama
            if (DEPTH == 0) begin : sin_registro
                assign delay_out[gi] = i_bit;   // rama 0: sin retardo
            end else begin : con_registro
                reg [DEPTH-1:0] sr;
                wire sel = (branch_sel == gi);
                always @(posedge i_clk) begin
                    if (i_rst)
                        sr <= {DEPTH{1'b0}};
                    else if (sel)  begin
                       if (DEPTH ==1)
                            sr<= i_bit;
                        else                // solo se mueve en su turno
                            sr <= {sr[DEPTH-2:0], i_bit}; 
                    end              
                end
                assign delay_out[gi] = sr[DEPTH-1];  // el bit mas viejo guardado
            end
        end
    endgenerate

    // Salida: el bit de la rama que le toca en este ciclo
    always @(*) begin
        o_bit = delay_out[branch_sel];
    end

endmodule