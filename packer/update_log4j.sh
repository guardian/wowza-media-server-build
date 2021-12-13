#!/bin/bash -e

## if we have version 2.13 of log4j then apply the 2.15 update from apache. This should fix CVE-2021-44228.

WOWZA_PATH=/usr/local/WowzaStreamingEngine  #this should be a symlink to the correct location
if [ ! -d ${WOWZA_PATH} ]; then
  echo Could not find a wowza installation in /usr/local! What is there:
  ls -lh /usr/local
  exit 1
else
  echo Found wowza streaming engine at ${WOWZA_PATH}
fi

if [ -f ${WOWZA_PATH}/lib/log4j-core-2.13.3.jar ] || [ -f ${WOWZA_PATH}/lib/log4j-api-2.13.3.jar ]; then
  echo Found vulnerable log4j, needs patch
  curl https://dlcdn.apache.org/logging/log4j/2.15.0/apache-log4j-2.15.0-bin.zip > apache-log4j-2.15.0-bin.zip
  unzip apache-log4j-2.15.0-bin.zip
  rm -f ${WOWZA_PATH}/lib/log4j-core-2.13.3.jar
  rm -f ${WOWZA_PATH}/lib/log4j-api-2.13.3.jar
  mv -v apache-log4j-2.15.0-bin/log4j-core-2.15.0.jar ${WOWZA_PATH}/lib/
  mv -v apache-log4j-2.15.0-bin/log4j-api-2.15.0.jar ${WOWZA_PATH}/lib/
  echo Patch successful
else
  echo Did not find vulnerable log4j, patch not needed. Versions present:
  ls -lh ${WOWZA_PATH}/lib/log4j-*
fi
