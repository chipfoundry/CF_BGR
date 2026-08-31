// Verilog HDL for "s8bg", "s8bg_top" "behavioral"

module s8bg_top_psoc3_revA (iptat, ictat, Vout, ibg_2p375uA, ibg_3uA, mux1out, mux2out, vbias, vbias_cascode,inl_ctrl,CurrAbsTrim, dft_curr_in, dft_sel, mux1sel, mux2sel, pd, pd_ibg, trimCurr, 
           trimTC, vgnd, vnb, vpb, vpwr);
    output Vout;
		output ictat;
		output iptat;
    output ibg_2p375uA;
    output ibg_3uA;
    output mux1out;
    output mux2out;
    output vbias;
    output vbias_cascode;
		input dft_curr_in;
    input dft_sel;
    input [1:0] mux1sel;
    input mux2sel;
    input pd;
    input pd_ibg;
    input [5:0] trimCurr;
    input [6:0] trimTC;
    input vgnd;
    input [5:0] CurrAbsTrim;	
    input [1:0] inl_ctrl;	
    input vnb;
    input vpb;
    input vpwr;

		reg Vout_reg;
		reg ibg_2p5uA_reg;
		reg ibg_10uA_reg;
		reg iptat_reg;
		reg ictat_reg;
		reg mux1out_reg;
		reg mux2out_reg;
		reg vbias_reg;
		reg vbias_cascode_reg; 

		initial begin
			Vout_reg = 1'b0;
			ibg_2p5uA_reg = 1'b0;
			ibg_10uA_reg = 1'b0;
			mux1out_reg = 1'b0;
			mux2out_reg = 1'b0;
			vbias_reg = 1'b1;
			vbias_cascode_reg = 1'b0;
			iptat_reg = 1'b0;
			ictat_reg = 1'b0;
		end

		always @ ( pd or pd_ibg ) begin
				if ( pd == 1'b1 ) begin
					Vout_reg = 1'b0;
		      ibg_2p5uA_reg = 1'b0;
    		  ibg_10uA_reg = 1'b0;
    		  mux1out_reg = 1'b0;
    		  mux2out_reg = 1'b0;
    		  vbias_reg = 1'b1;
     			vbias_cascode_reg = 1'b1;
				end
				else begin
					Vout_reg = 1'b1;
					if( pd_ibg == 1'b1) begin
						ibg_2p5uA_reg = 1'b0;
						ibg_10uA_reg = 1'b0;
						vbias_reg = 1'b1;
						vbias_cascode_reg = 1'b1;
					end
					else begin
						ibg_2p5uA_reg = 1'b1;
            ibg_10uA_reg = 1'b1;
            vbias_reg = 1'b0;
            vbias_cascode_reg = 1'b0;
					end
				end
		end	
			
		always @ (dft_sel or mux1sel or mux2sel) begin
				if (dft_sel == 1'b1 & pd == 1'b0) begin
						if ( pd_ibg == 1'b0 ) begin
								mux1out_reg = 1'b1;
						end
						else begin 
								mux1out_reg = 1'b0;
						end
						if (mux1sel == 1'b0) begin
								mux2out_reg = 1'b1;
						end
						else begin 
								mux2out_reg = 1'b0;
						end
				end
				if( pd == 1'b1 ) begin
					mux1out_reg = 1'b0;
					mux2out_reg = 1'b0;
				end
			end	

	assign Vout = Vout_reg;
	assign ibg_2p375uA = ibg_2p5uA_reg;
	assign ibg_3uA = ibg_10uA_reg;
	assign mux1out = mux1out_reg;
  assign mux2out = mux2out_reg;
  assign vbias = vbias_reg;
  assign vbias_cascode =  vbias_cascode_reg;   
	assign ictat = ictat_reg;
	assign iptat = iptat_reg;

	// Timing Check
  `ifdef notimingcheck
      // do no timing checks
  `else
      // do no timing checks
	`endif	

endmodule
