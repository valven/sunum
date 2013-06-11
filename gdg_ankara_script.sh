#!/bin/bash

rm -rf test-reports/*

cd com.demo
$1/android-sdk-linux/tools/android update project --name com.demo --path . --target 1 --subprojects

cd ../com.demo.test
$1/android-sdk-linux/tools/android update test-project -m ../com.demo/ -p .
ant instrument

echo 'Running emulator'
$1/android-sdk-linux/tools/emulator -avd AVD1 -verbose -no-window -noaudio -no-boot-anim &

sleep 60

echo 'Sending unlock scren command to Emulator'
echo "event send EV_KEY:KEY_SOFT1:1" | nc -q1 localhost 5554

echo 'Installing package'
ant installi

echo 'Running test cases'
cd ../test-reports
$1/android-sdk-linux/platform-tools/adb shell am instrument -w -e class com.demo.test.SearchTest com.demo.test/com.zutubi.android.junitreport.JUnitReportTestRunner
$1/android-sdk-linux/platform-tools/adb pull /data/data/com.demo/files/junit-report.xml
mv junit-report.xml junit-report-search.xml

$1/android-sdk-linux/platform-tools/adb shell am instrument -w -e class com.demo.test.MainMenuTest com.demo.test/com.zutubi.android.junitreport.JUnitReportTestRunner
$1/android-sdk-linux/platform-tools/adb pull /data/data/com.demo/files/junit-report.xml
mv junit-report.xml junit-report-main.xml

$1/android-sdk-linux/platform-tools/adb shell am instrument -w -e class com.demo.test.GeneralTest com.demo.test/com.zutubi.android.junitreport.JUnitReportTestRunner
$1/android-sdk-linux/platform-tools/adb pull /data/data/com.demo/files/junit-report.xml
mv junit-report.xml junit-report-general.xml

$1/android-sdk-linux/platform-tools/adb shell am instrument -w -e class com.demo.test.InformationDisplayTest com.demo.test/com.zutubi.android.junitreport.JUnitReportTestRunner
$1/android-sdk-linux/platform-tools/adb pull /data/data/com.demo/files/junit-report.xml
mv junit-report.xml junit-report-infodisplay.xml

$1/android-sdk-linux/platform-tools/adb shell am instrument -w -e class com.demo.test.MyDownloadsTest com.demo.test/com.zutubi.android.junitreport.JUnitReportTestRunner
$1/android-sdk-linux/platform-tools/adb pull /data/data/com.demo/files/junit-report.xml
mv junit-report.xml junit-report-downloads.xml

$1/android-sdk-linux/platform-tools/adb shell am instrument -w -e class com.demo.test.carousel.PlayerCarouselPacketWarningFreqTest com.demo.test/com.zutubi.android.junitreport.JUnitReportTestRunner
$1/android-sdk-linux/platform-tools/adb pull /data/data/com.demo/files/junit-report.xml
mv junit-report.xml junit-report-packetwarning.xml

$1/android-sdk-linux/platform-tools/adb shell am instrument -w -e class com.demo.test.carousel.PlayerCarouselSwipeTest com.demo.test/com.zutubi.android.junitreport.JUnitReportTestRunner
$1/android-sdk-linux/platform-tools/adb pull /data/data/com.demo/files/junit-report.xml
mv junit-report.xml junit-report-swipe.xml

echo 'Killing the emulator'
var1=$(ps -ef|grep -w emulator64 | awk '{print $2}' |head -1)

$1/android-sdk-linux/platform-tools/adb uninstall com.demo
$1/android-sdk-linux/platform-tools/adb uninstall com.demo.test

kill -9 $var1
