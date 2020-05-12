#!/usr/local/bamboo/bin/runOnRemoteAgent.sh agent@${bamboo.capability.remoteAddress} ${bamboo.capability.remotePort}

#########
#       #
# Setup #
#       #
#########

export PATH=$PATH:$HOME/.bin/:$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
source "$HOME/.rvm/scripts/rvm"

readonly build_key="${bamboo_buildResultKey}"
readonly build_directory="$HOME/Services/Build/$build_key"
readonly current_branch="${bamboo_planRepository_branchName}"
readonly target_branch="${bamboo_repository_pr_targetBranch}"
readonly artifact_server_address=soulartifacts@soulbot.local
readonly remote_name="${bamboo_planKey}-${bamboo_buildNumber}"
readonly repository_url="${bamboo_planRepository_repositoryUrl}"
readonly repository_name="${bamboo_planRepository_name}"


########
#      #
# Test #
#      #
########

# Test iOS
xcodebuild clean test \
    -project "RTFKit.xcodeproj" \
    -scheme "RTFKitiOS" \
    -derivedDataPath "iOS" \
    -destination "platform=iOS Simulator,name=iPad Pro (11-inch) (2nd generation),OS=latest" &>iOS.log &

# Test macOS
xcodebuild clean test \
    -project "RTFKit.xcodeproj" \
    -scheme "RTFKit" \
    -derivedDataPath "macOS" &>macOS.log &

echo "Testing on ${bamboo_capability_server}"
echo "Live log is disabled for concurrent builds"
echo "iOS build log is at $(realpath iOS.log)"
echo "macOS build log is at $(realpath macOS.log)"

wait
cat iOS.log
cat macOS.log

# Convert test output
trainer -p "iOS" -o "test-reports"
trainer -p "macOS" -o "test-reports"

macReport="$(ls test-reports/*-RTFKit-*)"
iOSReport="$(ls test-reports/*-RTFKitiOS-*)"
mergeTestResults \
    --label iOS --in $iOSReport \
    --label mac --in $macReport \
    --out test-reports/merged.xml
