#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. (License GPLv2)

INSTALL_DIR=/usr/share/wazuh-dashboard
DASHBOARD_USERNAME="${DASHBOARD_USERNAME:-kibanaserver}"
DASHBOARD_PASSWORD="${DASHBOARD_PASSWORD:-kibanaserver}"

# Create and configure Wazuh dashboard keystore

if [[ ! -f "$INSTALL_DIR/config/opensearch_dashboards.keystore" ]];
then
    yes | $INSTALL_DIR/bin/opensearch-dashboards-keystore create --allow-root;
    echo $DASHBOARD_USERNAME | $INSTALL_DIR/bin/opensearch-dashboards-keystore add opensearch.username --stdin --allow-root;
    echo $DASHBOARD_PASSWORD | $INSTALL_DIR/bin/opensearch-dashboards-keystore add opensearch.password --stdin --allow-root;
elif [[ "$ENFORCE_USER_OVERWRITE" == 'true' ]];
then
    $INSTALL_DIR/bin/opensearch-dashboards-keystore remove opensearch.username --allow-root;
    echo $DASHBOARD_USERNAME | $INSTALL_DIR/bin/opensearch-dashboards-keystore add opensearch.username --stdin --allow-root;
    $INSTALL_DIR/bin/opensearch-dashboards-keystore remove opensearch.password --allow-root;
    echo $DASHBOARD_PASSWORD | $INSTALL_DIR/bin/opensearch-dashboards-keystore add opensearch.password --stdin --allow-root;
fi;

##############################################################################
# Start Wazuh dashboard
##############################################################################

/wazuh_app_config.sh $WAZUH_UI_REVISION

/usr/share/wazuh-dashboard/bin/opensearch-dashboards -c /usr/share/wazuh-dashboard/config/opensearch_dashboards.yml