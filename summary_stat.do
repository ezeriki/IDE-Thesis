cd "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\data"

pwd



///////// Senegal ////////////
use "senegal_manu.dta", clear

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


unab interest_var : l1 VA_l1 large_firm exporter foreign 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat senegal_stat = J(`var_count',4,.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x'
	matrix A =r(table)
	di  e(N_sub)
	matrix A_coef = A[1..2, 1]
	matrix A_trans = A_coef'
	matrix A_stat = A_trans, e(N_sub), e(N_subpop)
	matlist A_stat
	matrix senegal_stat[`i',1] = A_stat
	local ++i
	 }
	 
matlist senegal_stat


//////////// South Africa ///////////////////
use "sa_manu.dta", clear

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


unab interest_var : l1 VA_l1 large_firm exporter foreign 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat sa_stat = J(`var_count',4,.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x'
	matrix A =r(table)
	di  e(N_sub)
	matrix A_coef = A[1..2, 1]
	matrix A_trans = A_coef'
	matrix A_stat = A_trans, e(N_sub), e(N_subpop)
	matlist A_stat
	matrix sa_stat[`i',1] = A_stat
	local ++i
	 }
	 
matlist sa_stat



//////////// Nigeria ///////////////////
use "nigeria_manu.dta", clear

// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


unab interest_var : l1 VA_l1 large_firm exporter foreign 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat nigeria_stat = J(`var_count',4,.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x'
	matrix A =r(table)
	di  e(N_sub)
	matrix A_coef = A[1..2, 1]
	matrix A_trans = A_coef'
	matrix A_stat = A_trans, e(N_sub), e(N_subpop)
	matlist A_stat
	matrix nigeria_stat[`i',1] = A_stat
	local ++i
	 }
	 
matlist nigeria_stat


////////// Combining all my summary stat from each country ////
matrix summary_stat = senegal_stat \ sa_stat \ nigeria_stat


// saving my f pvalue vectors
svmat double summary_stat, name(summary_stat)
keep summary_stat1 summary_stat2 summary_stat3 summary_stat4
drop if summary_stat1 == . | summary_stat2 == . | summary_stat3 == . | summary_stat4 == . 
save summary_stat, replace











*************************************************
//////////////// Exit & Entry //////////////////
*************************************************
//////////////// Senegal
//// strict Exit
use "senegal_churn.dta", clear
// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


tab firm_churn, gen(exit)

replace exit1 = exit1 * 100
replace exit2 = exit2 * 100
replace exit3 = exit3 * 100

// Doing all groups (2007)
unab interest_var : exit2 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat sen_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,1]
	matrix sen_exit[1,`i'] = A
	local ++i
	 }
	 

// Doing all groups (2014)
unab interest_var : exit1 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
// mat weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,2]
	matrix sen_exit = sen_exit, A
	local ++i
	 }

matlist sen_exit



//////////////// South Africa
//// strict Exit
use "sa_churn.dta", clear
// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


tab firm_churn, gen(exit)

replace exit1 = exit1 * 100
replace exit2 = exit2 * 100
replace exit3 = exit3 * 100

// Doing all groups (2007)
unab interest_var : exit2 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat sa_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,1]
	matrix sa_exit[1,`i'] = A
	local ++i
	 }
	 

// Doing all groups (2014)
unab interest_var : exit1 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
// mat weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,2]
	matrix sa_exit = sa_exit, A
	local ++i
	 }

matlist sa_exit


//////////////// Nigeria
//// strict Exit
use "nigeria_churn.dta", clear
// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


tab firm_churn, gen(exit)

replace exit1 = exit1 * 100
replace exit2 = exit2 * 100
replace exit3 = exit3 * 100

// Doing all groups (2007)
unab interest_var : exit2 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat naij_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,1]
	matrix naij_exit[1,`i'] = A
	local ++i
	 }
	 

// Doing all groups (2014)
unab interest_var : exit1 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
// mat weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,2]
	matrix naij_exit = naij_exit, A
	local ++i
	 }

matlist naij_exit


// combining all the exit means together
////////// Combining all my summary stat from each country ////
matrix summary_strictexit = sen_exit \ sa_exit \ naij_exit


// saving my f pvalue vectors
svmat double summary_strictexit, name(summary_strictexit)
keep summary_strictexit1 summary_strictexit2 summary_strictexit3 summary_strictexit4
drop if summary_strictexit1 == . | summary_strictexit2 == . | summary_strictexit3 == . | summary_strictexit4 == . 
save summary_strictexit, replace






//////////////// Senegal
//// Weak Exit
use "senegal_churnweak.dta", clear
// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


tab firm_churn, gen(exit)

replace exit1 = exit1 * 100
replace exit2 = exit2 * 100
replace exit3 = exit3 * 100

// Doing all groups (2007)
unab interest_var : exit2 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat sen_weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,1]
	matrix sen_weak_exit[1,`i'] = A
	local ++i
	 }
	 

// Doing all groups (2014)
unab interest_var : exit1 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
// mat weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,2]
	matrix sen_weak_exit = sen_weak_exit, A
	local ++i
	 }

matlist sen_weak_exit



//////////////// South Africa
//// Weak Exit
use "sa_churnweak.dta", clear
// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


tab firm_churn, gen(exit)

replace exit1 = exit1 * 100
replace exit2 = exit2 * 100
replace exit3 = exit3 * 100

// Doing all groups (2007)
unab interest_var : exit2 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat sa_weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,1]
	matrix sa_weak_exit[1,`i'] = A
	local ++i
	 }
	 

// Doing all groups (2014)
unab interest_var : exit1 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
// mat weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,2]
	matrix sa_weak_exit = sa_weak_exit, A
	local ++i
	 }

matlist sa_weak_exit


//////////////// Nigeria
//// Weak Exit
use "nigeria_churnweak.dta", clear
// declaring survey design
svyset idstd [pweight=wt], strata(strata_all) singleunit(scaled)


tab firm_churn, gen(exit)

replace exit1 = exit1 * 100
replace exit2 = exit2 * 100
replace exit3 = exit3 * 100

// Doing all groups (2007)
unab interest_var : exit2 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
mat naij_weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,1]
	matrix naij_weak_exit[1,`i'] = A
	local ++i
	 }
	 

// Doing all groups (2014)
unab interest_var : exit1 exit3 
// creating local of unab to count length
local interest_var `interest_var'

local var_count : word count `interest_var'
local i = 1
// defining the matrix with specified row length
// mat weak_exit = J(1,`var_count',.)
foreach x of local interest_var {
	svy, subpop(manufacturing): mean `x', over(year)
	matrix A =r(table)[1,2]
	matrix naij_weak_exit = naij_weak_exit, A
	local ++i
	 }

matlist naij_weak_exit


// combining all the exit means together
////////// Combining all my summary stat from each country ////
matrix summary_exit = sen_weak_exit \ sa_weak_exit \ naij_weak_exit


// saving my f pvalue vectors
svmat double summary_exit, name(summary_exit)
keep summary_exit1 summary_exit2 summary_exit3 summary_exit4
drop if summary_exit1 == . | summary_exit2 == . | summary_exit3 == . | summary_exit4 == . 
save summary_exit, replace

