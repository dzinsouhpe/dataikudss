#!/bin/bash

# Init DSS if not installed
cd /opt/dataiku && dataiku-dss-6.0.4/installer.sh -d /opt/dataiku/data -p 11000

# Setup Hadoop libraries
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk/

# Setup DSS Hadoop integration
echo "DSS Keytab:    $1"
echo "DSS Principal: $2"
/opt/dataiku/data/bin/dssadmin install-hadoop-integration -keytab $1 -principal $2

# Setup DSS Spark integration
export SPARK_HOME=/usr/local/spark-2.4.5-bin-hadoop2.7/
/opt/dataiku/data/bin/dssadmin install-spark-integration -sparkHome $SPARK_HOME

# Start DSS
/opt/dataiku/data/bin/dss run
