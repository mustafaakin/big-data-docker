sed -i "s|%ZKHOSTS%|$ZKHOSTS|"      conf/drill-override.conf
sed -i "s|%CLUSTERID%|$CLUSTERID|"  conf/drill-override.conf

echo "The drill config is:"
cat conf/drill-override.conf
echo "Starting DrillBit"

java \
	-Xms4G \
	-Xmx4G \
	-XX:MaxDirectMemorySize=8G \
	-XX:ReservedCodeCacheSize=1G \
	-Ddrill.exec.enable-epoll=false \
	-XX:MaxPermSize=512M \
	-XX:+CMSClassUnloadingEnabled \
	-XX:+UseG1GC \
	-Dlog.path=log/drillbit.log \
	-Dlog.query.path=log/drillbit_queries.json \
	-cp conf/:jars/*:jars/ext/*:jars/3rdparty/*:jars/classb/* \
	org.apache.drill.exec.server.Drillbit