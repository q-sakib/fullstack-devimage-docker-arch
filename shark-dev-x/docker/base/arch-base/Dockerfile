FROM archlinux:latest

LABEL maintainer="DevOps Team <devops@yourdomain.com>"

# ---------------------------------------------------------------
# 🧰 Core Packages
# ---------------------------------------------------------------
RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  sudo zsh git curl wget vim nano python python-pip \
  base-devel unzip zip which netcat && \
  pacman -Scc --noconfirm && rm -rf /var/cache/pacman/pkg/*

# ---------------------------------------------------------------
# 🧱 Copy Shared Scripts
# ---------------------------------------------------------------
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
