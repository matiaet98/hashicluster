#!/bin/bash

start() {
  echo 'Starting Nomad…' >&2
  nomad agent -config $(dirname $0)/../$(hostname).hcl &> /dev/null &
}

stop() {
  echo 'Stopping Nomad…' >&2
  ps aux | grep nomad | awk '{print $2}' | xargs kill &> /dev/null
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
