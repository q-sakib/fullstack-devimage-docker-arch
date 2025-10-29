# ===================================================================
# 🌐 Fullstack Dev Container
# Python + Node.js + DB Clients
# Arch Base
# ===================================================================

FROM docker/base/arch-base AS fullstack

LABEL maintainer="DevOps Toolkit <devops@local>"
LABEL description="Fullstack dev image: Python + Node.js + DB clients + JS frameworks"

# -------------------------------------------------------------
# 1️⃣ Shared scripts
# -------------------------------------------------------------
COPY ../shared/user_setup.sh /tmp/user_setup.sh
COPY ../shared/common_env.sh /tmp/common_env.sh
COPY ../shared/zsh_aliases /tmp/zsh_aliases
COPY ../shared/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /tmp/user_setup.sh /usr/local/bin/entrypoint.sh \
  && /tmp/user_setup.sh \
  && echo "source /tmp/common_env.sh" >> ~/.zshrc \
  && echo "source /tmp/zsh_aliases" >> ~/.zshrc

# -------------------------------------------------------------
# 2️⃣ System packages
# -------------------------------------------------------------
USER root
RUN pacman -Syu --noconfirm \
  python python-pip python-virtualenv \
  nodejs npm yarn typescript ts-node \
  git vim curl wget unzip sudo \
  mariadb-libs postgresql-libs redis \
  && pacman -Scc --noconfirm \
  && rm -rf /var/cache/pacman/pkg/*

USER devuser
WORKDIR /home/devuser/fullstack

# -------------------------------------------------------------
# 3️⃣ Python virtual environment
# -------------------------------------------------------------
RUN python -m venv fullstack-env \
  && ./fullstack-env/bin/pip install --upgrade pip setuptools wheel

# -------------------------------------------------------------
# 4️⃣ Copy project requirements
# -------------------------------------------------------------
COPY requirements.txt .
RUN ./fullstack-env/bin/pip install -r requirements.txt

# -------------------------------------------------------------
# 5️⃣ Node environment setup
# -------------------------------------------------------------
RUN mkdir -p ~/.npm-global && npm config set prefix ~/.npm-global && \
  export PATH=$HOME/.npm-global/bin:$PATH

# -------------------------------------------------------------
# 6️⃣ Copy config folder (if exists)
# -------------------------------------------------------------
COPY config/ config/

# -------------------------------------------------------------
# 7️⃣ Entrypoint & Shell
# -------------------------------------------------------------
SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["entrypoint.sh"]
CMD ["zsh"]
