# -------------------------
# Base Image - Minimal Runtime
# -------------------------
FROM archlinux:latest AS base

ENV TERM=xterm-256color \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  USER=devuser \
  UID=1000 \
  GID=1000 \
  HOME=/home/devuser

# Locale setup
RUN sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen && \
  echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Install zsh and sudo first (required before user creation)
RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm sudo zsh && \
  pacman -Scc --noconfirm && \
  rm -rf /var/cache/pacman/pkg/*

# Then create the user (now that /bin/zsh and sudoers.d exist)
RUN mkdir -p /etc/sudoers.d && \
  groupadd -g $GID $USER && \
  useradd -m -u $UID -g $GID -s /bin/zsh $USER && \
  echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

RUN sudo pacman -S --noconfirm reflector && \
  sudo reflector --country "US" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Install runtime packages (no build tools)
RUN sudo pacman -Syu --noconfirm && \
  sudo pacman -S --noconfirm python python-pip python-setuptools python-wheel libffi \
  mariadb mariadb-libs postgresql postgresql-libs redis \
  php php-gd php-intl composer nodejs npm yarn typescript ts-node inetutils && \
  sudo pacman -Scc --noconfirm && \
  sudo rm -rf /var/cache/pacman/pkg/*

# Setup nvm, pyenv, composer global paths, superset config folder
ENV NVM_DIR=$HOME/.nvm
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH="$PYENV_ROOT/bin:$PATH"

RUN mkdir -p $HOME/.superset

COPY --chown=$USER:$USER superset/superset_config.py $HOME/.superset/superset_config.py
COPY --chown=$USER:$USER superset/aliases.zsh $HOME/.superset_aliases

# Copy entrypoint
COPY superset/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sudo chmod +x /usr/local/bin/docker-entrypoint.sh

# Copy requirements and python virtualenv will be created in dev image
# Copy requirements and install Python deps
# COPY requirements.txt $HOME/requirements.txt
COPY requirements-core.txt requirements-core.txt
COPY requirements.txt requirements.txt
COPY constraints.txt constraints.txt

# # Install Python packages into virtualenv
# RUN python -m venv superset-env && \
#   ./superset-env/bin/pip install --upgrade pip setuptools wheel && \
#   ./superset-env/bin/pip install -r $HOME/requirements.txt


EXPOSE 3000 4200 8000 8080 8088 5432 3306 6379 27017

SHELL ["/bin/zsh", "-c"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["zsh"]

# -------------------------
# Dev Image - Adds build tools, pyenv, nvm, etc.
# -------------------------
FROM base AS dev
ENV CFLAGS="-Wno-stringop-overflow"
USER root

# Install build tools and base-devel group, git, vim, etc.
# RUN pacman -S --noconfirm base-devel git vim tmux htop less openssh openssl cmake gcc make curl wget unzip sudo \
#   libffi python python-pip python-setuptools python-wheel libxcrypt-compat \
#   && pacman -Scc --noconfirm && \
#   rm -rf /var/cache/pacman/pkg/*



# Update mirrorlist to a faster mirror before installing packages
RUN sed -i 's|Server = .*|Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch|' /etc/pacman.d/mirrorlist && \
  pacman -Syu --noconfirm

# Then install packages as usual
RUN pacman -S --noconfirm base-devel git vim tmux htop less openssh openssl cmake gcc make curl wget unzip sudo \
  libffi python python-pip python-setuptools python-wheel libxcrypt-compat && \
  pacman -Scc --noconfirm && \
  rm -rf /var/cache/pacman/pkg/*

USER $USER
WORKDIR $HOME

# Install NVM & Node global tools
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
  echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc && \
  . "$NVM_DIR/nvm.sh" && \
  nvm install --lts && \
  nvm use --lts && \
  npm install -g @angular/cli create-next-app

# Install pyenv and Python 3.11.9
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
  echo 'export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"' >> ~/.zshrc && \
  echo 'eval "$(pyenv init --path)"' >> ~/.zshrc && \
  export PYENV_ROOT="$HOME/.pyenv" && \
  export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH" && \
  pyenv install 3.11.9 && \
  pyenv global 3.11.9 && \
  pyenv rehash && \
  python -m ensurepip && \
  pip install --upgrade pip setuptools wheel

ENV PATH="$PYENV_ROOT/versions/3.11.9/bin:$PATH"

# Composer Laravel installer
RUN composer global require laravel/installer && \
  echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.zshrc

# Install development dependencies (build tools, headers, scientific libs, etc.)
USER root
# RUN pacman -Sy --noconfirm openbsd-netcat && pacman -Scc --noconfirm
# RUN pacman -Syu --noconfirm && \
#   pacman -S --noconfirm base-devel gcc-fortran openblas lapack && \
#   pacman -Scc --noconfirm

RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  base-devel gcc gcc-fortran \
  openblas lapack \
  libjpeg-turbo zlib freetype2 libpng \
  openbsd-netcat \
  git vim tmux htop less openssh openssl cmake make curl wget unzip sudo \
  && pacman -Scc --noconfirm && \
  rm -rf /var/cache/pacman/pkg/*
USER devuser

# Build virtualenv
RUN python -m venv superset-env && \
  ./superset-env/bin/pip install --upgrade pip setuptools wheel

# Install native-heavy deps via binary wheels
RUN ./superset-env/bin/pip install \
  numpy==1.26.4 \
  pandas \
  pyarrow \
  pillow \
  psycopg2-binary \
  --only-binary=:all:

# Then install the rest
# RUN ./superset-env/bin/pip install -r $HOME/requirements.txt --no-deps
# RUN ./superset-env/bin/pip install -r $HOME/requirements.txt
# RUN ./superset-env/bin/pip install -r requirements-core.txt -c constraints.txt
# RUN ./superset-env/bin/pip install -r requirements.txt -c constraints.txt
COPY requirements-core.txt requirements-core.txt
COPY requirements.txt requirements.txt
COPY constraints.txt constraints.txt

RUN ./superset-env/bin/pip install --upgrade pip setuptools wheel

RUN ./superset-env/bin/pip install -r requirements-core.txt -c constraints.txt
RUN ./superset-env/bin/pip install -r requirements.txt -c constraints.txt


# Source aliases in zshrc
RUN echo "source ~/.superset_aliases" >> ~/.zshrc

# # Switch to root to install netcat
# USER root
# RUN pacman -Sy --noconfirm openbsd-netcat && pacman -Scc --noconfirm

# # Switch back to devuser
# USER devuser










# -----------------------------------
# Final Stage (Runtime Only, Clean)
# -----------------------------------
FROM base AS final

# Copy Python virtualenv from dev
COPY --from=dev /home/devuser/superset-env /home/devuser/superset-env

# Copy Superset config and requirements.txt
COPY --from=dev /home/devuser/.superset /home/devuser/.superset
COPY --from=dev /home/devuser/requirements.txt /home/devuser/requirements.txt

# Copy entrypoint (already executable in dev or base)
COPY superset/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Ensure correct ownership (prevent potential permission issues)
RUN sudo chown -R devuser:devuser /home/devuser/superset-env /home/devuser/.superset

# Set runtime environment variables
ENV PATH="/home/devuser/superset-env/bin:$PATH" \
  PYTHONPATH="/home/devuser/superset-env/lib/python3.11/site-packages"

# Confirm Flask and Superset CLI available
RUN /home/devuser/superset-env/bin/python -c "import flask; print('✅ Flask:', flask.__version__)"
RUN /home/devuser/superset-env/bin/superset version

# Optional: Add alias for interactive sessions
RUN if [ -f ~/.zshrc ]; then echo 'alias superset="/home/devuser/superset-env/bin/superset"' >> ~/.zshrc; fi

# Optional: Cleanup pycache and temp files to reduce image size
RUN find /home/devuser/superset-env -type d -name '__pycache__' -exec rm -rf {} + && \
  rm -rf ~/.cache ~/.npm /tmp/*

# Healthcheck (can be disabled in dev env via docker-compose override)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8088/health || exit 1

# Expose Superset port
EXPOSE 8088

# Default shell
SHELL ["/bin/zsh", "-c"]

# Metadata
LABEL maintainer="yourname@example.com" \
  description="Production-ready runtime image for Apache Superset with Python 3.11.9"

# Entrypoint and command
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/home/devuser/superset-env/bin/superset", "run", "-h", "0.0.0.0", "-p", "8088"]
