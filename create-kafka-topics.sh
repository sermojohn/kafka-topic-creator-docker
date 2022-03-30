#!/bin/bash
set -x
# Script to create the list of provided topics against the accessible Kafka service.
#
# arguments:
# KAFKA_HOST: Kafka host that runs and exposes Kafka service
# KAFKA_PORT: Kafka exposed port
# CREATE_TOPICS: List of space separated topics to create in the form of topic_name:partitions:replication_factor:cleanup_policy

# Set a trap for SIGINT and SIGTERM signals
trap "echo 'interrupted...' && exit 1" SIGTERM SIGINT

kaf="./kaf"

# wait_for_kafka polls until kafka is running
function wait_for_kafka() {
    START_TIMEOUT=60
    count=0
    step=2
    while ! nc -z $KAFKA_HOST $KAFKA_PORT 2>&1; do
        echo "waiting for kafka to be ready"
        sleep $step
        count=$((count + step))
        if [ $count -gt $START_TIMEOUT ]; then
            echo "timed out waiting for kafka"
            exit 1
        fi
    done

}

# create_topics iterates and triggers creation of all topics using the given parameters (partitions, replication factor and cleanup policy).
function create_topics() {
    for topicToCreate in $CREATE_TOPICS; do
        if [[ -z ${topicToCreate} ]]; then
            :
        else
            echo "creating topics: $topicToCreate"
            IFS=':' read -r -a topicConfig <<<"$topicToCreate"
            config=
            if [ "${topicConfig[3]}" == "compact" ]; then
                config="--compact"
            fi

            $kaf -b $KAFKA_HOST:$KAFKA_PORT topic create ${topicConfig[0]} -p ${topicConfig[1]} -r ${topicConfig[2]} $config
            status=$?
            if [[ $status != 0 ]]; then
                exit $status
            fi
        fi
    done
}

wait_for_kafka
create_topics
