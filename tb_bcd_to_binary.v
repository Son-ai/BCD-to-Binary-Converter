module tb_bcd2bin;
    reg         clk, rst, oper;
    reg  [15:0] A;
    wire [15:0] rb;
    wire        done;

    bcd2bin dut (.clk(clk), .rst(rst), .oper(oper), .A(A), .rb(rb), .done(done));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1; oper = 0; A = 16'h0000;
        #20 rst = 0;

        
        A = 16'h1234;
        #10 oper = 1;
        #150;
        oper = 0;
        #50;

        
        A = 16'h0509;
        #10 oper = 1;
        #150;
        oper = 0;
        #50;

        
        A = 16'h9999;
        #10 oper = 1;
        #150;
        oper = 0;
        #50;

     $finish;
    end
endmodule