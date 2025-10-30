FROM ubuntu:22.04
LABEL maintainer="Shark X 404 <que.sakib@outlook.com>"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo curl wget git zsh vim nano locales ca-certificates \
  python3 python3-venv python3-dev build-essential \
  unzip zip netcat-openbsd gnupg lsb-release \
  && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Shared scripts (optional)
COPY docker/shared /opt/docker-shared
COPY docker/base/ubuntu-base/setup_base.sh /opt/setup_base.sh

RUN [ -f /opt/setup_base.sh ] && chmod +x /opt/setup_base.sh && bash /opt/setup_base.sh || echo "⚠️ setup_base.sh missing, skipping"

ENV PATH="/opt/venv/bin:$PATH"

ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000
ENV DEV_USER=${DEV_USER} DEV_UID=${DEV_UID} DEV_GID=${DEV_GID}

RUN [ -d /opt/docker-shared ] && /opt/docker-shared/user_setup.sh /opt/docker-shared || echo "⚠️ user_setup.sh skipped"

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}
ENTRYPOINT ["/opt/docker-shared/entrypoint.sh"]
CMD ["zsh"]
