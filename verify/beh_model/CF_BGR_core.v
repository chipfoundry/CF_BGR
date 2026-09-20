`timescale 1ns / 1ps

// Ideal functional model of analog leaf CF_BGR_core.
// Drop this file in place of hdl/gl/CF_BGR_core.v for simulation.
// Do not add it to OpenLane VERILOG_FILES.
//
// Analog values are Verilog real backdoors (1-bit pins stay digital):
//   Vout_v, ibg_2p375uA_a, ibg_3uA_a
//
// Assumed protocol (ideal, not silicon-verified):
//   * pd high → voltage path off, Vout_v = 0
//   * pd_ibg high → current path off, bias currents = 0
//   * else Vout_v = 1.2 V, ibg_2p375uA_a = 2.375 µA, ibg_3uA_a = 3 µA
// Trim, mux, DFT, INL, and startup boosts are not modeled.

module CF_BGR_core (
    Vout,
    ictat,
    iptat,
    ibg_2p375uA,
    ibg_3uA,
    mux1out,
    mux2out,
    vbias,
    vbias_cascode,
    boost3,
    boost4,
    boost5,
    boost6,
    boost7,
    vb2_fast,
    en_startb,
    dft_curr_in,
    dft_sel,
    mux1sel,
    mux2sel,
    pd,
    pd_ibg,
    trimCurr,
    trimTC,
    finetune,
    vgnd,
    CurrAbsTrim,
    inl_ctrl,
    vnb,
    vpb,
    vpwr,
    vout_ictat,
    pbias_ctat
);
    output Vout;
    output ictat;
    output iptat;
    output ibg_2p375uA;
    output ibg_3uA;
    output mux1out;
    output mux2out;
    output vbias;
    output vbias_cascode;
    output boost3;
    output boost4;
    output boost5;
    output boost6;
    output boost7;
    input vb2_fast;
    input en_startb;
    input dft_curr_in;
    input dft_sel;
    input [1:0] mux1sel;
    input mux2sel;
    input pd;
    input pd_ibg;
    input [5:0] trimCurr;
    input [6:0] trimTC;
    input finetune;
    input vgnd;
    input [5:0] CurrAbsTrim;
    input [6:0] inl_ctrl;
    input vnb;
    input vpb;
    input vpwr;
    output vout_ictat;
    output pbias_ctat;

    localparam real VBG = 1.2;
    localparam real I_2P375U = 2.375e-6;
    localparam real I_3U = 3.0e-6;
    localparam real V_PRESENT = 0.05;
    localparam real I_PRESENT = 1.0e-9;

    real Vout_v;
    real ibg_2p375uA_a;
    real ibg_3uA_a;

    initial begin
        Vout_v = 0.0;
        ibg_2p375uA_a = 0.0;
        ibg_3uA_a = 0.0;
    end

    always @(*) begin
        Vout_v = pd ? 0.0 : VBG;
        if (pd_ibg) begin
            ibg_2p375uA_a = 0.0;
            ibg_3uA_a = 0.0;
        end else begin
            ibg_2p375uA_a = I_2P375U;
            ibg_3uA_a = I_3U;
        end
    end

    assign Vout = (Vout_v > V_PRESENT) ? 1'b1 : 1'b0;
    assign ibg_2p375uA = (ibg_2p375uA_a > I_PRESENT) ? 1'b1 : 1'b0;
    assign ibg_3uA = (ibg_3uA_a > I_PRESENT) ? 1'b1 : 1'b0;
    assign ictat = 1'b0;
    assign iptat = 1'b0;
    assign mux1out = 1'b0;
    assign mux2out = 1'b0;
    assign vbias = 1'b0;
    assign vbias_cascode = 1'b0;
    assign boost3 = 1'b0;
    assign boost4 = 1'b0;
    assign boost5 = 1'b0;
    assign boost6 = 1'b0;
    assign boost7 = 1'b0;
    assign vout_ictat = 1'b0;
    assign pbias_ctat = 1'b0;
endmodule
