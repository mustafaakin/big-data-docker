docker network create --subnet 10.0.50.1/24 mynet

for i in {1..3}; do
   docker run -d --network=mynet --name=zk$i -e MYID=$i \
     -e PEERS=zk1,zk2,zk3 \
     mustafaakin/zookeeper
done

for i in {1..5}; do
   docker run -d --network=mynet --name=kafka$i \
     -e BROKERID=$i -e ZKHOSTS=zk1,zk2,zk3 -e IFACE=eth0 \
     mustafaakin/kafka
done

docker volume create --name mydata1

docker run -h namenode1 --rm \
    --network=mynet \
    -e NAMENODE=namenode1 \
    --name=namenode1 -it \
    -v mydata1:/data \
    mustafaakin/hadoop namenode -format

docker run -p 50070:50070 -d -h namenode1 \
    --network=mynet \
    -e NAMENODE=namenode1 \
    --name=namenode1 -it \
    -v mydata1:/data \
    mustafaakin/hadoop namenode

for i in {1..5}; do
  docker volume create --name hadoopdata$i
  docker run --net=mynet -d -e NAMENODE=namenode1 \
     --name=datanode$i -it \
     -v hadoopdata$i:/data \
      mustafaakin/hadoop datanode
done

ZKHOSTS="zk1:2181,zk2:2181,zk3:2181"
HDFS="namenode1:8020"
HASTORAGEDIR="flink-ha/"
ZKROOT="/flink"
SLOTS="8"
CHECKPOINTDIR="checkpoints/"
IFACE="eth0"
for i in {1..3}; do
    docker run -d -p 1808$i:8081 --net=mynet \
        --name=jobmanager$i \
         -e ZKHOSTS=$ZKHOSTS \
         -e HDFS=$HDFS \
         -e HASTORAGEDIR=$HASTORAGEDIR \
         -e ZKROOT=$ZKROOT \
         -e SLOTS=$SLOTS \
         -e CHECKPOINTDIR=$CHECKPOINTDIR \
         -e IFACE=$IFACE \
         mustafaakin/flink jobmanager
done
for i in {1..8}; do
    docker run -d --net=mynet \
        --name=taskmanager$i \
         -e ZKHOSTS=$ZKHOSTS \
         -e HDFS=$HDFS \
         -e HASTORAGEDIR=$HASTORAGEDIR \
         -e ZKROOT=$ZKROOT \
         -e SLOTS=$SLOTS \
         -e CHECKPOINTDIR=$CHECKPOINTDIR \
         -e IFACE=$IFACE \
         mustafaakin/flink taskmanager
done

ZKHOSTS="zk1,zk2,zk3"
CLUSTERID="mydrillcluster"
for i in {1..10}; do
    docker run -d --net=mynet \
        --name=drill$i \
         -e ZKHOSTS=$ZKHOSTS \
         -e CLUSTERID=$CLUSTERID \
         mustafaakin/drill
done
