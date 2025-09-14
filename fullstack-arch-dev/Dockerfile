# Use stable Arch Linux base image
FROM archlinux:latest

# Locale / Terminal settings
ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen && \
  echo "LANG=en_US.UTF-8" > /etc/locale.conf

# User setup
ARG USER=devuser
ARG UID=1000
ARG GID=1000
ENV HOME=/home/$USER

# Install system packages and dev tools (no AUR, no Mongo via pacman)
RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  base-devel sudo git curl wget unzip zsh vim tmux tree htop less openssh openssl cmake gcc make \
  python python-pip python-setuptools python-wheel libffi mariadb mariadb-libs postgresql postgresql-libs \
  redis php php-gd php-intl composer nodejs npm yarn typescript ts-node \
  && pacman -Scc --noconfirm && rm -rf /var/cache/pacman/pkg/*

# Copy Superset entrypoint script and make executable (run as root!)
COPY superset/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Create non-root user with zsh shell
RUN groupadd -g $GID $USER && \
  useradd -m -u $UID -g $GID -s /bin/zsh $USER && \
  echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

# Install NVM v0.39.3 and global Node tools
ENV NVM_DIR=$HOME/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
  echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc && \
  /bin/zsh -c "source $NVM_DIR/nvm.sh && nvm install --lts && nvm use --lts && npm install -g @angular/cli create-next-app"

# Install pyenv + Python 3.11.9
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH="$PYENV_ROOT/bin:$PATH"
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
  echo 'eval "$(pyenv init --path)"' >> ~/.zshrc && \
  /bin/zsh -c "source ~/.zshrc && pyenv install 3.11.9 && pyenv global 3.11.9"

ENV PATH="$PYENV_ROOT/versions/3.11.9/bin:$PATH"

# Create superset config directory
RUN mkdir -p $HOME/.superset && chown $USER:$USER $HOME/.superset

# Laravel installer globally
RUN composer global require laravel/installer && \
  echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.zshrc


# 🔄 Temporarily switch to root to install netcat
USER root
RUN pacman -Sy --noconfirm inetutils

# 👤 Switch back to devuser
# USER devuser
USER $USER
WORKDIR /home/$USER

  
# Copy requirements and install python deps
COPY requirements.txt $HOME/requirements.txt
RUN python -m venv superset-env && \
  ./superset-env/bin/pip install --upgrade pip setuptools wheel && \
  ./superset-env/bin/pip install -r $HOME/requirements.txt

# Copy Superset config and aliases
COPY superset/superset_config.py $HOME/.superset/superset_config.py
COPY superset/aliases.zsh $HOME/.superset_aliases

# Source aliases in zshrc (run as non-root)
RUN echo "source ~/.superset_aliases" >> ~/.zshrc

# Expose relevant ports
EXPOSE 3000 4200 8000 8080 8088 5432 3306 6379 27017

SHELL ["/bin/zsh", "-c"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["zsh"]
