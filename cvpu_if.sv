interface cvpu_if;
	logic s_clk;
	logic s_rst;
        logic s_f_en;
        logic s_m_en;
	logic [1:0] s_mat;
        logic [1:0] s_fil;
        

	logic [6:0] s_out;
	logic s_eno;
	
endinterface: cvpu_if