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
cap log using "`logpath'\week03_dataprep01", replace
** HEADER -----------------------------------------------------

** CARIBBEAN mortality rates
** Dataset from IH054 --> Mortality Benchmarking
use "`datapath'\working\ipva_001.dta", clear

** IPVA_001.dta
** PROJECT CODE: a070 - IPVA
** We keep the Behaviour questions for this session
** Behaviour was measured using the Conflict Tactics Scale.
** Following standard guidelines, we create two composite behaviour scales
** ‘strengths’ and ‘aggression’.
** EB questions = Behaviour strengths
** EC questions =  Aggressive behaviour
keep if age>18
gen yr = year(doi)
gen agey = yr - a2b
keep idno coi sex agey eb* ec*
order idno coi sex agey eb* ec*
drop ec15a

label var idno "Unique identifier"
label var agey "Age to nearest year"
label drop _all

save "`datapath'\dataset04_ipv.dta", replace
