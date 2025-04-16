FROM mcr.microsoft.com/azure-cli:2.56.0

RUN az bicep install
RUN apk add --no-cache jq git bash

COPY mirror_avms_to_acr.sh /scripts/mirror_avms_to_acr.sh
ENTRYPOINT ["bash", "/scripts/mirror_avms_to_acr.sh"]
