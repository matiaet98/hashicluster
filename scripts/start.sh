#!/bin/bash

sudo nomad agent -config $(dirname $0)/../cluster.hcl &> /dev/null &
