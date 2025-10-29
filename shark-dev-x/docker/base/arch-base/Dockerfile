# ===============================================================
# 📦 Arch Linux Base Image
# Optimized, lean, rolling-release dev environment
# ===============================================================

FROM archlinux:latest

LABEL maintainer="DevOps Team <devops@yourdomain.com>"

# ---------------------------------------------------------------
# 🧰 Install core dependencies
# ---------------------------------------------------------------
RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  sudo \
  zsh \
  git \
  curl \
  wget \
  vim \
  nano \
  python \
  python-pip \
  base-devel \
  unzip \
  && pacman -Scc --noconfirm \
  && rm -rf /var/cache/pacman/pkg/*

# ---------------------------------------------------------------
# 👤 Create non-root user
# ---------------------------------------------------------------
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd -g $USER_GID $USERNAME \
  && useradd -m -u $USER_UID -g $USER_GID -s /bin/zsh $USERNAME \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

# ---------------------------------------------------------------
# 🛠️ Copy setup scripts
# ---------------------------------------------------------------
COPY setup_base.sh /tmp/setup_base.sh
RUN chmod +x /tmp/setup_base.sh && /tmp/setup_base.sh

USER $USERNAME
WORKDIR /home/$USERNAME

CMD ["zsh"]
