FROM mustafaakin/java

# Set versions
ARG FLINK_LINK=http://ftp.itu.edu.tr/Mirror/Apache/flink/flink-1.1.3/flink-1.1.3-bin-hadoop27-scala_2.11.tgz
ENV FLINK_HOME /opt/flink/

# Download and extract, set home folder and permissions
RUN useradd -ms /bin/bash flink --home $FLINK_HOME && wget -qO- $FLINK_LINK | tar xvz --strip 1 -C $FLINK_HOME && chown flink -R $FLINK_HOME

USER flink
WORKDIR $FLINK_HOME
ADD entrypoint.sh $FLINK_HOME/
ADD log4j.properties  $FLINK_HOME/conf/log4j.properties
ADD flink-conf.yaml   $FLINK_HOME/conf/flink-conf.yaml.orig

ENTRYPOINT ["bash", "entrypoint.sh"]
