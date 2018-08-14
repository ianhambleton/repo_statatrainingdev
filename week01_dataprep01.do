**  DO-FILE METADATA
//  algorithm name			week01_dataprep01.do
//  project:				Exercise using Collapse and Reshape
//  analysts:				Ian HAMBLETON
//	date last modified		13-Aug-2018
//  algorithm task			Prepare datasets for the exercise

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
cap log using "`logpath'\week01_dataprep01", replace



** DATASET ONE
** Environmental conditions in Barbados (2000 to 2013)
** We have daily environmental conditions for Barbados (from Grantley Adams International Airport)
** -------------------------------------------------------------------------------------
** The variables are:
**  Average Temperature     measure = 1
**  Maximum temperature     measure = 2
**  Minimum temperature     measure = 3
**  Relative humidity       measure = 4
**  Rainfall                measure = 5
**  yom                     Year of measurement (2000 - 2013)
**  mom                     Month of measurement (1-12)
**  dom                     Day of month of measurement (days running from 1 to max 31)
**  value                   Value of meteorological measurement
**  dov                     Date of meteorological measurement
** -------------------------------------------------------------------------------------
use "`datapath'\meteorology_barbados_001", clear
drop yom mom dom
label data "Barbados daily meteorology data long format: 2000 - 2013"
save "`datapath'\dataset01_meteorology", replace



** DATASET TWO
** Paediatric Asthma Admissions to QEH (1996 to 2005)
** And selected environmental conditions over same time period
** -----------------------------------------------------------
** The variables are:
** doa       Date of asthma admission
** dow       Day of asthma admission
** woa       Week of asthma admission
** moa       Month of asthma admission
** yoa       Year of asthma admission
** pa        paediatric asthma
** pam       paediatric asthma: boys
** paf       paediatric asthma: girls
** pa1       paediatric asthma: <1 yrs
** pa5       paediatric asthma: 1 - <5 yrs
** pa10      paediatric asthma: 5 - <10 yrs
** pa15      paediatric asthma: 10 - <15 yrs
** pa18      paediatric asthma: 15 - <18 yrs
** aa        adult asthma
** pam1      paediatric asthma boys: <1 yrs
** pam5      paediatric asthma boys: 1 - <5 yrs
** pam10     paediatric asthma boys: 5 - <10 yrs
** pam15     paediatric asthma boys: 10 - <15 yrs
** pam18     paediatric asthma boys: 15 - <18 yrs
** paf1      paediatric asthma girls: <1 yrs
** paf5      paediatric asthma girls: 1 - <5 yrs
** paf10     paediatric asthma girls: 5 - <10 yrs
** paf15     paediatric asthma girls: 10 - <15 yrs
** paf18     paediatric asthma girls: 15 - <18 yrs
** gpollen   Grass pollen
** spores    Spores
** tmax      Max daily temperature (celcius)
** tmin      Min daily temperature (celcius)
** rain      Daily rainfall (mm)
** rhmax     Max relative humidity (%)
** rhmin     Min relative humidity (%)
** dust      African dust (micrograms / cubic metre)
** bacteria  Bacteria (count / cubic metre)
** fungi     Fungi (count / cubic metre)
** tpollen   Tree pollen
** -----------------------------------------------------------
use "`datapath'\barbados_asthma01", clear
** Drop variables we don't really need for this Exercise
drop woa
gen woa = week(doa)
label var woa "Week of admission"
order woa, after(doa)
label data "Asthma events and african dust constituents: 1996-2005
save "`datapath'\dataset02_asthma", replace
