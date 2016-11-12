FROM mustafaakin/java

# Set versions
ARG ZK_LINK=http://ftp.itu.edu.tr/Mirror/Apache/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
ENV ZK_HOME /opt/kafka/

# Download and extract, set <ahome folder and permissions
RUN useradd -ms /bin/bash zookeeper --home $ZK_HOME && wget -qO- $ZK_LINK | tar xvz --strip 1 -C $ZK_HOME && chown zookeeper -R $ZK_HOME
RUN mkdir -p /data && chown zookeeper /data

# Create folders and own
RUN mkdir -p /data && chown zookeeper /data
VOLUME /data

# Add required files and some files
ADD entrypoint.sh $ZK_HOME/
ADD zoo.cfg $ZK_HOME/conf/zoo.cfg.orig

USER zookeeper
RUN mkdir -p $ZK_HOME/logs

# Entry point
WORKDIR $ZK_HOME
ENV CLASSPATH "conf/log4j.properties:lib/*:$ZK_HOME/*"
ENTRYPOINT ["bash", "entrypoint.sh"]
