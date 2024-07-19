REPOSITORY="packages.wazuh.com/4.x"
WAZUH_CURRENT_VERSION=$(curl --silent https://api.github.com/repos/wazuh/wazuh/releases/latest | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/' | cut -c 2-)
MAJOR_BUILD=$(echo $WAZUH_VERSION | cut -d. -f1)
MID_BUILD=$(echo $WAZUH_VERSION | cut -d. -f2)
MINOR_BUILD=$(echo $WAZUH_VERSION | cut -d. -f3)
MAJOR_CURRENT=$(echo $WAZUH_CURRENT_VERSION | cut -d. -f1)
MID_CURRENT=$(echo $WAZUH_CURRENT_VERSION | cut -d. -f2)
MINOR_CURRENT=$(echo $WAZUH_CURRENT_VERSION | cut -d. -f3)

## check version to use the correct repository
if [ "$MAJOR_BUILD" -gt "$MAJOR_CURRENT" ]; then
  REPOSITORY="packages-dev.wazuh.com/pre-release"
elif [ "$MAJOR_BUILD" -eq "$MAJOR_CURRENT" ]; then
  if [ "$MID_BUILD" -gt "$MID_CURRENT" ]; then
    REPOSITORY="packages-dev.wazuh.com/pre-release"
  elif [ "$MID_BUILD" -eq "$MID_CURRENT" ]; then
    if [ "$MINOR_BUILD" -gt "$MINOR_CURRENT" ]; then
      REPOSITORY="packages-dev.wazuh.com/pre-release"
    fi
  fi
fi


function getArch() {
  case $(arch) in
    'aarch64') echo "${FILEBEAT_CHANNEL}-${FILEBEAT_VERSION}-arm64.deb" ;;
    'x86_64')  echo "${FILEBEAT_CHANNEL}-${FILEBEAT_VERSION}-amd64.deb"     ;;
    *)
      echo "Architecture $(arch) not supported" >> /dev/stderr;
      exit 1;
    ;;
  esac
}

FILEBEAT_PKG=$(getArch);
curl -L -O "https://artifacts.elastic.co/downloads/beats/filebeat/${FILEBEAT_PKG}" &&\
dpkg -i "${FILEBEAT_PKG}" && rm -f "${FILEBEAT_PKG}" && \
curl -s https://${REPOSITORY}/filebeat/${WAZUH_FILEBEAT_MODULE} | tar -xvz -C /usr/share/filebeat/module
