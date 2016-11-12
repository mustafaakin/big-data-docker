# big-data-docker

Better, container friendly big-data images for Docker. You can read the reasoning and discussuion [my blog]().

## An example invocation of the Docker images

**Note:** Remember that, although these commands are executed on a single server for simplicity; they can be easily abstracted  to many servers using Docker Swarm and Multi Host networking accordingly, this is just to give you an idea, these 36 containers takes around 10 GB of RAM, and only 30 seconds on a 4 core server.

This is the content of the `rise-my-cluster.sh` with some explanation.

First we create a private network.

```bash
docker network create --subnet 10.0.50.1/24 mynet
```

Then we start the zookeeper, start in numbers 3,5,7,9 to actually make use of high availabilty but do not spawn too many.

```bash
for i in {1..3}; do
   docker run -d --network=mynet --name=zk$i -e MYID=$i \
     -e PEERS=zk1,zk2,zk3 \
     mustafaakin/zookeeper
done
```

Kafka instances can be easily scaled, upto 255. It really depends on your data usage, but at least 3 is required in my image, since the replication factor is 3.

```bash
for i in {1..5}; do
   docker run -d --network=mynet --name=kafka$i \
     -e BROKERID=$i -e ZKHOSTS=zk1,zk2,zk3 -e IFACE=eth0 \
     mustafaakin/kafka
done
```

We will start a Hadoop namenode. We create a volume through Docker, since it handles the permissions better, and format it:

```bash
docker volume create --name mydata1
docker run -h namenode1 --rm \
    --network=mynet \
    -e NAMENODE=namenode1 \
    --name=namenode1 -it \
    -v mydata1:/data \
    mustafaakin/hadoop namenode -format
```

After formatting,  we start a new namenode instance. Beware that in real production enviroments you need high availability which is pretty detailed. I did not include it for simplicity, but I will add hadoop-ha for better images in near future.

```bash
docker run -p 50070:50070 -d -h namenode1 \
    --network=mynet \
    -e NAMENODE=namenode1 \
    --name=namenode1 -it \
    -v mydata1:/data \
    mustafaakin/hadoop namenode
```

Now we have created a namenode, we can start datanotes that will point to that namenode, and again create their volumes using Docker.

```bash
for i in {1..5}; do
  docker volume create --name hadoopdata$i
  docker run --net=mynet -d -e NAMENODE=namenode1 \
     --name=datanode$i -it \
     -v hadoopdata$i:/data \
      mustafaakin/hadoop datanode
done
```

Flink cluster is easy to setup, you first start JobManagers then TaskManagers. JobManagers are again recommended to use in numbers 1,3,5,7 and not much. But you can run TaskManagers as much as you want. Just be sure to calculate a proper slot number depending on your environment.

```bash
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
         flink jobmanager
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
         flink taskmanager
done
```

As for Drill, it is again simple. You need it to point to zookeeper and advertise your cluster id. You can run as much as of them you want, but it is better to run them with datanodes to improve data locality.

```bash
ZKHOSTS="zk1,zk2,zk3"
CLUSTERID="mydrillcluster"
for i in {1..10}; do
    docker run -d --net=mynet \
        --name=drill$i \
         -e ZKHOSTS=$ZKHOSTS \
         -e CLUSTERID=$CLUSTERID \
         drill
done
```

