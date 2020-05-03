FROM bluedata/centos7:latest
LABEL maintainer="dietrich.zinsou@hpe.com"

RUN yum install -y epel-release
RUN yum install -y java-1.8.0-openjdk htop vim wget net-tools git unzip zip python3 libgfortran libgomp

COPY nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum install -y nginx

RUN useradd dataiku
RUN mkdir /opt/dataiku
RUN chown dataiku:dataiku /opt/dataiku
RUN su - dataiku -c "cd /opt/dataiku && wget https://cdn.downloads.dataiku.com/public/dss/6.0.4/dataiku-dss-6.0.4.tar.gz"
RUN su - dataiku -c "cd /opt/dataiku && tar xzf dataiku-dss-6.0.4.tar.gz"
RUN su - dataiku -c "rm -rf /opt/dataiku/dataiku-dss-6.0.4.tar.gz"

COPY hdp.repo /etc/yum.repos.d/hdp.repo
RUN yum install -y hadoop-client

COPY bluedata /opt/bluedata
COPY hadoop/conf/core-site.xml /etc/hadoop/conf/core-site.xml
COPY hadoop/conf/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml
COPY hadoop/conf/hadoop-env.sh /etc/hadoop/conf/hadoop-env.sh
COPY hadoop/conf/hadoop-env.cmd /etc/hadoop/conf/hadoop-env.cmd
RUN chmod -R 644 /opt/bluedata/bluedata-dtap.jar
RUN chmod -R 755 /opt/bluedata/libjni_memq_cnode.so

WORKDIR /opt/dataiku/

COPY start-dss.sh /opt/dataiku/start-dss.sh
COPY entrypoint.sh /opt/dataiku/entrypoint.sh

EXPOSE 11000

ENTRYPOINT ["/opt/dataiku/entrypoint.sh"]
