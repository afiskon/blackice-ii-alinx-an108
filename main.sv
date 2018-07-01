/* vim: set ai et ts=4 sw=4: */
`default_nettype none

module top (
    // 100MHz clock input
    input  CLK100MHz,
    // Global internal reset connected to RTS on ch340 and also PMOD[1]
    input greset,
    // Input lines from STM32/Done can be used to signal to Ice40 logic
    input DONE, // could be used as interupt in post programming
    input DBG1, // Could be used to select coms via STM32 or RPi etc..
    // SRAM Memory lines
    output [17:0] ADR,
    output [15:0] DAT,
    output RAMOE,
    output RAMWE,
    output RAMCS,
    output RAMLB,
    output RAMUB,
    // All PMOD outputs
    // output [55:0] PMOD,
    input [7:0] AD,
    output [7:0] DA,
    output AD_CLK,
    output DA_CLK,
    output LD1,
    output LD2,
//    input [7:0] SW,
//    output [7:0] LED,
    input B1,
    input B2
);

// SRAM signals are not use in this design, lets set them to default values
assign ADR[17:0] = {18{1'bz}};
assign DAT[15:0] = {16{1'bz}};
assign RAMOE = 1'b1;
assign RAMWE = 1'b1;
assign RAMCS = 1'b1;
assign RAMLB = 1'bz;
assign RAMUB = 1'bz;

logic CLK32MHz;

// icepll -i 100 -o 32
SB_PLL40_CORE #(
    .FEEDBACK_PATH("SIMPLE"),
    .PLLOUT_SELECT("GENCLK"),
    .DIVR(4'b0011),
    .DIVF(7'b0101000),
    .DIVQ(3'b101),
    .FILTER_RANGE(3'b010),
) uut (
    .REFERENCECLK(CLK100MHz),
    .PLLOUTCORE(CLK32MHz),
    .LOCK(LD1), // keep this!
    .RESETB(1'b1),
    .BYPASS(1'b0)
);

// ---- AD/DA test ----

assign AD_CLK = CLK32MHz;
assign DA_CLK = CLK32MHz;
assign DA = 8'b11111111 - AD;

// -------- GEN --------

/*
assign DA_CLK = CLK100MHz;

logic [7:0] counter = 255;
always @(negedge CLK100MHz)
begin
    counter <= counter - 1;
end

assign DA = counter; // ~ 390.6 kHz
*/

endmodule
