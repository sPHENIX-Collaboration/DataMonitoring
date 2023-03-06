#!/bin/sh

#setup default new environment for job
source /opt/sphenix/core/bin/sphenix_setup.sh -n


# input parameters
echo "input process num: " $1
echo "nEvents: " $2
runno=$1
nevents=$2
strout=$3
low=$4
high=$5

skipevent=$((($runno+1)*$nevents))
fileno=$(($skipevent/300))
skip=$(($skipevent%300))

if [ $high -gt 3000 ]
then
  fileno=$(($fileno+3))
fi

echo "In directory: " 
pwd

echo "Run number: " $runno
echo "events " $nevents
echo "outputFile: " $strout
echo "low pt "$low
echo "high pt "$high
echo "skip "$skip
echo "Executing with build contained in " $OFFLINE_MAIN
echo "Executing on date and time $(date +"%d-%m-%Y-%T")"


# Construct the G4Hits DST files to access. These are MinBias 50 kHz pile up AuAu
# events
strembed0="DST_TRUTH_G4HIT_pi_"$low"_"$high"MeV_sHijing_0_20fm_50kHz_bkg_0_20fm-0000000006-0"$fileno".root"
strembed1="DST_TRKR_G4HIT_pi_"$low"_"$high"MeV_sHijing_0_20fm_50kHz_bkg_0_20fm-0000000006-0"$fileno".root"
strembed2="DST_CALO_G4HIT_pi_"$low"_"$high"MeV_sHijing_0_20fm_50kHz_bkg_0_20fm-0000000006-0000"$fileno".root"

echo $strembed0
echo $strembed1
echo $strembed2


cd macros/detectors/sPHENIX

echo "pwd is: "
pwd

root -b -q  'Fun4All_G4_sPHENIX.C('$nevents', '$runno', "'$strembed0'" ,  "'$strembed1'", "'$strembed2'", "'$strout'","",'$skip' )'

mv $strout*.root ../../../../../../../MinBias50kHzHijingOutput/
cd ../../../
mv logfiles/$strout.out ../../../../MinBias50kHzHijingOutput/
