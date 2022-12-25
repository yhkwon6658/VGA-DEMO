// SPEC - about 60hz SYNC Genrator
// PIXELCLK = 25Mhz
// VGA_HS = 31.25khz
// VGA_VS = 59.53hz
module VGA_SYNC
(
    // SYSTEM I/O
    input PIXELCLK,
    input i_rstn,
    output reg VGA_HS,
    output reg VGA_VS,
    output reg [9:0] H_cnt,
    output reg [9:0] V_cnt,
    output o_w_en
);
// Horizontal counter
always @(posedge PIXELCLK) begin
    if(!i_rstn) begin
        H_cnt <= 0;
    end
    else begin
        if(H_cnt == 799) H_cnt <= 0;
        else H_cnt <= H_cnt + 1;
    end
end

// VGA_HS
always @(posedge PIXELCLK) begin
    if(!i_rstn) VGA_HS <= 1;
    else begin
        if(H_cnt >= 703 && H_cnt <= 799) VGA_HS <= 0;
        else VGA_HS <= 1;
    end
end

// Vertical counter
always @(posedge VGA_HS) begin
    if(!i_rstn) V_cnt <= 0;
    else begin
        if(V_cnt == 524) V_cnt <= 0;
        else V_cnt <= V_cnt + 1;
    end
end

// VGA_VS
always @(posedge VGA_HS) begin
    if(!i_rstn) VGA_VS <= 1;
    else begin
        if(V_cnt >= 522 && V_cnt <= 524) VGA_VS <= 0;
        else VGA_VS <= 1;
    end
end

assign o_w_en = ~VGA_HS;

endmodule