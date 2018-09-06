** HEADER -----------------------------------------------------
**  DO-FILE METADATA
//  algorithm name			week02_examplecode.do
//  project:				Exercise using Merge and Append
//  analysts:				Ian HAMBLETON
//	date last modified		30-Aug-2018
//  algorithm task			Example code for the exercise

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
cap log using "`logpath'\week02_dataprep01", replace
** HEADER -----------------------------------------------------

** We're going to load up and use a SCD example for our merge and append Exercise
** (1) We'll use STATIC for the invariant information
** (2) We'll use HAEMATOLOGY for the longitudinal information
** (3) And we'll use D5 clinical events (severe pain crisis) as a second set of longitudinal information

** Static First
** We create THREE small statisc fileexists
** File 1 --> static1 (participant Cohort IDs 1 to 10)
** File 2 --> static11 (participant Cohort IDs 11 to 20)
** File 3 --> static21 (participant Cohort IDs 21 to 30)
use "`datapath'\working\all_static", clear
keep if cohort==1
keep if geno==2 | geno==29
recode geno 29=1
label define geno_ 1 "ss" 2 "aa"
label values geno geno_
drop last first dofv dolv add1 add2 add3 clinic parish cohort
drop if cohno =="006A"
drop if cohno =="016A"
drop if cohno =="020B"
rename idno pid
label var pid "Participant unique identifier"
gen cid = real(cohno)
label var cid "Cohort group identifier"
encode alpha, gen(athal)
drop alpha
label var athal "Alpha thalassaemia status"
preserve
keep if cid>=101 & cid<=120
    drop cohno athal dob
    order pid cid
    label data "Sickle Cell Disease: Participant Information - File 1"
    save "`datapath'\dataset03_static1.dta", replace
restore
preserve
    keep if cid>=121 & cid<=140
    drop cohno dob
    order pid cid
    label data "Sickle Cell Disease: Participant Information- File 2"
    save "`datapath'\dataset03_static2.dta", replace
restore
preserve
    **keep if cid>=101 & cid<=150
    keep if cid>=141 & cid<=160
    drop cohno dob
    order pid cid
    label data "Sickle Cell Disease: Participant Information- File 3"
    save "`datapath'\dataset03_static3.dta", replace
restore

** Haematology File next.
** Merge in the cohort number to allow a restriction
** But we want to keep a few more Cohort members to give a slight additional challenge
use "`datapath'\working\all_haem", clear
merge m:1 idno using "`datapath'\working\all_static"
drop last first dofv dolv add1 add2 add3 clinic parish alpha cohort sex geno status _merge
drop if cohno =="006A"
drop if cohno =="016A"
drop if cohno =="020B"
rename idno pid
label var pid "Participant unique identifier"
gen cid = real(cohno)
label var cid "Cohort group identifier"
keep pid cid cohno dob dov hb hbf nbc
keep if cid>=101 & cid<=180
gen agey = (dov-dob)/365.25
drop cohno dob
order pid cid dov agey hb hbf nbc
sort pid dov
label var agey "Age in years"
label var hbf "Fetal haemoglobin (%)"
label var hb "Total haemoglobin (g/dL)"
label var nbc "Nucleated blood count (x109)"
label data "Sickle Cell Disease: Haematology"
save "`datapath'\dataset03_haem.dta", replace

** Clinical Event File next.
** Merge in the cohort number to allow a restriction
use "`datapath'\working\ih078_d3", clear
drop if cohno =="006A"
drop if cohno =="016A"
drop if cohno =="020B"
rename idno pid
label var pid "Participant unique identifier"
gen cid = real(cohno)
label var cid "Cohort group identifier"
keep if c==481 | c==345
gen agey = (dov-dob)/365.25
keep pid cid dov agey tov c
keep if cid>=51 & cid<=180
order pid cid dov agey tov c
drop cid
sort pid dov
label var agey "Age in years"
label var tov "Type of clinic visit (routine or sick)"
label var c "Clinical Event (Y1, D4, D5, D6)"
label data "Sickle Cell Disease: Clincial Events"
save "`datapath'\dataset03_clin.dta", replace
