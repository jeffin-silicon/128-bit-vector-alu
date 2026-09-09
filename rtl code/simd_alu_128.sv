module simd_alu_128 (
    input  logic         clk_i,
    input  logic         rst_ni,

    input  logic [127:0] a_i,
    input  logic [127:0] b_i,
    input  logic [3:0]   op_i,

    output logic [127:0] result_o,
    output logic [3:0]   carry_o,
    output logic [3:0]   overflow_o,
    output logic [3:0]   zero_o
);

    // ============================================================
    // 4 x 32-bit SIMD lanes
    // ============================================================

    logic [31:0] lane_a      [0:3];
    logic [31:0] lane_b      [0:3];
    logic [31:0] lane_result [0:3];

    logic [3:0] lane_carry;
    logic [3:0] lane_overflow;
    logic [3:0] lane_zero;

    // ============================================================
    // Combinational results before output register
    // ============================================================

    logic [127:0] result_next;
    logic [3:0]   carry_next;
    logic [3:0]   overflow_next;
    logic [3:0]   zero_next;

    // ============================================================
    // Split 128-bit operands into four 32-bit SIMD lanes
    // ============================================================

    assign lane_a[0] = a_i[31:0];
    assign lane_a[1] = a_i[63:32];
    assign lane_a[2] = a_i[95:64];
    assign lane_a[3] = a_i[127:96];

    assign lane_b[0] = b_i[31:0];
    assign lane_b[1] = b_i[63:32];
    assign lane_b[2] = b_i[95:64];
    assign lane_b[3] = b_i[127:96];

    // ============================================================
    // SIMD lane computation
    // ============================================================

    genvar i;

    generate
        for (i = 0; i < 4; i = i + 1) begin : GEN_LANE

            logic [32:0] add_ext;
            logic [32:0] sub_ext;

            always_comb begin

                // Extended arithmetic
                add_ext = {1'b0, lane_a[i]} +
                          {1'b0, lane_b[i]};

                sub_ext = {1'b0, lane_a[i]} -
                          {1'b0, lane_b[i]};

                // Default values
                lane_result[i]   = 32'b0;
                lane_carry[i]    = 1'b0;
                lane_overflow[i] = 1'b0;

                case (op_i)

                    // ------------------------------------------------
                    // ADD
                    // ------------------------------------------------
                    4'b0000: begin

                        lane_result[i] = add_ext[31:0];
                        lane_carry[i]  = add_ext[32];

                        lane_overflow[i] =
                            (~(lane_a[i][31] ^ lane_b[i][31])) &
                            (lane_result[i][31] ^ lane_a[i][31]);

                    end

                    // ------------------------------------------------
                    // SUB
                    // ------------------------------------------------
                    4'b0001: begin

                        lane_result[i] = sub_ext[31:0];

                        // Carry = 1 indicates no borrow
                        lane_carry[i] = ~sub_ext[32];

                        lane_overflow[i] =
                            (lane_a[i][31] ^ lane_b[i][31]) &
                            (lane_result[i][31] ^ lane_a[i][31]);

                    end

                    // ------------------------------------------------
                    // AND
                    // ------------------------------------------------
                    4'b0010: begin

                        lane_result[i] =
                            lane_a[i] & lane_b[i];

                    end

                    // ------------------------------------------------
                    // OR
                    // ------------------------------------------------
                    4'b0011: begin

                        lane_result[i] =
                            lane_a[i] | lane_b[i];

                    end

                    // ------------------------------------------------
                    // XOR
                    // ------------------------------------------------
                    4'b0100: begin

                        lane_result[i] =
                            lane_a[i] ^ lane_b[i];

                    end

                    // ------------------------------------------------
                    // NOR
                    // ------------------------------------------------
                    4'b0101: begin

                        lane_result[i] =
                            ~(lane_a[i] | lane_b[i]);

                    end

                    // ------------------------------------------------
                    // Signed less-than
                    // ------------------------------------------------
                    4'b0110: begin

                        lane_result[i] = {
                            31'b0,
                            ($signed(lane_a[i]) <
                             $signed(lane_b[i]))
                        };

                    end

                    // ------------------------------------------------
                    // Unsigned less-than
                    // ------------------------------------------------
                    4'b0111: begin

                        lane_result[i] = {
                            31'b0,
                            (lane_a[i] < lane_b[i])
                        };

                    end

                    // ------------------------------------------------
                    // Unsupported operation
                    // ------------------------------------------------
                    default: begin

                        lane_result[i]   = 32'b0;
                        lane_carry[i]    = 1'b0;
                        lane_overflow[i] = 1'b0;

                    end

                endcase

                // Zero flag for each SIMD lane
                lane_zero[i] =
                    (lane_result[i] == 32'b0);

            end

        end
    endgenerate

    // ============================================================
    // Combine four 32-bit SIMD lanes into 128-bit result
    // ============================================================

    always_comb begin

        result_next = {
            lane_result[3],
            lane_result[2],
            lane_result[1],
            lane_result[0]
        };

        carry_next    = lane_carry;
        overflow_next = lane_overflow;
        zero_next     = lane_zero;

    end

    // ============================================================
    // One-stage output pipeline
    // Active-low asynchronous reset
    // ============================================================

    always_ff @(posedge clk_i or negedge rst_ni) begin

        if (!rst_ni) begin

            result_o   <= 128'b0;
            carry_o    <= 4'b0;
            overflow_o <= 4'b0;
            zero_o     <= 4'b0;

        end
        else begin

            result_o   <= result_next;
            carry_o    <= carry_next;
            overflow_o <= overflow_next;
            zero_o     <= zero_next;

        end

    end

endmodule
