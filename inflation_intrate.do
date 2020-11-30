/******************************************************************************/
*																			   *
*				Comparing Inflation and Interest Rate Measurments  			   *
*		   	   																   *
/******************************************************************************/

	//cd	"/setpath" 
	
	
*-- 01. Interest rate measures
	
	** DGS10, DFF, T10Y2Y, T10Y3M, DFII10 yearly average 
	freduse DGS10 DFF T10Y2Y T10Y3M DFII10, clear
	gen year = year(daten)
	collapse (mean) DGS10 DFF T10Y2Y T10Y3M DFII10, by(year)
		
	label var DGS10    "DGS10"
	label var DFF      "DFF"	
	label var T10Y2Y   "T10Y2Y"
	label var T10Y3M   "T10Y3M"
	label var DFII10   "DFII10"
	
	** Figure 
	#delimit ;
	line DGS10  year || line DFF    year || line T10Y2Y year ||
	line T10Y3M year || line DFII10 year,
	title("Interest rate comparison", size(medium)) legend(size(small))
	scheme(s1color) leg(c(4) size(small)) xtitle("") xsc(range(1950 2020)) xlab(1950(10)2020)
	name(a1, replace);
	#delimit cr 
			

*-- 02. Inflation measures  
		
	** CPIAUCSL, PPIACO, A191RI1Q225SBEA yearly average 
	freduse CPIAUCNS CPIAUCSL FPCPITOTLZGUSA PPIACO A191RI1Q225SBEA, clear
	gen year = year(daten)
	keep if year >= 1950
	
	collapse (mean) CPIAUCNS CPIAUCSL FPCPITOTLZGUSA PPIACO A191RI1Q225SBEA, by(year)
	gen CPI_sa      		= 100*(CPIAUCSL[_n] / CPIAUCSL[_n-1] - 1)
	gen CPI_nsa     		= 100*(CPIAUCNS[_n] / CPIAUCNS[_n-1] - 1)
	gen PPIACO1     		= 100*(PPIACO[_n]   / PPIACO[_n-1]   - 1)

	drop CPIAUCSL PPIACO
	
	label var CPI_sa   		  "CPIAUCSL"
	label var CPI_nsa         "CPIAUCNS"
	label var FPCPITOTLZGUSA  "FPCPITOTLZGUSA"
	label var PPIACO 		  "PPIACO"
	label var A191RI1Q225SBEA "A191RI1Q225SBEA"
	
	** Figure 	
	#delimit ;
	line CPI_sa year  || line CPI_nsa year || line FPCPITOTLZGUSA year ||
	line PPIACO year  || line A191RI1Q225SBEA year,
	title("Inflation comparison", size(medium)) legend(size(small))
	scheme(s1color) leg(c(3) size(small)) xtitle("") xsc(range(1950 2020)) xlab(1950(10)2020)
	name(a2, replace);
	#delimit cr 
	
	
*-- 03. Figure 	
	#delimit ; 
	gr combine a1 a2, c(1) altshrink 
	xsize(8) ysize(11) scheme(s1mono)
	note("Source: FRED");
	#delimit cr
	graph export "comp.png", as(png) replace
