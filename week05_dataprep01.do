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
    cap log using "`logpath'\week05_dataprep01", replace
** HEADER -----------------------------------------------------

** Load and limit the dataset
** The dataset includes a series of health disparity measures
** for THREE world regions: Caribbean (15), Central America (16), South America (17), Northern america (18)
** The THREE health disparity measures are:
** Mean Log Deviation (measure = 4)
** Theil Index (measure = 5)
** symmetrized Theil index (STI) (measure = 7)
use "`datapath'\working\hd_ge_example", clear
** Drop North America
drop if type==18
recode measure 4=1 5=2 7=3
label define measure_ 1 "mean log deviation" 2 "theil index" 3 "standardised theil index"
label values measure measure_
label var measure "Disparity measure"
label var type "Geographical region"
label var year "5-year time period"
label var _le "Life Expectancy disparity level"
label data "LAC health disparity measures 2015"
save "`datapath'\dataset05_healthdisparity.dta", replace
