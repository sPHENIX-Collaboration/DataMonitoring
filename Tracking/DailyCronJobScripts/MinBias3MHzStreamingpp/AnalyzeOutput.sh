#!/bin/sh

# This script analyzes the output from the daily tracking QA jobs and aggregates it into a single root file. Intended to run after the jobs are complete as ./AnalyzeOutput.sh

source /cvmfs/sphenix.sdcc.bnl.gov/gcc-8.3/opt/sphenix/core/bin/sphenix_setup.sh -n 
HOME_DIR="/sphenix/sim/sim01/sphnxpro/TrackingDailyBuild/$(date +"%Y")/$(date +"%d-%m")/MinBias3MHzStreamingppOutput"

YESTERDAY_DIR="/sphenix/sim/sim01/sphnxpro/TrackingDailyBuild/$(date +"%"Y)/$(date -d 'yesterday 13:00' +'%d-%m')/MinBias3MHzStreamingppOutput"

cd $HOME_DIR
pwd
# creates time.txt file with aggregated timing information
~/git/DataMonitoring/Tracking/TimingTools/parseTimers.sh $HOME_DIR/ $HOME_DIR/

#creates timingoutfile.root containing histogramed timing information
root -b -q -l ~/git/DataMonitoring/Tracking/TimingTools/AnalyzeTime.C\(\"$HOME_DIR/time.txt\",\"$HOME_DIR/timingoutfile.root\"\)

#Aggregate job file output
cd $HOME_DIR
hadd -k MinBias3MHzStreamingppDailyBuild_qa.root MinBias3MHz_pythia8_Charm_dailybuild_*_qa.root

hadd -k MinBias3MHzStreamingppDailyBuild_g4svtx.root MinBias3MHz_pythia8_Charm_dailybuild_*_g4svtx_eval.root

rm MinBias3MHz_pythia8_Charm_dailybuild_*_g4svtx_eval.root

# run qa macros and save histograms in home dir
root -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/MvtxQA.C\(\"$YESTERDAY_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/MvtxComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/InttQA.C\(\"$YESTERDAY_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/InttComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/TpcQA.C\(\"$YESTERDAY_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/TpcComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/TpotQA.C\(\"$YESTERDAY_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/TpotComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/TrackingQA.C\(\"$YESTERDAY_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/TrackingComparisons.root\"\)

root  -l -b -q ~/git/DataMonitoring/Tracking/PhysicsPerformanceTools/VertexingQA.C\(\"$YESTERDAY_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/MinBias3MHzStreamingppDailyBuild_qa.root\",\"$HOME_DIR/VertexingComparisons.root\"\)

#Compile the QA results and move to the top working directory for the day
hadd MinBias3MHzStreamingppQA.root timingoutfile.root *Comparisons.root
mv MinBias3MHzStreamingppQA.root ../
mv MinBias3MHzStreamingppDailyBuild_g4svtx.root ../

cd ../
                                 
cp MinBias3MHzStreamingppQA.root /sphenix/WWW/subsystem/DataMonitoring/Tracking/3MHzMinBiasppToday.root
cp $YESTERDAY_DIR/../MinBias3MHzStreamingppQA.root /sphenix/WWW/subsystem/DataMonitoring/Tracking/3MHzMinBiasppYesterday.root
