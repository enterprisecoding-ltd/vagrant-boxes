#!/bin/bash

# Parse arguments
while [ $# -gt 0 ]
do
  case "$1" in
    "--joinScript")
      if [ $# -lt 2 ]
      then
        echo "Missing parameter"
	    exit 1
      fi
      JoinScript="$2"
      shift; shift
      ;;
    *)
      echo "Invalid parameter"
      exit 1
      ;;
  esac
done

echo "Joining node to Kubernetes Cluster"
bash "/vagrant/${JoinScript}"