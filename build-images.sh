#!/bin/bash
echo "# Building Java"
docker build -t java        java/

echo "# Building Zoookeeper"
docker build -t zookeeper   zookeeper/

echo "# Building Kafka"
docker build -t kafka       kafka/