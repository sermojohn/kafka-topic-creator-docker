# Kafka topic create image
Docker image to create kafka topics wrapping a `kaf` Kafka CLI in Go.

The container will pool Kafka until it becomes available and afterwards create the provided topics.

# Supported env vars
| Name | Description |
|------|-------------|
| CREATE_TOPICS | Provides a space-separated list of topics to create and their configuration in the format of topic_name:partitions:replication_factor:cleanup_policy |
| KAFKA_HOST    | Kafka service host |
| KAFKA_PORT    | Kafka service port |
