
FROM    dockerimages/docker-java-oracle:7
MAINTAINER  Frank Lemanschik

ENV SOLR_VERSION 4.10.2
ENV SOLR solr-$SOLR_VERSION
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get -y install lsof curl procps \
 && mkdir -p /opt \
 && wget -nv --output-document=/opt/$SOLR.tgz http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
 && tar -C /opt --extract --file /opt/$SOLR.tgz \
 && rm /opt/$SOLR.tgz \
 && ln -s /opt/$SOLR /opt/solr
EXPOSE 8983
# We will Put Our Image dockerimages/systemd-solr over that you should directly build that if you plan to run this in production
CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -f"]
