#!/bin/bash

BOOTSTRAP_SERVER=$1

# User 토픽 생성
/kafka/bin/kafka-topics.sh --create --bootstrap-server ${BOOTSTRAP_SERVER} \
		--replication-factor 2 --partitions 2 --topic User

# Order 토픽 생성
/kafka/bin/kafka-topics.sh --create --bootstrap-server ${BOOTSTRAP_SERVER} \
		--replication-factor 2 --partitions 2 --topic Order
