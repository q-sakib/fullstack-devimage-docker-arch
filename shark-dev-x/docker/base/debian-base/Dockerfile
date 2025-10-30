FROM debian:bookworm-slim

LABEL maintainer="Shark X 404 <que.sakib@outlook.com>"
ENV DEBIAN_FRONTEND=noninteractive

# Core packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo curl wget git zsh vim nano locales ca-certificates \
  python3 python3-venv python3-dev build-essential \
  unzip zip netcat-openbsd gnupg \
  && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Shared scripts
COPY docker/shared /opt/docker-shared
COPY docker/base/debian-base/setup_base.sh /opt/setup_base.sh

RUN chmod +x /opt/setup_base.sh && bash /opt/setup_base.sh

# Venv path in ENV for all derived stages
ENV PATH="/opt/venv/bin:$PATH"

ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000
ENV DEV_USER=${DEV_USER} DEV_UID=${DEV_UID} DEV_GID=${DEV_GID}

# Create user via shared script
RUN /opt/docker-shared/user_setup.sh /opt/docker-shared

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}
ENTRYPOINT ["/opt/docker-shared/entrypoint.sh"]
CMD ["zsh"]
