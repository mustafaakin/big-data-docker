# TODO: Add it to all
cp conf/zoo.cfg.orig conf/zoo.cfg

echo "" >> conf/zoo.cfg
export IFS=","
var=1
for word in $PEERS; do
  echo "server.$var=$word:2888:3888" >> conf/zoo.cfg
  var=$((var+1))	
done
echo "" >> conf/zoo.cfg

echo $MYID > /data/myid

# Remove comments and empty lines
sed -i '/^#/ d'    conf/zoo.cfg
sed -i '/^\s*$/d'  conf/zoo.cfg

cat conf/zoo.cfg
echo "Starting Zookeeper"

java \
	-cp "$CLASSPATH" \
	-Dcom.sun.management.jmxremote \
	-Dcom.sun.management.jmxremote.local.only=false \
	-Dzookeeper.logs.dir=logs/ \
	-Dlog4j.configuration=file:conf/log4j.properties \
	org.apache.zookeeper.server.quorum.QuorumPeerMain \
	conf/zoo.cfg