#!/bin/bash

BOOTSTRAP_SERVER=$1
TOPIC_NAME=$2

KAFKA_PATH="/kafka/bin"

${KAFKA_PATH}/kafka-console-consumer.sh --bootstrap-server ${BOOTSTRAP_SERVER} \
--consumer.config ${KAFKA_PATH}/client.properties --topic ${TOPIC_NAME} --from-beginning