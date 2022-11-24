#!/bin/bash

BOOTSTRAP_SERVER=$1
INIT_USER_COUNT=$2
USER_COUNT_IN_LOOP=$3
RATIO_ORDER_USER=$4
INTER_MESSAGE_SECOND=$5
INTER_ITER_SECOND=$6

python3 kafka/producer/main.py -bs ${BOOTSTRAP_SERVER} \
	-iuc ${INIT_USER_COUNT} \
        -uc ${USER_COUNT_IN_LOOP} \
        -r ${RATIO_ORDER_USER} \
        -mt ${INTER_MESSAGE_SECOND} \
        -it ${INTER_ITER_SECOND}
