CONF_FILE="conf/flink-conf.yaml"
cp conf/flink-conf.yaml.orig $CONF_FILE

sed -i 's|%ZKHOSTS%|'$ZKHOSTS'|'              $CONF_FILE
sed -i 's|%HDFS%|'$HDFS'|'                    $CONF_FILE
sed -i 's|%HASTORAGEDIR%|'$HASTORAGEDIR'|'    $CONF_FILE
sed -i 's|%ZKROOT%|'$ZKROOT'|'                $CONF_FILE
sed -i 's|%SLOTS%|'$SLOTS'|'                  $CONF_FILE
sed -i 's|%CHECKPOINTDIR%|'$CHECKPOINTDIR'|'  $CONF_FILE

cat conf/flink-conf.yaml

COMMAND=$1

if [ "$COMMAND" == "jobmanager" ]; then
	IPADDR=$(ifconfig $IFACE | grep "inet addr:" | cut -d : -f 2 | cut -d " " -f 1)
	java -cp "lib/*" \
		-Dproc_jobmanager \
		-Dlog4j.configuration=file:conf/log4j.properties \
		org.apache.flink.runtime.jobmanager.JobManager \
		--configDir conf/ \
		--executionMode cluster \
		--host $IPADDR
elif [ "$COMMAND" == "taskmanager" ]; then
	java -cp "lib/*" \
		-Dproc_taskmanager \
		-Dlog4j.configuration=file:conf/log4j.properties \
		org.apache.flink.runtime.taskmanager.TaskManager \
		--configDir conf/
else
	echo "Command not supported $COMMAND"
	exit 1
fi

