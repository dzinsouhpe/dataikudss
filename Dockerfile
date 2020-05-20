FROM bluedata/centos7:latest
LABEL maintainer="dietrich.zinsou@hpe.com"

COPY nginx.repo hdp.repo /etc/yum.repos.d/

RUN yum install -y epel-release && yum install -y java-1.8.0-openjdk htop vim wget net-tools git unzip zip python3 libgfortran libgomp nginx hadoop-client hive

RUN useradd dataiku && mkdir /opt/dataiku && chown dataiku:dataiku /opt/dataiku && \
su - dataiku -c "cd /opt/dataiku && wget https://cdn.downloads.dataiku.com/public/dss/6.0.4/dataiku-dss-6.0.4.tar.gz" && \
su - dataiku -c "cd /opt/dataiku && tar xzf dataiku-dss-6.0.4.tar.gz" && \
su - dataiku -c "rm -rf /opt/dataiku/dataiku-dss-6.0.4.tar.gz"

# Prepare Hadoop configuration for datatap
COPY bluedata /opt/bluedata
RUN chmod -R 644 /opt/bluedata/bluedata-dtap.jar && chmod -R 755 /opt/bluedata/libjni_memq_cnode.so
COPY hadoop/conf/core-site.xml hadoop/conf/hdfs-site.xml hadoop/conf/hadoop-env.sh /etc/hadoop/conf/

# Install Spark client
RUN cd /tmp && \
    wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    echo "2426a20c548bdfc07df288cd1d18d1da6b3189d0b78dee76fa034c52a4e02895f0ad460720c526f163ba63a17efae4764c46a1cd8f9b04c60f9937a554db85d2 *spark-2.4.5-bin-hadoop2.7.tgz" | sha512sum -c - && \
    tar xzf spark-2.4.5-bin-hadoop2.7.tgz -C /usr/local --owner root --group root --no-same-owner && \
    rm spark-2.4.5-bin-hadoop2.7.tgz && cd /usr/local && ln -s spark-2.4.5-bin-hadoop2.7 spark

# Install Anaconda
RUN yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver -y && wget -O /tmp/Anaconda3-2020.02-Linux-x86_64.sh https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh && chmod +x /tmp/Anaconda3-2020.02-Linux-x86_64.sh && /tmp/Anaconda3-2020.02-Linux-x86_64.sh -b -p /opt/conda && rm -rf /tmp/Anaconda3-2020.02-Linux-x86_64.sh 
RUN ln -s /opt/conda/bin/conda /usr/bin/conda

# Prepare entrypoint
USER root

WORKDIR /opt/dataiku/
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk

COPY start-dss.sh start-dss-krb5.sh entrypoint.sh /opt/dataiku/

EXPOSE 11000

ENTRYPOINT ["/opt/dataiku/entrypoint.sh"]
