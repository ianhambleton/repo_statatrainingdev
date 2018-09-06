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


** --------------------------------------
** WEEK 03
** _n, _N, and subscripting
** A short exerise making use of subscripting in stata
** --------------------------------------

** 31-AUG-2018
** Data Prep NOT NEEDED
