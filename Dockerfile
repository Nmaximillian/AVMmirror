FROM mcr.microsoft.com/azure-cli:2.56.0

RUN az bicep install
RUN apk add --no-cache bash jq git

COPY mirror_avms_from_registry.sh /scripts/mirror_avms_from_registry.sh
RUN chmod +x /scripts/mirror_avms_from_registry.sh

ENTRYPOINT ["bash", "/scripts/mirror_avms_from_registry.sh"]
