# Wazuh Docker Builder

This repository offers an alternative to the [wazuh-docker project](https://github.com/wazuh/wazuh-docker), introducing several improvements and additional features. The primary focus is on building Docker images through a CI/CD pipeline for both amd64 and arm64 platforms. This extends the original project's compatibility by adding support for arm64.

## Key Features

- **CI/CD Pipeline**: Automates the build process and deployment of Docker images.
- **Multi-architecture Support**: Builds images for both amd64 and arm64 architectures.
- **Docker Hub**: Publishes the built images to [Docker Hub](https://hub.docker.com/u/kalingth).

## Container User Customization

- The user inside the container is modified to have:
  - **UID**: 9255
  - **GID**: 9255

- The OS inside the container is modified to `debian-12`

## Security Enhancements

- **NodeJS**: Updated to the latest version of NodeJS 18 to mitigate security vulnerabilities.
- **Java**: Updated to the latest version of Java 22 for enhanced security.

## Bug Fixes

- **OpenSearch Dashboards Keystore**: The keystore is no longer recreated if it already exists, unless the environment variable `ENFORCE_USER_OVERWRITE` is specified.
- **wazuh.yml File in Dashboards**: Prevents the incorrect recreation of the `wazuh.yml` file if it already exists, which was previously triggered by the absence of the magic number `1513629884013`.

## Getting Started

To pull the latest images from Docker Hub, use the following commands:
- docker pull kalingth/wazuh-indexer:`<tag>`
- docker pull kalingth/wazuh-dashboard:`<tag>`
- docker pull kalingth/wazuh-manager:`<tag>`

Replace `<tag>` with the appropriate values for your desired image.

For more information, visit the [Docker Hub repository](https://hub.docker.com/u/kalingth).
