module slave #(
    parameter DW = 32,
    parameter AW = 32
) (
    input                 clk_i  ,
    input                 reset_i, // Asynchronous reset active high
    // din data
    input  logic          req_i  , // request for execution
    input  logic          cmd_i  , // 0 - read, 1 - write
    input  logic [DW-1:0] wdata_i,
    // dout data
    output logic [DW-1:0] rdata_o,
    output logic          ack_o
);

/*------------------------------------------------------------------------------
--  Declare
------------------------------------------------------------------------------*/
    logic [DW-1:0] data_mem;
    logic          ack_ff;
    logic          ack_prev_ff;

    always_ff @(posedge clk_i) begin
        ack_prev_ff <= ack_ff;
        end

    assign ack_o = ack_ff && ~ack_prev_ff;   
/*------------------------------------------------------------------------------
--  Functional
------------------------------------------------------------------------------*/
    always_ff @(posedge clk_i or posedge reset_i) begin : proc_ack_o
        if (reset_i) begin
            ack_ff <= '0;
        end else if ( req_i ) begin
            ack_ff <= '1;
        end else begin 
            ack_ff <= '0;
        end
    end

    // write data
    always_ff @(posedge clk_i or posedge reset_i) begin : proc_data_mem
        if (reset_i) begin
            data_mem <= '0;
        end else if ( req_i && cmd_i && ~ack_prev_ff ) begin
            data_mem <= wdata_i;
        end
    end

    // read data
    always_ff @(posedge clk_i or posedge reset_i) begin : proc_rdata_o
        if (reset_i) begin
            rdata_o <= '0;
        end else if ( req_i && !cmd_i && ~ack_prev_ff ) begin
            rdata_o <= data_mem;
        end else begin
            rdata_o <= '0;
        end
    end

endmodule : slave
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