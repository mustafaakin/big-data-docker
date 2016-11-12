set -e

CONF_FILE="etc/hadoop/core-site.xml"
cp $CONF_FILE.orig $CONF_FILE
sed -i 's|%NAMENODE%|'$NAMENODE'|'              $CONF_FILE

echo "=== Core Site XML  ==="
cat etc/hadoop/core-site.xml
echo "=== HDFS Site XML  ==="
cat etc/hadoop/hdfs-site.xml


COMMAND=$1
shift 

# TODO: Extract this portition to another script so it can 
# be used inside containers as well for administration tasks
if [ "$COMMAND" == "datanode" ]; then
	CLASS="org.apache.hadoop.hdfs.server.datanode.DataNode"
elif [ "$COMMAND" == "namenode" ]; then
	CLASS="org.apache.hadoop.hdfs.server.namenode.NameNode"
elif [ "$COMMAND" == "dfs" ]; then
	CLASS="org.apache.hadoop.fs.FsShell"
else
	echo "Command not supported $COMMAND"
	exit 1
fi

java -Dproc_$COMMAND \
	-Dproc_$COMMAND \
	-Xmx1000m \
	-Djava.net.preferIPv4Stack=true \
	-Dhadoop.home.dir=$HADOOP_HOME \
	-Dhadoop.id.str=root \
	-Dhadoop.root.logger=INFO,console \
	-Djava.library.path=$HADOOP_HOME/lib/native \
	-Dhadoop.policy.file=hadoop-policy.xml \
	-Dhadoop.security.logger=INFO,RFAS \
	$CLASS "$@"