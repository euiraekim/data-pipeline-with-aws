#!/bin/bash

BOOTSTRAP_SERVER=$1
TOPIC_NAME=$2

~/kafka/bin/kafka-topics.sh --create --bootstrap-server ${BOOTSTRAP_SERVER} \
	--replication-factor 2 --partitions 2 --topic ${TOPIC_NAME}
