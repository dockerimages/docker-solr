Solr on Docker
==============

Run [Solr](http://lucene.apache.org/solr/) on [Docker](https://www.docker.io/).

This repository triggers the [dockerimages/docker-solr](https://index.docker.io/u/dockerimages/docker-solr) trusted build on the Docker index.

!!!Importent Note!!! This is for Config and testing a Production Ready Image for Solr would be
[dockerimages/docker-solr-systemd](https://index.docker.io/u/dockerimages/docker-solr-systemd/)
For Infos how to Produce a Docker Production Ready Ubuntu env visit [dockerimages/production-env](https://github.com/dockerimages/production-env)

To run:

    docker run -it -p 127.0.0.1:8983:8983 -t dockerimages/docker-solr

Then go to http://localhost:8983/solr

You can run the SolrCloud example in a single container in the foreground:

    docker run -it -p 127.0.0.1:8983:8983 \
    -p 127.0.0.1:7574:7574 \
    dockerimages/docker-solr \
    /bin/bash -c "\
        /opt/solr/bin/solr -e cloud; echo hit return to quit; read";

You can run SolrCloud in separate containers too. For example:

run ZooKeeper, and define a name so we can link to it

    docker run -name zookeeper \
    -p 127.0.0.1:2181:2181 \
    -p 127.0.0.1:2888:2888 \
    -p 127.0.0.1:3888:3888 \
    jplock/zookeeper

run the first Solr node, with bootstrap parameters, and pass a link parameter to docker
so we can use the ZK_* environment variables in the container to locate the ZooKeeper container

    docker run -link zookeeper:ZK -i \
        -p 127.0.0.1:8983:8983 \
        -t dockerimages/docker-solr \
        /bin/bash -c '\
            cd /opt/solr/example; \
            java -jar \
            -Dbootstrap_confdir=./solr/collection1/conf \
            -Dcollection.configName=myconf \
            -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT \
            -DnumShards=2 \
            start.jar';

in separate sessions, run two more zookeepers

    docker run -i \
    -link zookeeper:ZK \
    -p 127.0.0.1:8984:8983 \
    -t dockerimages/docker-solr \
    /bin/bash -c '\
        cd /opt/solr/example; \
        java -jar \
        -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT \
        -DnumShards=2 \
        start.jar';
     
    docker run -i \
    -link zookeeper:ZK \
    -p 127.0.0.1:8985:8983 \
    -t dockerimages/docker-solr \
    /bin/bash -c '\
        cd /opt/solr/example; \
        java -jar \
        -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT \
        -DnumShards=2 \
        start.jar';

Then go to http://localhost:8983/solr/#/~cloud (adjust the hostname for your docker server) to see the two shards and three Solr nodes.
