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

# Create user
RUN groupadd -g $GID $USER && \
  useradd -m -u $UID -g $GID -s /bin/zsh $USER && \
  echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

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
COPY requirements.txt $HOME/requirements.txt

EXPOSE 3000 4200 8000 8080 8088 5432 3306 6379 27017

SHELL ["/bin/zsh", "-c"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["zsh"]


# -------------------------
# Dev Image - Adds build tools, pyenv, nvm, etc.
# -------------------------
FROM base AS dev

USER root

# Install build tools and base-devel group, git, vim, etc.
RUN pacman -S --noconfirm base-devel git vim tmux htop less openssh openssl cmake gcc make curl wget unzip sudo && \
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
ENV PATH="$PYENV_ROOT/bin:$PATH"
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
  echo 'eval "$(pyenv init --path)"' >> ~/.zshrc && \
  . ~/.zshrc && \
  pyenv install 3.11.9 && \
  pyenv global 3.11.9

ENV PATH="$PYENV_ROOT/versions/3.11.9/bin:$PATH"

# Composer Laravel installer
RUN composer global require laravel/installer && \
  echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.zshrc

# Setup Python virtualenv and install python deps
RUN python -m venv superset-env && \
  ./superset-env/bin/pip install --upgrade pip setuptools wheel && \
  ./superset-env/bin/pip install -r $HOME/requirements.txt

# Source aliases in zshrc
RUN echo "source ~/.superset_aliases" >> ~/.zshrc

