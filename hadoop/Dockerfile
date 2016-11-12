FROM mustafaakin/java

# Set versions
ARG HADOOP_LINK=http://ftp.itu.edu.tr/Mirror/Apache/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
ENV HADOOP_HOME /opt/hadoop/


# Download and extract, set home folder and permissions
RUN useradd -ms /bin/bash hadoop --home $HADOOP_HOME && wget -qO- $HADOOP_LINK | tar xvz --strip 1 -C $HADOOP_HOME && chown hadoop -R $HADOOP_HOME
RUN mkdir -p /data && chown hadoop /data

USER hadoop

ENV CLASSPATH=$HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:/contrib/capacity-scheduler/*.jar:/contrib/capacity-scheduler/*.jar:/contrib/capacity-scheduler/*.jar
ENV LD_LIBRARY_PATH=:$HADOOP_HOME/lib/native

ENV HADOOP_HDFS_HOME=HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_CLASSPATH=/contrib/capacity-scheduler/*.jar
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_ROOT_LOGGER=INFO,RFA
ENV HADOOP_CLASSPATH=/contrib/capacity-scheduler/*.jar

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

ADD entrypoint.sh $HADOOP_HOME/
ADD core-site.xml $HADOOP_CONF_DIR/core-site.xml.orig
ADD hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml


WORKDIR $HADOOP_HOME
ENTRYPOINT ["bash", "entrypoint.sh"]
