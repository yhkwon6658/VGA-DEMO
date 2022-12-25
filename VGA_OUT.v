module VGA_OUT (
    input PIXELCLK,
    input i_w_en,
    input [7:0] i_data,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output VGA_CLK,
    output VGA_BLANK
);
assign VGA_R = (~i_w_en) ? i_data : 0;
assign VGA_G = (~i_w_en) ? i_data : 0;
assign VGA_B = (~i_w_en) ? i_data : 0;
assign VGA_CLK = PIXELCLK; // Must be PIXELCLK
assign VGA_BLANK = 1; // Must be high

endmodule