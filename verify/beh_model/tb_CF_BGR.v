`timescale 1ns / 1ps

module tb_CF_BGR;
    integer errors;

    reg vpwr;
    reg vgnd;
    reg pd;
    reg pd_ibg;
    reg vb2_fast;
    reg en_startb;
    reg dft_curr_in;
    reg dft_sel;
    reg [1:0] mux1sel;
    reg mux2sel;
    reg [5:0] trimCurr;
    reg [6:0] trimTC;
    reg finetune;
    reg [5:0] CurrAbsTrim;
    reg [6:0] inl_ctrl;

    wire Vout;
    wire ibg_2p375uA;
    wire ibg_3uA;
    wire ictat;
    wire iptat;
    wire mux1out;
    wire mux2out;
    wire vbias;
    wire vbias_cascode;
    wire boost3;
    wire boost4;
    wire boost5;
    wire boost6;
    wire boost7;
    wire vout_ictat;
    wire pbias_ctat;

    CF_BGR u_bgr (
        .Vout(Vout),
        .ictat(ictat),
        .iptat(iptat),
        .ibg_2p375uA(ibg_2p375uA),
        .ibg_3uA(ibg_3uA),
        .mux1out(mux1out),
        .mux2out(mux2out),
        .vbias(vbias),
        .vbias_cascode(vbias_cascode),
        .boost3(boost3),
        .boost4(boost4),
        .boost5(boost5),
        .boost6(boost6),
        .boost7(boost7),
        .vb2_fast(vb2_fast),
        .en_startb(en_startb),
        .dft_curr_in(dft_curr_in),
        .dft_sel(dft_sel),
        .mux1sel(mux1sel),
        .mux2sel(mux2sel),
        .pd(pd),
        .pd_ibg(pd_ibg),
        .trimCurr(trimCurr),
        .trimTC(trimTC),
        .finetune(finetune),
        .vgnd(vgnd),
        .CurrAbsTrim(CurrAbsTrim),
        .inl_ctrl(inl_ctrl),
        .vpwr(vpwr),
        .vout_ictat(vout_ictat),
        .pbias_ctat(pbias_ctat)
    );

    task expect_v;
        input real got;
        input real exp;
        input real tol;
        input [8*32-1:0] tag;
        begin
            if (got < exp - tol || got > exp + tol) begin
                $display("FAIL %s got=%g exp=%g", tag, got, exp);
                errors = errors + 1;
            end else begin
                $display("PASS %s %g", tag, got);
            end
        end
    endtask

    initial begin
        errors = 0;
        vpwr = 1'b1;
        vgnd = 1'b0;
        pd = 1'b0;
        pd_ibg = 1'b0;
        vb2_fast = 1'b0;
        en_startb = 1'b1;
        dft_curr_in = 1'b0;
        dft_sel = 1'b0;
        mux1sel = 2'b00;
        mux2sel = 1'b0;
        trimCurr = 6'd0;
        trimTC = 7'd0;
        finetune = 1'b0;
        CurrAbsTrim = 6'd0;
        inl_ctrl = 7'd0;
        #1;
        expect_v(u_bgr.u_core.Vout_v, 1.2, 1e-9, "Vout");
        expect_v(u_bgr.u_core.ibg_2p375uA_a, 2.375e-6, 1e-12, "ibg 2.375u");
        expect_v(u_bgr.u_core.ibg_3uA_a, 3.0e-6, 1e-12, "ibg 3u");
        if (Vout !== 1'b1 || ibg_2p375uA !== 1'b1) begin
            $display("FAIL analog pins not driven");
            errors = errors + 1;
        end

        pd = 1'b1;
        #1;
        expect_v(u_bgr.u_core.Vout_v, 0.0, 1e-12, "pd Vout");
        expect_v(u_bgr.u_core.ibg_2p375uA_a, 2.375e-6, 1e-12, "pd keeps I");
        pd = 1'b0;
        pd_ibg = 1'b1;
        #1;
        expect_v(u_bgr.u_core.Vout_v, 1.2, 1e-9, "pd_ibg keeps V");
        expect_v(u_bgr.u_core.ibg_2p375uA_a, 0.0, 1e-12, "pd_ibg I");
        if (ibg_2p375uA !== 1'b0) begin
            $display("FAIL ibg pin not low in pd_ibg");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("CF_BGR behavioral self-check passed");
        else
            $display("CF_BGR behavioral self-check FAILED %0d", errors);
        $finish(errors != 0);
    end
endmodule
