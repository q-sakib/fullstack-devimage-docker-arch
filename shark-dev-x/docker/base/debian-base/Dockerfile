# ===============================================================
# 📦 Debian Base Image
# Lean, consistent dev environment for all builds
# ===============================================================

FROM debian:bookworm-slim

LABEL maintainer="DevOps Team <devops@yourdomain.com>"
ENV DEBIAN_FRONTEND=noninteractive

# ---------------------------------------------------------------
# 🧰 Install core dependencies
# ---------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  curl \
  wget \
  git \
  zsh \
  vim \
  nano \
  locales \
  python3 \
  python3-pip \
  python3-venv \
  ca-certificates \
  netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------
# 🌍 Locale & Python setup
# ---------------------------------------------------------------
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ---------------------------------------------------------------
# 👤 Create a non-root user
# ---------------------------------------------------------------
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /usr/bin/zsh \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

# ---------------------------------------------------------------
# 🛠️ Copy setup scripts
# ---------------------------------------------------------------
COPY setup_base.sh /tmp/setup_base.sh
RUN chmod +x /tmp/setup_base.sh && /tmp/setup_base.sh

USER $USERNAME
WORKDIR /home/$USERNAME

CMD ["zsh"]
