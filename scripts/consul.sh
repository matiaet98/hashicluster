#!/bin/bash

start() {
  echo 'Starting Consul' >&2
  consul agent -config-dir=/etc/consul.d &> /dev/null &
}

stop() {
  echo 'Stopping Consul' >&2
  ps aux | grep consul | awk '{print $2}' | xargs kill &> /dev/null
  sleep 5
}


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
esac