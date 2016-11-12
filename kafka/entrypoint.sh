set -e

# Copy the original file so that we do not accidentally change server.properties
cp config/server.properties.orig config/server.properties

# Replace given parameters
sed -i 's|%ZKHOSTS%|'$ZKHOSTS'|' config/server.properties
sed -i 's|%BROKERID%|'$BROKERID'|'  config/server.properties

# Put IP address as advertised address
IPADDR=$(ifconfig $IFACE | grep "inet addr:" | cut -d : -f 2 | cut -d " " -f 1)
sed -i 's|%HOSTNAME%|'$IPADDR'|'  config/server.properties

# Remove comments and empty lines
sed -i '/^#/ d'   config/server.properties
sed -i '/^\s*$/d' config/server.properties

echo "The Kafka config is:"
cat config/server.properties
echo "Starting Kafka"

java \
	-Xmx256M \
	-Xms128M \
	-server \
	-XX:+UseG1GC \
	-XX:MaxGCPauseMillis=20 \
	-XX:InitiatingHeapOccupancyPercent=35 \
	-XX:+DisableExplicitGC \
	-Dcom.sun.management.jmxremote \
	-Dcom.sun.management.jmxremote.authenticate=false \
	-Dcom.sun.management.jmxremote.ssl=false \
	-Dcom.sun.management.jmxremote.port=9999 \
	-Djava.awt.headless=true \
	-Dkafka.logs.dir=logs/ \
	-Dlog4j.configuration=file:config/log4j.properties \
	-cp :libs/* \
	kafka.Kafka \
	config/server.properties