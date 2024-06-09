/*use "czech_labour accounts.dta", clear

keep if geo_code == "CZ"
decode nace_r2_code, gen(nace_r2_code_1)
drop nace_r2_code
rename nace_r2_code_1 nace_r2_code
keep if year == 2014 & nace_r2_code ==  "C" & geo_code == "CZ"

merge m:1 geo_code nace_r2_code using "czechia_nationalemp.dta", force

keep if year == 2014 & nace_r2_code ==  "C" & geo_code == "CZ"

keep geo_code year Share_E EMP EMPE nace_r2_code

tab nace_r2_code
tab nace_r2_code, nolabel*/


keep if year == 2014 & nace_r2_code ==  "C" & geo_code == "CZ"
//(57,303 observations deleted)

. save "czechia_nationalemp", replace
