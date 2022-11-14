#!/bin/bash

BOOTSTRAP_SERVER=$1
TOPIC_NAME=$2

/kafka/bin/kafka-console-consumer.sh --bootstrap-server ${BOOTSTRAP_SERVER} \
--consumer.config client.properties --topic ${TOPIC_NAME} --from-beginning