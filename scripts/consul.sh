#!/bin/bash

sudo consul agent -config-dir=/etc/consul.d &> /dev/null &
ssh ark 'sudo consul agent -config-dir=/etc/consul.d' &> /dev/null &
sleep 5
sudo consul join 10.0.0.3

