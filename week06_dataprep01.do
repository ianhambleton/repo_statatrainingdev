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
    cap log using "`logpath'\week06_dataprep01", replace
** HEADER -----------------------------------------------------

** Load and limit the dataset
use "`datapath'\working\sabe_7nation_complete.dta", clear
keep ID CITY C*
label var C01 "HOW IS YOUR HEALTH?"
label var C02 "HOW IS YOUR HEALTH, COMPARED TO YEAR AGO?"
label var C03 "HOW IS YOUR HEALTH, COMPARED TO OTHERS YOUR AGE?"
label var C04 "EVER BEEN TOLD YOU HAVE HIGH BLOOD PRESSURE?"
label var C05 "EVER BEEN TOLD YOU HAVE DIABETES OR HIGH BLOOD SUGAR?"
label var C06 "HAVE YOU EVER BEEN TOLD YOU HAVE CANCER OR A MALIGNANT TUMOR?"
label var C07 "HAVE YOU EVER BEEN TOLD YOU HAVE LUNG DISEASE?"
label var C08 "HAVE YOU EVER BEEN TOLD YOU HAD HEART ATTACK?"
label var C09 "HAVE YOU EVER BEEN TOLD YOU HAD A STROKE?"
label var C10 "HAVE YOU EVER BEEN TOLD YOU HAVE ARTHRITIS?"
label var C11 "HAVE YOU FALLEN IN LAST 12 MONTHS?"
label var C13A "HAVE YOU HAD: CHEST PAIN?"
label var C13B "HAVE YOU HAD: PERSISTENT SWELLING?"
label var C13C "HAVE YOU HAD: SHORTNESS OF BREATH WHILE AWAKE?"
label var C13D "HAVE YOU HAD: PERSISTENT DIZZINESS?"
label var C13E "HAVE YOU HAD: BACK PAIN OR PROBLEMS?"
label var C13F "HAVE YOU HAD: PERSISTENT HEADACHES?"
label var C13G "HAVE YOU HAD: SEVERE FATIGUE OR TIREDNESS?"
label var C13H "HAVE YOU HAD: PERSISTENT WHEEZING COUGH OR BRING UP PHLEGM?"
label var C13I "HAVE YOU HAD: PROBLEMS WITH YOUR THE JOINTS?"
label var C13J "HAVE YOU HAD: PERSISTENT NAUSEA AND VOMITING?"
label var C13K "HAVE YOU HAD: PERSISTENT THIRST, EXCESSIVE SWEATING?"
label var C15 "DO YOU USE A HEARING AID?"
label var C16 "ARE YOU MISSING ANY TEETH?"
label var C22A "COMPLETE MEALS A DAY?"
label var C22B "EAT MILK AND CHEESE?"
label var C22C "EAT EGGS, PEAS, BEANS?"
label var C22D "EAT MEAT, FISH, OR POULTRY?"
label var C22E "EAT FRUIT OR VEGETABLES?"
label var C22F "EATING LESS DUE TO DIGESTIVE PROBLEMS?"
label var C22G "HOW MANY GLASSES OF LIQUID DO YOU DRINK A DAY?"
label var C22H "HAVE YOU LOST WEIGHT,WITHOUT DIETING?"
label var C22I "ARE YOU WELL NOURISHED?"
label var ID "Unique participant identifier"
rename C18 SEX
label var SEX "Participant sex 1=women 2=men"
label define SEX_ 1 "female" 2 "male"
label values SEX SEX_
** Cleaning
mvdecode C01 C02 C03, mv(0 8 9)
mvdecode C04 C05 C06 C07 C08 C09 C10 C11, mv(8 9)
mvdecode C13A C13B C13C C13D C13E C13F C13G C13H C13I C13J C13K, mv(8 9)
mvdecode C15 C16 C22A C22B C22C C22D C22E C22F C22G C22H C22I, mv(8 9)
keep ID CITY SEX C01 C02 C03 C04 C05 C06 C07 C08 C09 C10 C11 C13* C15 C16 C22*
order ID CITY SEX C01 C02 C03 C04 C05 C06 C07 C08 C09 C10 C11 C13* C15 C16 C22*

** Save the dataset
label data "SABE: Health of the Elderly in Latin America and the Caribbean (2004)"
save "`datapath'\dataset06_sabehealth.dta", replace
