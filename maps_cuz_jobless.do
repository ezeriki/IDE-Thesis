cd "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\data"

pwd




********************* Senegal *******************
/// Shape file loading and cleaning
//shp2dta using "Limite_administrative/Limite_region", database("coor_sen_db.dta") coordinates("coor_sen.dta") genid(id) replace

* rename region dataset to match with senegal dataset
//use coor_sen_db, clear 
//rename NOM region 
//save coor_sen_db, replace



		/*use coor_sen_db, clear
			
			rename id _ID
			merge 1:m _ID using "coor_sen.dta"
			drop _merge
			sort region
			by region: egen X = mean(_X)
			by region: egen Y = mean(_Y)
			replace _X = X
			replace _Y = Y
			keep region _X _Y
			
			duplicates drop
			
			save coor_sen_labels, replace*/
			
***************** 2007
use "senegal_manu.dta", clear
keep if year == 2007
keep wt _2007_a3x
rename _2007_a3x region 
contract region wt, freq(count) nomiss
replace wt =  round(wt)
collapse (sum) weighted = count [fweight=wt], by(region)
replace region = "Thiès" if weighted == 63


// merging with shape file with region data
merge 1:1 region using "coor_sen_db" 
//replace weighted = 0 if weighted == .

* generate color
colorpalette viridis, n(12) nograph reverse

local colors `r(p)'

* generate maps
spmap weighted using coor_sen, id(id) ///
fcolor("`colors'")    ///
legstyle(2) legend(pos(10) size(2) region(fcolor(gs15))) ///
clbreaks(50 90 200 300 3000) clmethod(custom) ///
ocolor(black ..) osize(0.05 ..)  ///
title("2007", size(*1)) ///
note("Source: World Bank Enterprise Survey", size(1.5)) ///
label(data(coor_sen_labels) xcoord(_X)  ycoord(_Y) /// 
label(region) size(*0.85 ..)) ///
legend(label(2 "50 to 90") label(3 "90 to 200") label(4 "200 to 300") label(5 "300 to 3000")) ///
 name(sen_07, replace) nodraw
//graph export establishments_census.png, replace 

 ***************** 2014
use "senegal_manu.dta", clear
keep if year == 2014
keep wt a3a
rename a3a region 
contract region wt, freq(count) nomiss
replace wt =  round(wt)
collapse (sum) weighted = count [fweight=wt], by(region)
decode region, gen(region_1)
drop region
rename region_1 region
replace region = "Thiès" if weighted == 204


// merging with shape file with region data
merge 1:1 region using "coor_sen_db" 
//replace weighted = 0 if weighted == .


* generate the colors
colorpalette viridis, n(12) nograph reverse

local colors `r(p)'

* map
spmap weighted using coor_sen, id(id) ///
fcolor("`colors'")    ///
legstyle(2) legend(pos(10) size(2) region(fcolor(gs15))) ///
clbreaks(50 90 200 300 3000) clmethod(custom) ///
ocolor(black ..) osize(0.05 ..)  ///
title("2014", size(*1)) ///
note("Source: World Bank Enterprise Survey", size(1.5)) ///
label(data(coor_sen_labels) xcoord(_X)  ycoord(_Y) /// 
label(region) size(*0.85 ..)) ///
legend(label(2 "50 to 90") label(3 "90 to 200") label(4 "200 to 300") label(5 "300 to 3000")) ///
 name(sen_14, replace) nodraw
 
  ** combining 07 and 20 maps
 graph combine sen_07 sen_14, rows(1) title("Number of Manufacturing Firms")     ///
        subtitle("Senegal, 2007 - 2020" " ") xsize(5) ysize(2.6)               ///
        plotregion(margin(medsmall) style(none))                         ///
        graphregion(margin(zero) style(none))                            ///
        scheme(s1mono)
		
		
graph export "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\figures\sen_map.png", width(900) height(500) replace
 
 
 
********************* South Africa *******************
/// Shape file loading and cleaning
//shp2dta using "sa_shp/za", database("coor_sa_db.dta") coordinates("coor_sa.dta") genid(id) replace

* rename region dataset to match with senegal dataset
//use coor_sen_db, clear 
//rename NOM region 
//save coor_sen_db, replace



		/*use coor_sa_db, clear
			drop ID_0 ID_1
			rename id _ID
			merge 1:m _ID using "coor_sa.dta"
			tab region _ID
			drop _merge
			sort region
			by region: egen X = mean(_X)
			by region: egen Y = mean(_Y)
			replace _X = X
			replace _Y = Y
			keep region _X _Y
			
			duplicates drop
			
			save coor_sa_labels, replace*/
			
			
//_2020_a3a _2020_a3b _2020_a3c _2007_a3x			
***************** 2007
use "sa_manu.dta", clear
tab a2
keep if year == 2007 & manufacturing == 1
keep wt a2 
rename a2 region 
contract region wt, freq(count) nomiss
replace wt =  round(wt)
collapse (sum) weighted = count [fweight=wt], by(region)
decode region, gen(region_1)
drop region
rename region_1 region


// merging with shape file with region data
merge 1:1 region using "coor_sa_db" 
sort region
//replace weighted = 0 if weighted == .


* draw map
spmap weighted using coor_sa, id(id) ///
fcolor(Reds2) ///
legstyle(2) legend(pos(10) size(2) region(fcolor(stone))) ///
clbreaks(1000 7000 10000 12000 30000 60000) clmethod(custom) ///
ocolor(black ..) osize(0.05 ..)  ///
title("2007", size(*1)) ///
note("Source: World Bank Enterprise Survey", size(1.5)) ///
label(data(coor_sa_labels) xcoord(_X)  ycoord(_Y) /// 
label(region) size(*1 ..)) ///
legend(label(2 "1000 to 7000") label(3 "7000 to 10000") label(4 "10000 to 12000") label(5 "12000 to 30000") label(6 "30000 to 60000")) ///
 name(sa_07, replace) nodraw
 
 
 *********** 2020
 use "sa_manu.dta", clear
keep if year == 2020 & manufacturing == 1
keep wt _2020_a3a 
rename _2020_a3a region 
contract region wt, freq(count) nomiss
replace wt =  round(wt)
collapse (sum) weighted = count [fweight=wt], by(region)
decode region, gen(region_1)
drop region
rename region_1 region


// merging with shape file with region data
merge 1:1 region using "coor_sa_db" 
sort region
//replace weighted = 0 if weighted == .


* draw map
spmap weighted using coor_sa, id(id) ///
fcolor(Reds2) ///
legstyle(2) legend(pos(10) size(2) region(fcolor(stone))) ///
clbreaks(1000 7000 10000 12000 30000 60000) clmethod(custom) ///
ocolor(black ..) osize(0.05 ..)  ///
title("2020", size(*1)) ///
note("Source: World Bank Enterprise Survey", size(1.5)) ///
label(data(coor_sa_labels) xcoord(_X)  ycoord(_Y) /// 
label(region) size(*1 ..)) ///
legend(label(2 "1000 to 7000") label(3 "7000 to 10000") label(4 "10000 to 12000") label(5 "12000 to 30000") label(6 "30000 to 60000")) ///
 name(sa_20, replace) nodraw
 
 ** combining 07 and 20 maps
 graph combine sa_07 sa_20, rows(1) title("Number of Manufacturing Firms")     ///
        subtitle("South Africa, 2007 - 2020" " ") xsize(5) ysize(2.6)               ///
        plotregion(margin(medsmall) style(none))                         ///
        graphregion(margin(zero) style(none))                            ///
        scheme(s1mono)
		
graph export "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\figures\sa_map.png", width(900) height(500) replace
		
		********************* Nigeria *******************
/// Shape file loading and cleaning
//shp2dta using "naija_shp/gadm36_NGA_1", database("coor_naija_db.dta") coordinates("coor_naija.dta") genid(id) replace

* rename region dataset to match with senegal dataset
/*use coor_naija_db, clear 
rename NAME_1 region 
replace region = VARNAME_1 if VARNAME_1 == "Abuja"
save coor_naija_db, replace



		use coor_naija_db, clear
			rename id _ID
			merge 1:m _ID using "coor_naija.dta"
			tab region _ID
			drop _merge
			sort region
			by region: egen X = mean(_X)
			by region: egen Y = mean(_Y)
			replace _X = X
			replace _Y = Y
			keep region _X _Y
			
			duplicates drop
			
			save coor_naija_labels, replace*/
			
			
//_2020_a3a _2020_a3b _2020_a3c _2007_a3x			
***************** 2007
use "nigeria_manu.dta", clear
keep if year == 2007 & manufacturing == 1
keep wt a3a 
rename a3a region 
tab region
contract region wt, freq(count) nomiss
replace wt =  round(wt)
collapse (sum) weighted = count [fweight=wt], by(region)
decode region, gen(region_1)
drop region
rename region_1 region
replace region = "Cross River" if region == "Cross river"

// merging with shape file with region data
merge 1:1 region using "coor_naija_db" 
sort region
//replace weighted = 0 if weighted == .


* draw map
spmap weighted using coor_naija, id(id) ///
fcolor(Greens2) ///
legstyle(2) legend(pos(10) size(2) region(fcolor(stone))) ///
clbreaks(100 300 500 700 1000 2000) clmethod(custom) ///
ocolor(black ..) osize(0.05 ..)  ///
title("2007", size(*1)) ///
note("Source: World Bank Enterprise Survey", size(1.5)) ///
label(data(coor_naija_labels) xcoord(_X)  ycoord(_Y) /// 
label(region) size(*1 ..)) ///
legend(label(2 "100 to 300") label(3 "300 to 500") label(4 "500 to 700") label(5 "700 to 1000") label(6 "1000 to 2000") pos(6) row(3) ring(1) size(*.75) symx(*.75) symy(*.75) forcesize ) ///
 name(naija_07, replace) nodraw
 
 
 ***************** 2014
 use "nigeria_manu.dta", clear
keep if year == 2014 & manufacturing == 1
keep wt a3a 
rename a3a region 
tab region
contract region wt, freq(count) nomiss
replace wt =  round(wt)
collapse (sum) weighted = count [fweight=wt], by(region)
decode region, gen(region_1)
drop region
rename region_1 region
replace region = "Cross River" if region == "Cross river"

// merging with shape file with region data
merge 1:1 region using "coor_naija_db" 
sort region
//replace weighted = 0 if weighted == .


* draw map
spmap weighted using coor_naija, id(id) ///
fcolor(Greens2) ///
legstyle(2) legend(pos(10) size(2) region(fcolor(stone))) ///
clbreaks(100 300 500 700 1000 2000) clmethod(custom) ///
ocolor(black ..) osize(0.05 ..)  ///
title("2014", size(*1)) ///
note("Source: World Bank Enterprise Survey", size(1.5)) ///
label(data(coor_naija_labels) xcoord(_X)  ycoord(_Y) /// 
label(region) size(*1 ..)) ///
legend(label(2 "100 to 300") label(3 "300 to 500") label(4 "500 to 700") label(5 "700 to 1000") label(6 "1000 to 2000") pos(6) row(3) ring(1) size(*.75) symx(*.75) symy(*.75) forcesize) ///
 name(naija_14, replace) nodraw
 
  ** combining 07 and 14 maps
 graph combine naija_07 naija_14, rows(1) title("Number of Manufacturing Firms")     ///
        subtitle("Nigeria, 2007 - 2014" " ") xsize(5) ysize(2.6)               ///
        plotregion(margin(medsmall) style(none))                         ///
        graphregion(margin(zero) style(none))                            ///
        scheme(s1mono)
		
graph export "C:\Documents\Yale Spring 24\Advanced development economics\IDE-Thesis\figures\naija_map.png", width(900) height(500) replace
	
** combining everything together // too small
graph combine sen_07 sen_14 sa_07 sa_20 naija_07 naija_14, rows(3)