#!/bin/sh

# This script analyzes the output from the daily tracking QA jobs and aggregates it into a single root file. Intended to run after the jobs are complete as ./AnalyzeOutput.sh

source /cvmfs/sphenix.sdcc.bnl.gov/gcc-8.3/opt/sphenix/core/bin/sphenix_setup.sh -n 
HOME_DIR="/sphenix/sim/sim01/sphnxpro/TrackingDailyBuild/$(date +"%Y")/$(date +"%d-%m")/MinBias50kHzHijingOutput"

YESTERDAY_DIR="/sphenix/sim/sim01/sphnxpro/TrackingDailyBuild/$(date +"%"Y)/$(date -d 'yesterday 13:00' +'%d-%m')/MinBias50kHzHijingOutput"

cd $HOME_DIR
pwd
# creates time.txt file with aggregated timing information
~/git/DataMonitoring/Tracking/TimingTools/parseTimers.sh $HOME_DIR/ $HOME_DIR/

#creates timingoutfile.root containing histogramed timing information
root -b -q -l ~/git/DataMonitoring/Tracking/TimingTools/AnalyzeTime.C\(\"$HOME_DIR/time.txt\",\"$HOME_DIR/timingoutfile.root\"\)

#Aggregate job file output
cd $HOME_DIR
hadd -f -k MinBias50kHzHijingDailyBuild_qa.root MinBias50kHzHijing_dailybuild_*_qa.root

hadd -f -k MinBias50kHzHijingDailyBuild_g4svtx.root MinBias50kHzHijing_dailybuild_*_g4svtx_eval.root


# run qa macros and save histograms in home dir
root -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/MvtxQA.C\(\"$YESTERDAY_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/MvtxComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/InttQA.C\(\"$YESTERDAY_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/InttComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/TpcQA.C\(\"$YESTERDAY_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/TpcComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/TpotQA.C\(\"$YESTERDAY_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/TpotComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/TrackingQA.C\(\"$YESTERDAY_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/TrackingComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/VertexingQA.C\(\"$YESTERDAY_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/MinBias50kHzHijingDailyBuild_qa.root\",\"$HOME_DIR/VertexingComparisons.root\"\)

#Compile the QA results and move to the top working directory for the day
hadd -f -k MinBias50kHzHijingQA.root timingoutfile.root *Comparisons.root
mv MinBias50kHzHijingQA.root ../
mv MinBias50kHzHijingDailyBuild_g4svtx.root ../

cd ../

cp MinBias50kHzHijingQA.root /sphenix/WWW/subsystem/DataMonitoring/Tracking/50kHzMinBiasToday.root
cp $YESTERDAY_DIR/../MinBias50kHzHijingQA.root /sphenix/WWW/subsystem/DataMonitoring/Tracking/50kHzMinBiasYesterday.root
