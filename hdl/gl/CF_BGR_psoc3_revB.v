 // Verilog HDL for "CF_BGR", "CF_BGR_psoc3_revB" "behavioral"

module CF_BGR_psoc3_revB (Vout, ibg_2p375uA, mux1out, dft_sel, mux1sel, CurrAbsTrim, iptat, dft_curr_in, ibg_3uA, trimTC, finetune, ictat, boost3, mux2out, trimCurr, inl_ctrl, boost4, boost5, boost6, vb2_fast, boost7, en_startb, pd, vbias_cascode, pd_ibg, mux2sel, vbias, vgnd, vpwr, vpb, vnb,vout_ictat,pbias_ctat);
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

	assign Vout = ~pd & vpwr;
	assign ibg_2p375uA = ~pd & ~pd_ibg & vpwr;
	assign ibg_3uA = ~pd & ~pd_ibg & vpwr;
	assign iptat = ~pd & vpwr;
	assign ictat = ~pd & vpwr;
	assign mux1out = ~pd & ~pd_ibg & dft_sel & vpwr ; 
	assign mux2out = ~pd & dft_sel & mux1sel & vpwr;
	assign vbias = ~pd & vpwr;
	assign vbias_cascode = ~pd & vpwr;

endmodule
