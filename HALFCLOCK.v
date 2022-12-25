module HALFCLOCK (
    input i_clk,
    input i_rstn,
    output reg o_clk
);
always @(posedge i_clk) begin
    if(!i_rstn) o_clk <= 1;
    else o_clk <= ~o_clk;
end
    
endmodule