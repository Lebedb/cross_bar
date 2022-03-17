module top_cross_bar #(
    parameter DW       = 32,
    parameter AW       = 32,
    parameter REGS_NUM = 4   // number of agents
) (
    input                                       clk_i       ,
    input                                       reset_i     , // Asynchronous reset active high
    // host
    input  logic    [REGS_NUM-1:0]              req_i       , // request for execution
    input  logic    [REGS_NUM-1:0]              cmd_i       , // 0 - read, 1 - write
    input           [REGS_NUM-1:0][AW-1:0]      addr_i      ,
    input           [REGS_NUM-1:0][DW-1:0]      wdata_i     ,
    input  logic    [REGS_NUM-1:0]              resp_i      , // permission for read rdata
    output logic    [REGS_NUM-1:0][DW-1:0]      rdata_o     ,
    output logic    [REGS_NUM-1:0]              ack_o         // request confirmation
);

/*------------------------------------------------------------------------------
--  Declare
------------------------------------------------------------------------------*/
    logic [REGS_NUM-1:0]         w_req       ;
    logic [REGS_NUM-1:0]         w_cmd       ;
    logic [REGS_NUM-1:0]         w_ack       ;
    logic [REGS_NUM-1:0][DW-1:0] w_host_word ;
    logic [REGS_NUM-1:0][DW-1:0] w_agent_word;

/*------------------------------------------------------------------------------
--  CONNECTIONS
------------------------------------------------------------------------------*/
cross_bar #(
    .DW      (DW      ),
    .AW      (AW      ),
    .REGS_NUM(REGS_NUM)
) cross_bar_inst (
    .clk_i       (clk_i       ),
    .reset_i     (reset_i     ),
    .req_i       (req_i       ),
    .cmd_i       (cmd_i       ),
    .addr_i      (addr_i      ),
    .wdata_i     (wdata_i     ),
    .rdata_o     (rdata_o     ),
    .resp_i      (resp_i      ),
    .ack_o       (ack_o       ),
    .ack_i       (w_ack       ),
    .cmd_o       (w_cmd       ),
    .agent_word_i(w_agent_word),
    .req_o       (w_req       ),
    .host_word_o (w_host_word )
);

slave #(
    .DW(DW),
    .AW(AW)
) slave_0 (
    .clk_i  (clk_i          ),
    .reset_i(reset_i        ),
    .req_i  (w_req[0]       ),
    .cmd_i  (w_cmd[0]       ),
    .wdata_i(w_host_word[0] ),
    .rdata_o(w_agent_word[0]),
    .ack_o  (w_ack[0]       )
);

slave #(
    .DW(DW),
    .AW(AW)
) slave_1 (
    .clk_i  (clk_i          ),
    .reset_i(reset_i        ),
    .req_i  (w_req[1]       ),
    .cmd_i  (w_cmd[1]       ),
    .wdata_i(w_host_word[1] ),
    .rdata_o(w_agent_word[1]),
    .ack_o  (w_ack[1]       )
);

slave #(
    .DW(DW),
    .AW(AW)
) slave_2 (
    .clk_i  (clk_i          ),
    .reset_i(reset_i        ),
    .req_i  (w_req[2]       ),
    .cmd_i  (w_cmd[2]       ),
    .wdata_i(w_host_word[2] ),
    .rdata_o(w_agent_word[2]),
    .ack_o  (w_ack[2]       )
);

slave #(
    .DW(DW),
    .AW(AW)
) slave_3 (
    .clk_i  (clk_i          ),
    .reset_i(reset_i        ),
    .req_i  (w_req[3]       ),
    .cmd_i  (w_cmd[3]       ),
    .wdata_i(w_host_word[3] ),
    .rdata_o(w_agent_word[3]),
    .ack_o  (w_ack[3]       )
);

endmodule : top_cross_bar
/*------------------------------------------------------------------------------         
            //_//         
           /  -  \________________
          /                         \
         | Y                         \
          \___/ |                   |
            __/  \    /----     -    \
          //____/ |  |     \  |  \   /
   ______________//_/_____//_/__//__/_________
        capycode
------------------------------------------------------------------------------*/