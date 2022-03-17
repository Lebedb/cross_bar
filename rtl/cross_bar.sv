module cross_bar #(
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
    output logic    [REGS_NUM-1:0]              ack_o       , // request confirmation
    // agent    
    input  logic    [REGS_NUM-1:0]              ack_i       ,
    output logic    [REGS_NUM-1:0]              cmd_o       ,
    output logic    [REGS_NUM-1:0]              req_o       ,
    input           [REGS_NUM-1:0][DW-1:0]      agent_word_i, // rdata
    output logic    [REGS_NUM-1:0][DW-1:0]      host_word_o   // wdata

);

    /*------------------------------------------------------------------------------
    --  FSM round-robin
    ------------------------------------------------------------------------------*/
    typedef enum logic [2:0] {WAIT_REQUEST, REQUEST_0, REQUEST_1, REQUEST_2, REQUEST_3} statetype;
    statetype state;

    logic [2:0] state_cnt;

    // FSM
    always_ff @(posedge clk_i or posedge reset_i) begin : proc_state           
    if ( reset_i ) begin
        state <= WAIT_REQUEST;
        state_cnt <= '0;
    end else begin
        case (state)
            WAIT_REQUEST : 
                begin   
                    if (req_i[0]) begin
                        state_cnt <= '0;
                        state     <= REQUEST_0;
                    end else if (req_i[1]) begin 
                        state_cnt <= '0;
                        state     <= REQUEST_1;
                    end else if (req_i[2]) begin 
                        state_cnt <= '0;
                        state     <= REQUEST_2;
                    end else if (req_i[3]) begin 
                        state_cnt <= '0;
                        state     <= REQUEST_3;
                    end 
                end   
            REQUEST_0 :
                begin 
                    if ( req_i[0] ) begin
                        if ( state_cnt == 'd3 ) begin                           
                            if ( req_i[1] ) begin           // request from master_1
                                state_cnt <= '0;
                                state     <= REQUEST_1;
                            end else if ( req_i[2] ) begin  // request from master_2
                                state_cnt <= '0;
                                state     <= REQUEST_2; 
                            end else if ( req_i[3] ) begin  // request from master_3
                                state_cnt <= '0;
                                state     <= REQUEST_3;
                            end else begin 
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 

                            end else begin                   // if cnt !== 'd3
                                state_cnt <= state_cnt + 1'b1;
                                state     <= REQUEST_0;
                            end
                            end else if ( req_i[1] ) begin   // if req[0] == '0
                                state_cnt <= '0;
                                state     <= REQUEST_1;
                            end else if ( req_i[2] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_2;
                            end else if ( req_i[3] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_3;
                            end else begin
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 
                        end 
            REQUEST_1 : 
                begin 
                    if ( req_i[1] ) begin
                        if ( state_cnt == 'd3 ) begin                           
                            if ( req_i[2] ) begin           // request from master_2
                                state_cnt <= '0;
                                state     <= REQUEST_2;
                            end else if ( req_i[3] ) begin  // request from master_3
                                state_cnt <= '0;
                                state     <= REQUEST_3; 
                            end else if ( req_i[0] ) begin  // request from master_0
                                state_cnt <= '0;
                                state     <= REQUEST_0;
                            end else begin 
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 

                            end else begin                   // if cnt !== 'd3
                                state_cnt <= state_cnt + 1'b1;
                                state     <= REQUEST_1;
                            end
                            end else if ( req_i[2] ) begin   // if req[1] == '0
                                state_cnt <= '0;
                                state     <= REQUEST_2;
                            end else if ( req_i[3] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_3;
                            end else if ( req_i[0] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_0;
                            end else begin
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 
                        end

            REQUEST_2 : 
                begin 
                    if ( req_i[2] ) begin
                        if ( state_cnt == 'd3 ) begin                           
                            if ( req_i[3] ) begin           // request from master_3
                                state_cnt <= '0;
                                state     <= REQUEST_3;
                            end else if ( req_i[0] ) begin  // request from master_0
                                state_cnt <= '0;
                                state     <= REQUEST_0; 
                            end else if ( req_i[1] ) begin  // request from master_1
                                state_cnt <= '0;
                                state     <= REQUEST_1;
                            end else begin 
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 

                            end else begin                   // if cnt !== 'd3
                                state_cnt <= state_cnt + 1'b1;
                                state     <= REQUEST_2;
                            end
                            end else if ( req_i[3] ) begin   // if req[2] == '0
                                state_cnt <= '0;
                                state     <= REQUEST_3;
                            end else if ( req_i[0] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_0;
                            end else if ( req_i[1] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_1;
                            end else begin
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 
                        end
            REQUEST_3 : 
                begin 
                    if ( req_i[3] ) begin
                        if ( state_cnt == 'd3 ) begin                           
                            if ( req_i[0] ) begin           // request from master_0
                                state_cnt <= '0;
                                state     <= REQUEST_0;
                            end else if ( req_i[1] ) begin  // request from master_1
                                state_cnt <= '0;
                                state     <= REQUEST_1; 
                            end else if ( req_i[2] ) begin  // request from master_2
                                state_cnt <= '0;
                                state     <= REQUEST_2;
                            end else begin 
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 

                            end else begin                   // if cnt !== 'd3
                                state_cnt <= state_cnt + 1'b1;
                                state     <= REQUEST_3;
                            end
                            end else if ( req_i[0] ) begin   // if req[3] == '0
                                state_cnt <= '0;
                                state     <= REQUEST_0;
                            end else if ( req_i[1] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_1;
                            end else if ( req_i[2] ) begin
                                state_cnt <= '0;
                                state     <= REQUEST_2;
                            end else begin
                                state_cnt <= '0;
                                state     <= WAIT_REQUEST;
                            end 
                        end   
            default : state <= WAIT_REQUEST;
        endcase
        end
    end

/*------------------------------------------------------------------------------
--  Write data logic
------------------------------------------------------------------------------*/
    // write data comb logic
    always_comb begin : proc_grant
        req_o   = '0;
        ack_o   = '0;
        cmd_o   = '0;
        
        case ( state )
            WAIT_REQUEST : 
                begin
                    req_o   = '0;
                    ack_o   = '0;
                    cmd_o   = '0;
                end 

            REQUEST_0 :
                begin
                    req_o[addr_i[0][DW-1:DW-2]]   = req_i  [0];
                    cmd_o[addr_i[0][DW-1:DW-2]]   = cmd_i  [0];
                    ack_o[0]                      = ack_i  [addr_i[0][DW-1:DW-2]];
                end

            REQUEST_1 :
                begin
                    req_o[addr_i[1][DW-1:DW-2]]   = req_i  [1];
                    cmd_o[addr_i[1][DW-1:DW-2]]   = cmd_i  [1];
                    ack_o[1]                      = ack_i  [addr_i[1][DW-1:DW-2]];
                end

            REQUEST_2 :
                begin
                    req_o[addr_i[2][DW-1:DW-2]]   = req_i  [2];
                    cmd_o[addr_i[2][DW-1:DW-2]]   = cmd_i  [2];
                    ack_o[2]                      = ack_i  [addr_i[2][DW-1:DW-2]];
                end

            REQUEST_3 :
                begin
                    req_o[addr_i[3][DW-1:DW-2]]   = req_i  [3];
                    cmd_o[addr_i[3][DW-1:DW-2]]   = cmd_i  [3];
                    ack_o[3]                      = ack_i  [addr_i[3][DW-1:DW-2]];
                end
        endcase
    end

    // write data sequential logic
    always_ff @(posedge clk_i or posedge reset_i) begin : proc_host_word_o
        if(reset_i) begin
            host_word_o <= '0;
        end else if ( state == REQUEST_0 && cmd_i[0] ) begin
            host_word_o[addr_i[0][DW-1:DW-2]] <= wdata_i[0];

        end else if ( state == REQUEST_1 && cmd_i[1] ) begin
            host_word_o[addr_i[1][DW-1:DW-2]] <= wdata_i[1];

        end else if ( state == REQUEST_2 && cmd_i[2] ) begin
            host_word_o[addr_i[2][DW-1:DW-2]] <= wdata_i[2];

        end else if ( state == REQUEST_3 && cmd_i[3] ) begin
            host_word_o[addr_i[3][DW-1:DW-2]] <= wdata_i[3];
        end
    end

/*------------------------------------------------------------------------------
--  Read data logic
------------------------------------------------------------------------------*/
    // read data sequential logic
    logic [REGS_NUM-1:0][DW-1:0] rdata_mem;

    always_ff @(posedge clk_i or posedge reset_i) begin : proc_rdata_mem
        if(reset_i) begin
            rdata_mem <= '0;
        end else if ( state == REQUEST_0 && !cmd_i[0] && ack_i[addr_i[0][DW-1:DW-2]] ) begin
            rdata_mem[0] <= agent_word_i[addr_i[0][DW-1:DW-2]];

        end else if ( state == REQUEST_1 && !cmd_i[1] && ack_i[addr_i[1][DW-1:DW-2]] ) begin
            rdata_mem[1] <= agent_word_i[addr_i[1][DW-1:DW-2]];

        end else if ( state == REQUEST_2 && !cmd_i[2] && ack_i[addr_i[2][DW-1:DW-2]] ) begin
            rdata_mem[2] <= agent_word_i[addr_i[2][DW-1:DW-2]];

        end else if ( state == REQUEST_3 && !cmd_i[3] && ack_i[addr_i[3][DW-1:DW-2]] ) begin
            rdata_mem[3] <= agent_word_i[addr_i[3][DW-1:DW-2]];
        end 
    end

    // read data comb logic
    assign rdata_o[0] = ( resp_i[0] ) ? rdata_mem[0] : '0;
    assign rdata_o[1] = ( resp_i[1] ) ? rdata_mem[1] : '0;
    assign rdata_o[2] = ( resp_i[2] ) ? rdata_mem[2] : '0;
    assign rdata_o[3] = ( resp_i[3] ) ? rdata_mem[3] : '0;


endmodule : cross_bar
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