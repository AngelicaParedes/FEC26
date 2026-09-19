// Deinterleaver: el espejo exacto del anterior, con retardo
// (LAMBDA-1-i)*J por rama, para que la suma con el interleaver de
// siempre el mismo retardo total.
module conv_deinterleaver #(
    parameter LAMBDA = 24,
    parameter J = 1
) (
    input wire i_clk,
    input wire i_rst,
    input wire i_bit,
    output reg o_bit
);

    localparam WIDTH = (LAMBDA <= 1) ? 1 : $clog2(LAMBDA);

    reg [WIDTH-1:0] branch_sel;
    always @(posedge i_clk) begin
        if (i_rst)
            branch_sel <= {WIDTH{1'b0}};
        else if (branch_sel == LAMBDA-1)
            branch_sel <= {WIDTH{1'b0}};
        else
            branch_sel <= branch_sel + 1'b1;
    end

    wire [LAMBDA-1:0] delay_out;

    genvar gi;
    generate
        for (gi = 0; gi < LAMBDA; gi = gi + 1) begin : rama
            // UNICA diferencia con el interleaver: la profundidad esta invertida
            localparam DEPTH = (LAMBDA - 1 - gi) * J;
            if (DEPTH == 0) begin : sin_registro
                assign delay_out[gi] = i_bit;
            end else begin : con_registro
                reg [DEPTH-1:0] sr;
                wire sel = (branch_sel == gi);
                always @(posedge i_clk) begin
                    if (i_rst)
                        sr <= {DEPTH{1'b0}};
                    else if (sel) begin 
                        if (DEPTH ==1)
                            sr<= i_bit;
                        else                // solo se mueve en su turno
                            sr <= {sr[DEPTH-2:0], i_bit};
                    end
                end
                assign delay_out[gi] = sr[DEPTH-1];
            end
        end
    endgenerate

    always @(*) begin
        o_bit = delay_out[branch_sel];
    end

endmodule