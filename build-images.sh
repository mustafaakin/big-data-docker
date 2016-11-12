#!/bin/bash
set -e 

echo "# Building Java"
docker build -q -t mustafaakin-java        java/

echo "# Building Zoookeeper"
docker build -q -t mustafaakin-zookeeper   zookeeper/

echo "# Building Kafka"
docker build -q -t mustafaakin-kafka       kafka/

echo "# Building Hadoop"
docker build -q -t mustafaakin-hadoop      hadoop/

echo "# Building Flink"
docker build -q -t mustafaakin-flink       flink/

echo "# Building Drill"
docker build -q -t mustafaakin-drill       drill/