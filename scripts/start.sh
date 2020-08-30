#!/bin/bash

sudo ps aux | grep nomad | awk '{print $2}' | sudo xargs kill
sleep 5
sudo nomad agent -config $(dirname $0)/../cluster.hcl &> /dev/null &
