cd "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\data"

pwd



********************************************************************
///////////////// Senegal //////////////////////////
********************************************************************
use "senegal_manu.dta", clear

//gen log_va = log(VA_l1)

//tab panel_firms

/*egen newvar = group(a4a a2 a6a)
tab newvar
egen newvar1 = group(a4a a2)
tab newvar1*/

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)

//////////// value added per worker /////////////////////
// no interaction
svy, subpop(manufacturing): regress log_va i.year i.idPANEL2007 
eststo model1
// large firm
svy, subpop(manufacturing): regress log_va year##large_firm i.idPANEL2007 
eststo model2
// exporter
svy, subpop(manufacturing): regress log_va year##exporter i.idPANEL2007 
eststo model3
// foreign
svy, subpop(manufacturing): regress log_va year##foreign i.idPANEL2007
eststo model4
// all
svy, subpop(manufacturing): regress log_va year##large_firm year##exporter year##foreign i.idPANEL2007 
eststo model5

esttab model* using "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\tables\senegal_panelgrowth.tex", replace keep(2014.year 2014.year#1.large_firm 2014.year#1.exporter 2014.year#1.foreign) stats(N r2, label ("Observations" "R-Squared") fmt(%9.0f %4.3f)) ///
coeflabels(2014.year "Year" 2014.year#1.large_firm "Year x Large Firm" 2014.year#1.exporter "Year x Exporter" 2014.year#1.foreign "Year x Foreign") ///
se mtitles("Basic Model" "Large Firm" "Exporter" "Foreign" "All") ///
nonotes title("Growth in Value Added per Worker")

//etable, append column(index) showstars showstarsnote keep(year##large_firm year##exporter year##foreign) title(Senegal firm-level growth in value added per worker 2007 - 2014) note(As the World Enterprise Surveys data for Senegal is limited, these estimates reflect the direct growth between the two time points and do not encompass growth within these periods.)
 

 
//////////////// employment levels //////////////////////
// no interaction
svy, subpop(manufacturing): regress l1 i.year i.idPANEL2007
eststo model1
// large firm
svy, subpop(manufacturing): regress l1 year##large_firm i.idPANEL2007
eststo model2
// exporter
svy, subpop(manufacturing): regress l1 year##exporter i.idPANEL2007 
eststo model3
// foreign
svy, subpop(manufacturing): regress l1 year##foreign i.idPANEL2007 
eststo model4
// all
svy, subpop(manufacturing): regress l1 year##large_firm year##exporter year##foreign i.idPANEL2007 
eststo model5


esttab model* using "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\tables\senegal_panelgrowth.tex", append keep(2014.year 2014.year#1.large_firm 2014.year#1.exporter 2014.year#1.foreign) stats(N r2, label ("Observations" "R-Squared") fmt(%9.0f %4.3f)) ///
coeflabels(2014.year "Year" 2014.year#1.large_firm "Year x Large Firm" 2014.year#1.exporter "Year x Exporter" 2014.year#1.foreign "Year x Foreign") ///
se mtitles("Basic Model" "Large Firm" "Exporter" "Foreign" "All") ///
addnotes("As the World Enterprise Surveys data for Senegal is limited," "these estimates reflect the direct growth between the two time points" "and do not encompass growth within these periods.") ///
title("Growth in Employment")




*********************************************************************
///////////////// Employment and Value Added Levels
// no interaction
svy, subpop(manufacturing): regress log_va year large_firm exporter foreign i.a3a
eststo model1
// large firm
svy, subpop(manufacturing): regress l1 year large_firm exporter foreign i.a3a
eststo model2


esttab model* using "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\tables\senegal_panellevels.tex", append keep(large_firm exporter foreign _cons) stats(N r2, label ("Observations" "R-Squared") fmt(%9.0f %4.3f)) ///
coeflabels(large_firm "Large Firm" exporter "Exporter" foreign "Foreign" _cons "Constant") ///
se mtitles("Value Added" "Employment") ///
title("Growth in Employment")




********************************************************************
///////////////// South Africa //////////////////////////
********************************************************************
use "sa_manu.dta", clear

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)

egen newvar = group(a4a a2)

// cannot include firm level fixed effects due to data constraints
// of there not being enough panel firms
//////////// value added per worker /////////////////////
// large firm
svy, subpop(manufacturing): regress VA_l1 year##large_firm i.newvar
// exporter
svy, subpop(manufacturing): regress VA_l1 year##exporter 
// foreign
svy, subpop(manufacturing): regress VA_l1 year##foreign 
// all
svy, subpop(manufacturing): regress VA_l1 year##large_firm year##exporter year##foreign i.newvar

//////////////// employment levels //////////////////////
// large firm
svy, subpop(manufacturing): regress l1 year##large_firm i.newvar
// exporter
svy, subpop(manufacturing): regress l1 year##exporter 
// foreign
svy, subpop(manufacturing): regress l1 year##foreign 
// all
svy, subpop(manufacturing): regress l1 year##large_firm year##exporter year##foreign i.newvar

// WITHOUT SURVEY DESIGN: DROPS A BUNCH OF OBS
keep if manufacturing == 1

reghdfe VA_l1 year##large_firm [pw = wt], absorb(panelid) vce(cluster strata_all)

reghdfe l1 year##large_firm [pw = wt], absorb(panelid) vce(cluster strata_all)



********************************************************************
///////////////// Nigeria //////////////////////////
********************************************************************
use "nigeria_manu.dta", clear

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)

egen newvar = group(a4a a2)

tab a2

// cannot include firm level fixed effects due to data constraints
// of there not being enough panel firms
//////////// value added per worker /////////////////////
// large firm
svy, subpop(manufacturing): regress VA_l1 year##large_firm i.a3a
// exporter
svy, subpop(manufacturing): regress VA_l1 year##exporter 
// foreign
svy, subpop(manufacturing): regress VA_l1 year##foreign 
// all
svy, subpop(manufacturing): regress VA_l1 year##large_firm year##exporter year##foreign i.a3a

//////////////// employment levels //////////////////////
// large firm
svy, subpop(manufacturing): regress l1 year##large_firm i.a3a
// exporter
svy, subpop(manufacturing): regress l1 year##exporter 
// foreign
svy, subpop(manufacturing): regress l1 year##foreign 
// all
svy, subpop(manufacturing): regress l1 year##large_firm year##exporter year##foreign 

// WITHOUT SURVEY DESIGN
keep if manufacturing == 1

reghdfe VA_l1 year##large_firm [pw = wt], absorb(panelid) vce(cluster strata)

reghdfe l1 year##large_firm [pw = wt], absorb(panelid) vce(cluster strata_all)




********************************************************************
///////////////// Capital - Labor Ratio Senegal ////////////////////
********************************************************************
use "senegal_manu.dta", clear

//keep if year == 2014

replace n7a = . if n7a < 0
replace n7b = . if n7b < 0
//tab l1

// based on World Bank GDP Deflator, 2014 is the base year 
// since I'm directly comparing 2014, will just leave it in 2014 prices then
// I'm not doing a range of years
// $1 = 493.757 SEN
// 1 SEN = 0.002025288

// generating exchange rate and PPP price indixes for machinery and consturction
gen exrate_2014 = 0.002025288
gen machinery_pi = 126.9
gen construction_pi = 68.8

keep year idstd l1 n7a n7b wt strata deflator_usd_adjust_d2 exrate_d2 manufacturing exporter foreign large_firm exrate_2014 machinery_pi construction_pi strata_all

// converting to 2014 dollar
gen n7a_dollar = n7a * exrate_2014
gen n7b_dollar = n7b * exrate_2014


// adjusting for PPP
gen n7a_PPP = n7a_dollar/(machinery_pi/100)
gen n7b_PPP = n7b_dollar/(construction_pi/100)

// Total Capital: PPP adjusted machinery and Buildings
gen total_capital = n7a_PPP + n7b_PPP

// only using labor which have reported capital stock
gen l1_adjusted = l1
replace l1_adjusted = . if n7a_PPP == . | n7b_PPP == .


// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)

// calculating total capital
svy, subpop(manufacturing): total total_capital, over(year large_firm foreign exporter)
mat list e(b)
scalar tot_cap = e(b)[1,9] + e(b)[1,10] + e(b)[1,11] + e(b)[1,12] + e(b)[1,13] + e(b)[1,14] + e(b)[1,15] + e(b)[1,16]
scalar large_cap = e(b)[1,13] + e(b)[1,14] + e(b)[1,15] + e(b)[1,16]
scalar foreign_cap = e(b)[1,11] + e(b)[1,12] + e(b)[1,15] + e(b)[1,16]
scalar exporter_cap = e(b)[1,10] + e(b)[1,12] + e(b)[1,14] + e(b)[1,16]


total total_capital
// 107,000,000

svy, subpop(manufacturing): total l1_adjusted, over(year large_firm foreign exporter)
mat list e(b)
scalar tot_lab = e(b)[1,9] + e(b)[1,10] + e(b)[1,11] + e(b)[1,12] + e(b)[1,13] + e(b)[1,14] + e(b)[1,15] + e(b)[1,16]
scalar large_lab = e(b)[1,13] + e(b)[1,14] + e(b)[1,15] + e(b)[1,16]
scalar foreign_lab = e(b)[1,11] + e(b)[1,12] + e(b)[1,15] + e(b)[1,16]
scalar exporter_lab = e(b)[1,10] + e(b)[1,12] + e(b)[1,14] + e(b)[1,16]
// 10913.801

// capital to labor ratio
scalar tot_cap_lab = tot_cap/tot_lab
scalar large_cap_lab = large_cap/large_lab
scalar foreign_cap_lab = foreign_cap/foreign_lab
scalar exporter_cap_lab = exporter_cap/exporter_lab

di tot_cap_lab 
di large_cap_lab 
di foreign_cap_lab 
di exporter_cap_lab

// Czech capital to labor ratio from cap
scalar czech_cap_lab = 88536.16028

// proportion of czech lab capital
scalar tot_prop = (tot_cap_lab/czech_cap_lab) * 100
scalar large_prop = (large_cap_lab/czech_cap_lab) * 100
scalar foreign_prop = (foreign_cap_lab/czech_cap_lab) * 100
scalar exporter_prop = (exporter_cap_lab/czech_cap_lab) * 100


di tot_prop 
di large_prop 
di foreign_prop 
di exporter_prop

// GDP comparison: Source World Bank PPP International $
scalar gdp_prop = (2872.1/32502.5) * 100

matrix sen_czh = gdp_prop, tot_prop, large_prop, exporter_prop, foreign_prop

// exporting as tex file
esttab matrix(sen_czh, fmt(%-04.3f)) using sen_czh.tex, replace

********************************************************************
///////////////// Kenya //////////////////////////
********************************************************************
/*use "kenya_manu.dta", clear
drop _merge whatevs large

drop if year == 2007

/*preserve
	sort panelid year
	bysort panelid year: gen whatevs = 1 if l1[1] > 50

	keep if whatevs == 1
	duplicates drop panelid, force
	keep panelid whatevs
	tempfile whatevs
	save `whatevs'
restore*/


preserve
	sort panelid year
	duplicates drop panelid, force
	gen whatevs = 0
	replace whatevs = 1 if l1 > 50
	tempfile whatevs
	save `whatevs'
restore

merge m:1 panelid using `whatevs'

tab panel_firms
tab large_firm
tab exporter
tab foreign

gen large = 0
replace large = 1 if l1 > 50

tab large

tab whatevs

gen check = 0
replace check = 1 if whatevs == large_firm
order panelid year check large whatevs
drop check
keep if check == 0

tab check
order idstd panelid year panel whatevs large check



tab large_firm

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)

//////////// value added per worker /////////////////////
// large firm
svy, subpop(manufacturing): regress VA_l1 year##large_firm 
// exporter
svy, subpop(manufacturing): regress VA_l1 year##exporter i.panelid
// foreign
svy, subpop(manufacturing): regress VA_l1 year##foreign i.panelid
// all
svy, subpop(manufacturing): regress VA_l1 year##whatevs year##exporter year##foreign i.panelid

//////////////// employment levels //////////////////////
// large firm
svy, subpop(manufacturing): regress l1 year##large i.panelid
// exporter
svy, subpop(manufacturing): regress l1 year##exporter i.panelid
// foreign
svy, subpop(manufacturing): regress l1 year##foreign i.idPANEL2007
// all
svy, subpop(manufacturing): regress l1 year##large_firm year##exporter year##foreign i.idPANEL2007


