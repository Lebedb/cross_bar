`timescale 1ns/1ns

module  tb_cross_bar

#(
    parameter                            DW            = 32                    ,
    parameter                            AW            = 32                     ,
    parameter                            REGS_NUM      = 4                 
) ;

/*------------------------------------------------------------------------------
--  SIGNALS
------------------------------------------------------------------------------*/
bit                        clk_i        = '0;
bit                        reset_i      = '1;
bit [REGS_NUM-1:0]         req_i            ;
bit [REGS_NUM-1:0]         cmd_i            ;
bit [REGS_NUM-1:0][AW-1:0] addr_i           ;
bit [REGS_NUM-1:0][DW-1:0] wdata_i          ;
bit [REGS_NUM-1:0][DW-1:0] rdata_o          ;
bit [REGS_NUM-1:0]         resp_i           ;
bit [REGS_NUM-1:0]         ack_o            ;

/*------------------------------------------------------------------------------
--  CLK
------------------------------------------------------------------------------*/
initial begin
    #10 clk_i = '0;
    forever 
    #5 clk_i = !clk_i;
end


/*------------------------------------------------------------------------------
--  TESTING
------------------------------------------------------------------------------*/
initial 
    begin
        wait_clk(3);
        reset_i = '0;
        $display("START TEST");
        wait_clk(2);

// master_0 write in slave_0
        write_data_0('h0, 'h637);
        $display("Situation 1 done");
        wait_clk(10);


// master_1 and master_2 write in slave_2
        write_data_1('h2, 'h703);
        write_data_2('h2, 'h5682);
        $display("Situation 2 done");
        wait_clk(20); 

// master_0 and master_2 write in slave_3, master_1 and master_3 write in slave_0
        write_data_0('h3, 'h1212);
        write_data_2('h3, 'h8901);
        write_data_1('h0, 'h3434);
        write_data_3('h0, 'h4672);
        $display("Situation 3 done");
        wait_clk(25);

// master_2 and master_3 write in slave_1, through the edge master_0 and master_1 write in slave_3
        write_data_2('h1, 'h329038);
        write_data_3('h1, 'h929102);
        wait_clk(1);
        write_data_0('h3, 'h181827);
        write_data_1('h3, 'h6726);
        $display("Situation 4 done");
        wait_clk(25);

// master_0 read from slave_0
        read_data_0('h0);
        $display("Situation 5 done");
        wait_clk(15);

// master_2 and master_3 read from slave_3 and slave_1
        read_data_2('h3);
        read_data_3('h1);
        $display("Situation 6 done");
        wait_clk(15);

        resp_i[0] = '1;
        resp_i[2] = '1;
        resp_i[3] = '1;
        wait_clk(1);

        resp_i[0] = '0;
        resp_i[2] = '0;
        resp_i[3] = '0;
        wait_clk(20);         

        wait_clk(20);
        $display("END TEST");
        $stop;

    end

/*------------------------------------------------------------------------------
--                                  Events
------------------------------------------------------------------------------*/
// master_0
always @(posedge clk_i) begin 
    if ( ack_o[0] ) begin 
        wait_clk(1); 
        req_i  [0] = '0;
        cmd_i  [0] = '0;
        addr_i [0] = '0;
        wdata_i[0] = '0;
    end 
end 

// master_1 
always @(posedge clk_i) begin 
    if ( ack_o[1] ) begin 
        wait_clk(1); 
        req_i  [1] = '0;
        cmd_i  [1] = '0;
        addr_i [1] = '0;
        wdata_i[1] = '0;
    end 
end 

// master_2
always @(posedge clk_i) begin 
    if ( ack_o[2] ) begin 
        wait_clk(1); 
        req_i  [2] = '0;
        cmd_i  [2] = '0;
        addr_i [2] = '0;
        wdata_i[2] = '0;
    end 
end 

// master_3
always @(posedge clk_i) begin 
    if ( ack_o[3] ) begin 
        wait_clk(1); 
        req_i  [3] = '0;
        cmd_i  [3] = '0;
        addr_i [3] = '0;
        wdata_i[3] = '0;
    end 
end 
/*------------------------------------------------------------------------------
--                                  Tasks
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
--  Write data
------------------------------------------------------------------------------*/
// master_0
task write_data_0
    (
        input [      1:0] addr,
        input [   DW-1:0] wdata
    );

        req_i  [0]            = '1;
        cmd_i  [0]            = '1;
        addr_i [0][DW-1:DW-2] = addr;
        wdata_i[0]            = wdata;

endtask : write_data_0

task read_data_0
    (
        input [1:0] addr
    );
        req_i  [0]            = '1;
        cmd_i  [0]            = '0;
        addr_i [0][DW-1:DW-2] = addr;

endtask : read_data_0

// master_1
task write_data_1
    (
        input [1:0] addr,
        input [   DW-1:0] wdata
    ); 
        req_i  [1]            = '1;
        cmd_i  [1]            = '1;
        addr_i [1][DW-1:DW-2] = addr;
        wdata_i[1]            = wdata;

endtask : write_data_1

task read_data_1
    (
        input [1:0] addr
    );
        req_i  [1]            = '1;
        cmd_i  [1]            = '0;
        addr_i [1][DW-1:DW-2] = addr;

endtask : read_data_1

// master_2
task write_data_2
    (
        input [1:0] addr,
        input [   DW-1:0] wdata
    ); 
        req_i  [2]            = '1;
        cmd_i  [2]            = '1;
        addr_i [2][DW-1:DW-2] = addr;
        wdata_i[2]            = wdata;

endtask : write_data_2

task read_data_2
    (
        input [1:0] addr
    );
        req_i  [2]            = '1;
        cmd_i  [2]            = '0;
        addr_i [2][DW-1:DW-2] = addr;

endtask : read_data_2


// master_3 
task write_data_3
    (
        input [1:0] addr,
        input [   DW-1:0] wdata
    ); 
        req_i  [3]            = '1;
        cmd_i  [3]            = '1;
        addr_i [3][DW-1:DW-2] = addr;
        wdata_i[3]            = wdata;

endtask : write_data_3

task read_data_3
    (
        input [1:0] addr
    );
        req_i  [3]            = '1;
        cmd_i  [3]            = '0;
        addr_i [3][DW-1:DW-2] = addr;

endtask : read_data_3

/*------------------------------------------------------------------------------
--  CLK TASK
------------------------------------------------------------------------------*/
task wait_clk(int i);
    repeat(i) @(posedge clk_i);
endtask : wait_clk
/*------------------------------------------------------------------------------
--  CONNECTIONS
------------------------------------------------------------------------------*/
top_cross_bar #(
    .DW      (DW      ),
    .AW      (AW      ),
    .REGS_NUM(REGS_NUM)
) top_cross_bar_inst (
    .clk_i  (clk_i  ),
    .reset_i(reset_i),
    .req_i  (req_i  ),
    .cmd_i  (cmd_i  ),
    .addr_i (addr_i ),
    .wdata_i(wdata_i),
    .resp_i (resp_i ),
    .rdata_o(rdata_o),
    .ack_o  (ack_o  )
);

endmodule // tb_cross_bar
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