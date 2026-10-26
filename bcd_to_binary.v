module bcd2bin (
    input  wire        clk,
    input  wire        rst,      
    input  wire        oper,     
    input  wire [15:0] A,        
    output reg  [15:0] rb,      
    output reg         done
);
    localparam [2:0] S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4;
    localparam [2:0] N  = 3'd4;           

    reg [2:0]  state, next_state;
    reg [15:0] ra;
    reg [15:0] re;                       
    reg [15:0] acc;
    reg [2:0]  cnt;

   
    wire x1 = oper;
    wire x2 = (cnt == 3'd1);              
    wire x3 = oper;

    wire y1 = (state == S1);
    wire y2 = (state == S2);
    wire y3 = (state == S3);
    wire y4 = (state == S4);
   
    always @(posedge clk)
        if (rst) state <= S0;
        else     state <= next_state;

    always @(*) begin
        case (state)
            S0:      next_state = x1 ? S1 : S0;
            S1:      next_state = S2;
            S2:      next_state = S3;
            S3:      next_state = x2 ? S4 : S2;
            S4:      next_state = x3 ? S4 : S0;
            default: next_state = S0;
        endcase
    end
    always @(posedge clk) begin
        if (rst) begin
            ra <= 16'd0; acc <= 16'd0; re <= 16'd1; cnt <= 3'd0;
            rb <= 16'd0; done <= 1'b0;
        end else begin
            if (state == S0) done <= 1'b0;   
            if (y1) begin                 
                ra   <= A;
                acc  <= 16'd0;
                re   <= 16'd1;
                cnt  <= N;
                done <= 1'b0;
            end
            if (y2)                       
                acc <= ra[3:0] * re + acc;
            if (y3) begin                 
                ra  <= ra >> 4;
                cnt <= cnt - 3'd1;
                re  <= re * 16'd10;
            end
            if (y4) begin                 
                rb   <= acc;
                done <= 1'b1;
            end
        end
    end
endmodule

