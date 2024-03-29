#!/bin/bash

source /opt/sphenix/core/bin/sphenix_setup.sh -n

cd /sphenix/sim/sim01/sphnxpro/TrackingDailyBuild/

if [ ! -d "$(date +"%Y")" ]; then
 mkdir "$(date +"%Y")"
fi

cd "$(date +"%Y")"

if [ ! -d "$(date +"%d-%m")" ]; then
  mkdir "$(date +"%d-%m")"
fi
cd "$(date +"%d-%m")"

mkdir MinBias50kHzHijingOutput

git clone https://github.com/sPHENIX-Collaboration/DataMonitoring.git MinBias50kHzHijing

cd MinBias50kHzHijing/Tracking/DailyCronJobScripts/MinBias50kHzHijing

mkdir logfiles

git clone -b QA-tracking-mbhijing https://github.com/sPHENIX-Collaboration/macros.git
cd macros
git merge origin/master --no-commit
cd ..
condor_submit Run50kHzMBHijing.job
