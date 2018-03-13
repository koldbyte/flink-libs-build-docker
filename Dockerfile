FROM maven:3.5.3-jdk-8-alpine

LABEL maintainer="Bhaskar Divya <bhaskar.divya007@gmail.com>"
LABEL version="1.0"
LABEL description="Image for building libraries including the optional connectors available in Flink"

ENV FLINK_VERSION=1.4.2 \
    HADOOP_VERSION=2.7.3

VOLUME /opt/flink/

RUN cd /opt/flink \
    # Download the Flink release
    && curl -L -O "https://github.com/apache/flink/archive/release-$FLINK_VERSION.tar.gz" \
    && tar -xzf "release-$FLINK_VERSION.tar.gz" \
    # Build
    && cd "flink-release-$FLINK_VERSION" \
    && mvn clean install -DskipTests -Dhadoop.version=$HADOOP_VERSION \
    && cd flink-dist \
    && mvn clean install -Pinclude-kinesis -DskipTests -Dhadoop.version=$HADOOP_VERSION \
    # Cleanup
    && rm -rf "/opt/flink/release-$FLINK_VERSION.tar.gz"
    && echo "!!BUILD DONE!!"
    
ENTRYPOINT ["tail", "-f", "/dev/null"]
