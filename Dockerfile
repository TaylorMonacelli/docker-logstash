# Pull base image.
FROM dockerfile/ubuntu
MAINTAINER Rohit Dantas <rohit.dantas+docker@gmail.com>

RUN sudo apt-get -qq update
RUN sudo apt-get -qq install git curl
RUN curl https://raw.githubusercontent.com/TaylorMonacelli/ubuntu_taylor/master/setup.sh | sh -

# Download latest package lists
RUN apt-get update

# Install dependencies
RUN apt-get install -yq \
    openjdk-7-jre-headless \
    wget

# Download version 1.4.2 of logstash
RUN cd /tmp && \
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
    tar -xzvf ./logstash-1.4.2.tar.gz && \
    mv ./logstash-1.4.2 /opt/logstash && \
    rm ./logstash-1.4.2.tar.gz

# Ensure Default Conf
RUN mkdir -p /opt/conf
ADD conf/logstash.conf /opt/conf/logstash.conf

# Elasticsearch
EXPOSE 9200

# Kibana
EXPOSE 9292

# Syslog
EXPOSE 514

# Start logstash
ENTRYPOINT /opt/logstash/bin/logstash agent -f /opt/conf/logstash.conf web
