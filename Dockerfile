FROM centos:7
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
RUN su - dataiku -c "cd /opt/dataiku && dataiku-dss-6.0.4/installer.sh -d /opt/dataiku/dss-6.0.4 -p 11000"
RUN su - dataiku -c "rm -rf /opt/dataiku/dataiku-dss-6.0.4.tar.gz"

COPY hdp.repo /etc/yum.repos.d/hdp.repo
RUN yum install -y hadoop-client
RUN su - dataiku -c "/opt/dataiku/dss-6.0.4/bin/dssadmin install-hadoop-integration"

WORKDIR /opt/dataiku/
USER dataiku

EXPOSE 11000

ENTRYPOINT ["/opt/dataiku/dss-6.0.4/bin/dss", "run"]
