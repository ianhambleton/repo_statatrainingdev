** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    week05_dataprep01.do
    //  project:				        Stata training
    //  analysts:						    Ian HAMBLETON
    // 	date last modified	    7-SEP-2018
    //  algorithm task			    Building a Publication Quality graphic in STAGES

    ** General algorithm set-up
    version 15
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export
    ** DATASETS to encrypted SharePoint folder
    local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_statatrainingdev"
    ** LOGFILES to unencrypted OneDrive folder
    local logpath X:\OneDrive - The University of the West Indies\repo_datagroup\repo_statatrainingdev

    ** Close any open log fileand open a new log file
    capture log close
    cap log using "`logpath'\week06_examplecode", replace
** HEADER -----------------------------------------------------

** Load the SABE health dataset (Section C)
use "`datapath'\dataset06_sabehealth.dta", replace

** Chi-squared
#delimit ;
        local sabehealth "C01 C02 C03 C04 C05 C06 C07 C08 C09 C10 C11
        C13A C13B C13C C13D C13E C13F C13G C13H C13I C13J C13K
        C15 C16 C22A C22B C22C C22D C22E C22F C22G C22H C22I";
#delimit cr

** Chi-squared test by country

tab C01 SEX, chi

** Posted file looking at SEX difference for each variable in dataset
tempname sexdiff1
postfile `sexdiff1' str4 var chi2 pval using "`datapath'\dataset06_post_irh1.dta", replace
foreach var in `sabehealth' {
    qui tab `var' SEX, chi
    local chi2 = r(chi2)
    local pval = r(p)
    post `sexdiff1' ("`var'") (`chi2') (`pval')
}
postclose `sexdiff1'
** use "`datapath'\dataset06_post_irh1.dta", clear


** Posted file looking at SEX difference by CITY for each variable in dataset
tempname sexdiff2
postfile `sexdiff2' city str4 var chi2 pval using "`datapath'\dataset06_post_irh2.dta", replace
forval city = 1(1)7 {
    foreach var in `sabehealth' {
        qui tab `var' SEX if CITY==`city', chi
        local chi2 = r(chi2)
        local pval = r(p)
        post `sexdiff2' (`city') ("`var'") (`chi2') (`pval')
    }
}
postclose `sexdiff2'
use "`datapath'\dataset06_post_irh2.dta", clear

** Inequality (difference)
bysort var: egen cmax = max(chi2)
bysort var: egen cmin = min(chi2)
gen adiff = cmax-cmin

** Create a unique ID number
gsort -adiff var city
gen id = _n
gen temp1 = (id/7)
gen temp2 = int(id/7)
gen temp3 = temp1-temp2
replace temp2 = temp2-1 if temp3==0
drop temp1 temp3
rename temp2 idg
replace id = id + 7*idg


** Graphic
#delimit ;
    gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
          (sc chi2 id, mc(gs8) m(o) msize(3))
		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(2) xsize(15)

			xlab(4 "C10" 18 "C13I" 32 "C13E" 46 "C05" 60 "C13D" 74 "C11" 88 "C13A" 102 "C13B" 116 "C13F" 130 "C22G" 144 "C22H"
            158 "C01" 172 "C13G" 186 "C22B" 200 "C16" 214 "C22F" 228 "C04" 242 "C02" 256 "C08" 270 "C03" 284 "C13H" 298 "C22C"
            312 "C22I" 326 "C13J" 340 "C13C" 354 "C13K" 368 "C09" 382 "C22A" 396 "C22E" 410 "C22D" 424 "C07" 438 "C06" 452 "C15"
            , labs(8) nogrid angle(45) labgap(5))
			xtitle("", margin(t=10) size(3.5))
			///xmtick(1965(5)2010)

			ylab(0(50)150, labs(6) nogrid glc(gs14) angle(0) format(%9.0f))
			ytitle("", margin(r=3) size(3.5))
			///ytick(0(10)80) ymtick(0(5)80)
            yscale(range(0(10)150))
            /// Shading
             xline(11, lc(gs0)) xline(25, lc(gs0)) xline(39, lc(gs0)) xline(53, lc(gs0))
             xline(67, lc(gs0)) xline(81, lc(gs0)) xline(95, lc(gs0)) xline(109, lc(gs0))
             xline(123, lc(gs0)) xline(137, lc(gs0)) xline(151, lc(gs0)) xline(165, lc(gs0))
             xline(179, lc(gs0)) xline(193, lc(gs0)) xline(207, lc(gs0)) xline(221, lc(gs0))
             xline(235, lc(gs0)) xline(249, lc(gs0)) xline(263, lc(gs0)) xline(277, lc(gs0))
             xline(291, lc(gs0)) xline(305, lc(gs0)) xline(319, lc(gs0)) xline(334, lc(gs0))
             xline(348, lc(gs0)) xline(362, lc(gs0)) xline(376, lc(gs0)) xline(390, lc(gs0))
             xline(404, lc(gs0)) xline(418, lc(gs0)) xline(432, lc(gs0)) xline(446, lc(gs0))

            name(figure_irh)
            ;
#delimit cr
