FROM debian:bookworm-slim

LABEL maintainer="DevOps Team <devops@yourdomain.com>"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo curl wget git zsh vim nano locales ca-certificates \
  python3 python3-pip python3-venv python3-dev build-essential \
  unzip zip netcat-openbsd gnupg \
  && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

COPY ../../shared /opt/docker-shared
COPY setup_base.sh /opt/setup_base.sh
RUN chmod +x /opt/setup_base.sh && bash /opt/setup_base.sh

ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000
ENV DEV_USER=${DEV_USER} DEV_UID=${DEV_UID} DEV_GID=${DEV_GID}

RUN /opt/docker-shared/user_setup.sh /opt/docker-shared

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}
ENTRYPOINT ["/opt/docker-shared/entrypoint.sh"]
CMD ["zsh"]
