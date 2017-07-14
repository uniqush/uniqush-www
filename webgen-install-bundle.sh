#!/bin/bash
source /etc/profile.d/rvm.sh
set -xe
rvm use 1.8.7
gem install bundler
