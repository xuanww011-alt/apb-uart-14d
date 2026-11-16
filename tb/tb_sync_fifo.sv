// Day 3/6 目标测试：先 READ SPEC 再写 rtl/sync_fifo.sv。
// 注意：初始模板没有实现 FIFO，这个测试初始失败是预期行为。
`timescale 1ns/1ps
module tb_sync_fifo;
    parameter integer DEPTH = 4;
    localparam integer COUNT_W = $clog2(DEPTH+1);
    reg clk=1'b0;
    always #5 clk=~clk;
    reg rst_n;
    reg wr_en;
    reg [7:0] wr_data;
    wire full;
    reg rd_en;
    wire [7:0] rd_data;
    wire empty;
    wire [COUNT_W-1:0] level;
    reg [7:0] sampled;
    integer i;

    sync_fifo #(.DATA_WIDTH(8),.DEPTH(DEPTH)) dut (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .wr_data(wr_data), .full(full),
        .rd_en(rd_en), .rd_data(rd_data), .empty(empty), .level(level)
    );

    task automatic transact(
        input reg w,
        input reg [7:0] data,
        input reg r,
        output reg [7:0] before_read
    );
        begin
            @(negedge clk);
            wr_en = w; wr_data = data; rd_en = r;
            #1; before_read = rd_data; // FWFT：读之前采样队首
            @(posedge clk);
            #1; wr_en = 1'b0; rd_en = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("build/tb_sync_fifo.vcd");
        $dumpvars(0, tb_sync_fifo);
        rst_n=1'b0; wr_en=1'b0; rd_en=1'b0; wr_data=8'h00;
        repeat(2) @(posedge clk);
        @(negedge clk); rst_n=1'b1;
        #1;
        if (empty !== 1'b1 || full !== 1'b0 || level !== 0)
            $fatal(1, "FIFO reset flags failed");

        // Fill until full; FWFT head remains first accepted byte.
        for (i=0; i<DEPTH; i=i+1) begin
            transact(1'b1, (8'h20+i), 1'b0, sampled);
            if (level !== (i+1)) $fatal(1, "FIFO level after write %0d", i);
        end
        if (full !== 1'b1 || empty !== 1'b0)
            $fatal(1, "FIFO full flags failed");
        if (rd_data !== 8'h20) $fatal(1, "FIFO FWFT head failed");

        // Full: pure write MUST be ignored.
        transact(1'b1, 8'hEE, 1'b0, sampled);
        if (level !== DEPTH || rd_data !== 8'h20)
            $fatal(1, "FIFO overflow guard failed");

        // Full: simultaneous read and write are BOTH accepted.
        transact(1'b1, 8'hA5, 1'b1, sampled);
        if (sampled !== 8'h20 || level !== DEPTH || full !== 1'b1)
            $fatal(1, "FIFO full simultaneous read-write failed");

        // Drain remaining original items in order.
        for (i=1; i<DEPTH; i=i+1) begin
            transact(1'b0, 8'h00, 1'b1, sampled);
            if (sampled !== (8'h20+i))
                $fatal(1, "FIFO order failed at index %0d, got %h", i, sampled);
        end
        transact(1'b0, 8'h00, 1'b1, sampled);
        if (sampled !== 8'hA5 || empty !== 1'b1 || level !== 0)
            $fatal(1, "FIFO final byte/empty failed");

        // Empty: simultaneous write+read accepts ONLY the write (no bypass).
        transact(1'b1, 8'h77, 1'b1, sampled);
        if (sampled !== 8'h00 || level !== 1 || rd_data !== 8'h77)
            $fatal(1, "FIFO empty simultaneous read-write failed");
        transact(1'b0, 8'h00, 1'b1, sampled);
        if (sampled !== 8'h77 || empty !== 1'b1)
            $fatal(1, "FIFO empty readback failed");

        $display("[PASS] sync_fifo, DEPTH=%0d: fill, guards, FWFT, simultaneous, wrap", DEPTH);
        $finish;
    end
endmodule
