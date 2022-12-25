module VGA_DEMO #(
    parameter ADDR = 19200, // 160x120
    parameter INFILE = "namu.hex"
) (
    // SYSTEM I/O
    input i_clk,
    input i_rstn,
    output VGA_HS,
    output VGA_VS,
    output VGA_CLK,
    output VGA_BLANK,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B
);
// memory initiailize
reg [7:0] mem [0:ADDR-1];
initial begin
    $readmemh(INFILE,mem,0,ADDR-1); // hex : $readmemh, binary : $readmemb
end
// reg & wire
wire PIXELCLK;
wire [9:0] H_cnt;
wire [9:0] V_cnt;
wire [7:0] x_addr;
wire [7:0] y_addr;
reg [19:0] addr;
reg [7:0] ram_data;

// Inter Connect
HALFCLOCK HALFCLOCK
(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .o_clk(PIXELCLK)
); // 25Mhz generation

VGA_SYNC VGA_SYNC
(
    .o_w_en(), // RAM write enable signal
    .PIXELCLK(PIXELCLK),
    .i_rstn(i_rstn),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .H_cnt(H_cnt),
    .V_cnt(V_cnt)
); // 640x480 VGA sync generation

VGA_OUT VGA_OUT
(
    .i_w_en(), // RAM write enable signal
    .PIXELCLK(PIXELCLK),
    .i_data(ram_data),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_CLK(VGA_CLK),
    .VGA_BLANK(VGA_BLANK)
); // VGA output

// Address Generation
assign x_addr = H_cnt >> 2;
assign y_addr = V_cnt >> 2;

always @(posedge PIXELCLK) begin
    if(!i_rstn) addr <= 0;
    else if(y_addr >= 0 && y_addr <= 119) begin
        if(x_addr >= 0 && x_addr <= 159) begin
            addr <= 160*y_addr+x_addr;
        end
        else addr <= 0;
    end
    else addr <= 0;
end

// RAM Data
always @(posedge PIXELCLK) begin
    if(!i_rstn) ram_data <= 0;
    else if(VGA_HS) ram_data <= mem[addr];
    else ram_data <= 0;
end

endmodule