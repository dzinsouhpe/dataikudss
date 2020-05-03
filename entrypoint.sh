#!/bin/bash

# Set permissions on directories
chown -R dataiku /opt/dataiku/data

# Init and start DSS
runuser -l dataiku /opt/dataiku/start-dss.sh
