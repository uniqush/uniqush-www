#!/bin/bash
echo "Going to source"
source /etc/profile.d/rvm.sh
ls -la /root
echo "Going to run rvm install"
rvm install 1.8.7
rvm use 1.8.7
