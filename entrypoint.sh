#!/bin/bash

# Set permissions on directories
chown -R dataiku /opt/dataiku/data

# Check datatap connectivity
hdfs dfs -ls dtap://test/

# Init and start DSS
if [[ -z "${DSS_KEYTAB_FILE}" || -z "${DSS_KERBEROS_PRINCIPAL}" ]]; then
  echo "Kerberos disabled"
  runuser -l dataiku /opt/dataiku/start-dss.sh
else
  echo "Kerberos enabled"
  runuser -l dataiku /opt/dataiku/start-dss-krb5.sh $DSS_KEYTAB_FILE $DSS_KERBEROS_PRINCIPAL
fi
