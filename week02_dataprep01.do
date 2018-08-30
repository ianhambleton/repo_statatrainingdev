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

** Temporary files
tempfile static1 static11 static21

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
drop last first dofv dolv add1 add2 add3 clinic parish alpha cohort
drop if cohno =="006A"
drop if cohno =="016A"
drop if cohno =="020B"
rename idno pid
label var pid "Participant unique identifier"
gen cid = real(cohno)
label var cid "Cohort group identifier"
preserve
    keep if cid<=10
    save `static1', replace
restore
preserve
    keep if cid>=11 & cid<=20
    save `static11', replace
restore
preserve
    keep if cid>=21 & cid<=30
    save `static21', replace
restore

** We 
