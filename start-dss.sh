#!/bin/bash

# Init DSS if not installed
cd /opt/dataiku && dataiku-dss-6.0.4/installer.sh -d /opt/dataiku/data -p 11000

# Setup Hadoop libraries
export JAVA_HOME=/usr/lib/jvm/jre-openjdk/ && /opt/dataiku/data/bin/dssadmin install-hadoop-integration

# Start DSS
/opt/dataiku/data/bin/dss run
