cd "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\data"

pwd



********************************************************************
///////////////// Senegal //////////////////////////
********************************************************************
use "senegal_manu.dta", clear

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


// Foreign Owned Firms OLS without fixed effects
// foreign
svy, subpop(manufacturing): regress log_va year##foreign 


// all
svy, subpop(manufacturing): regress log_va year##large_firm year##exporter i.idPANEL2007 
eststo model5


// out of 476 panel firms, only 13 are foreign