module golay_err_gen (
    input wire [11:0] i_syn, i_q, i_res_syn, i_res_q,
    input wire [3:0] i_w_syn, i_w_q, i_idx_syn, i_idx_q,
    input wire i_found_syn, i_found_q,
    output wire [23:0] o_err,
    output wire o_uncorrectable
);

    //Casos (Cuadro del ejercicio 9 Decodificador): 
    wire caso1 = (i_w_syn <= 4'd3);
    wire caso2 = (!caso1) && i_found_syn;
    wire caso3 = (!caso1) && (!caso2) && (i_w_q <= 4'd3);
    wire caso4 = (!caso1) && (!caso2) && (!caso3) && i_found_q;

    assign o_uncorrectable = !(caso1 || caso2 || caso3 || caso4);


    function [11:0] one_hot;
        input [3:0] idx;
        begin
            case (idx)
                4'd0:  one_hot = 12'b100000000000;
                4'd1:  one_hot = 12'b010000000000;
                4'd2:  one_hot = 12'b001000000000;
                4'd3:  one_hot = 12'b000100000000;
                4'd4:  one_hot = 12'b000010000000;
                4'd5:  one_hot = 12'b000001000000;
                4'd6:  one_hot = 12'b000000100000;
                4'd7:  one_hot = 12'b000000010000;
                4'd8:  one_hot = 12'b000000001000;
                4'd9:  one_hot = 12'b000000000100;
                4'd10: one_hot = 12'b000000000010;
                4'd11: one_hot = 12'b000000000001;
                default: one_hot = 12'b000000000000;
            endcase
        end
    endfunction

    assign o_err = caso1 ? {12'b0, i_syn} :
                   caso2 ? {one_hot(i_idx_syn), i_res_syn} :
                   caso3 ? {i_q, 12'b0} :
                   caso4 ? {one_hot(i_idx_q), i_res_q} :
                   24'b0;

endmodule