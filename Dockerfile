FROM maven:3.5.3-jdk-8-alpine

LABEL maintainer="Bhaskar Divya <bhaskar.divya007@gmail.com>"
LABEL version="1.0"
LABEL description="Image for building libraries including the optional connectors available in Flink"

ENV FLINK_VERSION=1.4.2 \
    HADOOP_VERSION=2.7.3

RUN mkdir /opt/flink \
    && cd /opt/flink \
    # Download the Flink release
    && curl -L -O "https://github.com/apache/flink/archive/release-$FLINK_VERSION.tar.gz" \
    && tar -xzf "release-$FLINK_VERSION.tar.gz" \
    # Build
    && cd "flink-release-$FLINK_VERSION" \
    && mvn clean install -DskipTests -Dmaven.javadoc.skip=true -Dcheckstyle.skip=true -Pinclude-kinesis -Dhadoop.version=$HADOOP_VERSION -q \
    && cd flink-dist \
    && mvn clean install -DskipTests -Dmaven.javadoc.skip=true -Dcheckstyle.skip=true -Pinclude-kinesis -Dhadoop.version=$HADOOP_VERSION -q \
    && mv /root/.m2/repository/org/apache/flink /opt/flink/flink-libs \
    # Cleanup
    && rm -rf "/opt/flink/release-$FLINK_VERSION.tar.gz" \
    && rm -rf /root/.m2 \
    && echo "!!BUILD DONE!!"

VOLUME /opt/flink/

ENTRYPOINT ["tail", "-f", "/dev/null"]
