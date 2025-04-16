FROM mcr.microsoft.com/azure-cli:2.56.0

RUN az bicep install
RUN apk add --no-cache jq git bash

COPY mirror_avms_to_acr.sh /scripts/mirror_avms_to_acr.sh

# Ensure it's executable
RUN chmod +x /scripts/mirror_avms_to_acr.sh

# Add log to show container booted
RUN echo "echo '🟢 Running container and starting mirror script'" >> /scripts/entrypoint.sh
RUN echo "bash /scripts/mirror_avms_to_acr.sh" >> /scripts/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
