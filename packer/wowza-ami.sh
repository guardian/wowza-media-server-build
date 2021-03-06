#!/bin/bash -e

cp /usr/local/WowzaStreamingEngine/conf/admin.password /tmp/admin.password

rsync -a /home/ec2-user/config/ /usr/local/WowzaStreamingEngine/
rm -rf /home/ec2-user/config

service WowzaStreamingEngineManager restart
service WowzaStreamingEngine restart

# jq is needed for the scripts under bin/
yum install jq -y

# localhost:8087 needs to be available, wait for wowza to be ready before continuing
sleep 1m

/home/ec2-user/bin/enable-stream-targets
/home/ec2-user/bin/enable-transcoder
mv /tmp/admin.password /usr/local/WowzaStreamingEngine/conf
chown -R wowza.wowza /usr/local/WowzaStreamingEngine/conf
chmod -R o= /usr/local/WowzaStreamingEngine/conf
