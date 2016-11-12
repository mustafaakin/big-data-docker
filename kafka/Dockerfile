FROM mustafaakin/java

# Set versions
ARG KAFKA_LINK=http://ftp.itu.edu.tr/Mirror/Apache/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
ENV KAFKA_HOME /opt/kafka/
ENV KAFKA_LOG_DIR $KAFKA_HOME/logs

# Download and extract, set home folder and permissions
RUN useradd -ms /bin/bash kafka --home $KAFKA_HOME && wget -qO- $KAFKA_LINK | tar xvz --strip 1 -C $KAFKA_HOME && chown kafka -R $KAFKA_HOME
RUN mkdir -p /data && chown kafka /data

# Add required files and some files
ADD entrypoint.sh $KAFKA_HOME/
ADD server.properties $KAFKA_HOME/config/server.properties.orig
USER kafka
RUN mkdir -p $KAFKA_LOG_DIR/ 
WORKDIR $KAFKA_HOME
VOLUME /data
ENTRYPOINT ["bash", "entrypoint.sh"]
