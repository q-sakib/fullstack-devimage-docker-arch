# ===================================================================
# 🌐 Fullstack Dev Container
# Python + Node.js + DB Clients + JS Frameworks
# Based on Arch Base Image
# ===================================================================

FROM docker/base/arch-base AS fullstack

LABEL maintainer="DevOps Toolkit <devops@local>"
LABEL description="Fullstack dev image: Python + Node.js + DB clients + JS frameworks"

# -------------------------------------------------------------
# 1️⃣ Shared scripts and environment
# -------------------------------------------------------------
USER root

# Copy shared files (works if build started from project root)
COPY ../shared/user_setup.sh /tmp/user_setup.sh
COPY ../shared/common_env.sh /tmp/common_env.sh
COPY ../shared/zsh_aliases /tmp/zsh_aliases
COPY ../shared/entrypoint.sh /usr/local/bin/entrypoint.sh

# Run shared setup
RUN chmod +x /tmp/user_setup.sh /usr/local/bin/entrypoint.sh \
  && /tmp/user_setup.sh \
  && echo "✅ Shared scripts executed" \
  && echo "source /tmp/common_env.sh" >> /etc/zsh/zshrc \
  && echo "source /tmp/zsh_aliases" >> /etc/zsh/zshrc

# -------------------------------------------------------------
# 2️⃣ System packages
# -------------------------------------------------------------
RUN pacman -Syu --noconfirm \
  python python-pip python-virtualenv \
  nodejs npm yarn typescript ts-node \
  git vim curl wget unzip sudo \
  mariadb-libs postgresql-libs redis \
  && pacman -Scc --noconfirm \
  && rm -rf /var/cache/pacman/pkg/* \
  && echo "✅ System packages installed"

# -------------------------------------------------------------
# 3️⃣ Switch to non-root user
# -------------------------------------------------------------
USER devuser
WORKDIR /home/devuser/fullstack

# -------------------------------------------------------------
# 4️⃣ Python virtual environment
# -------------------------------------------------------------
RUN python -m venv fullstack-env \
  && ./fullstack-env/bin/pip install --upgrade pip setuptools wheel \
  && echo "✅ Python virtual environment created"

# -------------------------------------------------------------
# 5️⃣ Python requirements
# -------------------------------------------------------------
# COPY fullstack/requirements.txt ./requirements.txt
# RUN ./fullstack-env/bin/pip install --no-cache-dir -r requirements.txt \
#   && echo "✅ Python requirements installed"

# -------------------------------------------------------------
# 6️⃣ Node.js environment setup
# -------------------------------------------------------------
RUN mkdir -p ~/.npm-global \
  && npm config set prefix ~/.npm-global \
  && echo "export PATH=\$HOME/.npm-global/bin:\$PATH" >> ~/.zshrc \
  && echo "✅ Node.js global prefix configured"

# -------------------------------------------------------------
# 7️⃣ Copy config folder
# -------------------------------------------------------------
COPY fullstack/config/ ./config/
RUN echo "✅ Config folder copied"

# successfully end those before adding new bugs from there


# -------------------------------------------------------------
# 8️⃣ Fullstack Web Dev Tools
# -------------------------------------------------------------
USER root

# Update package DB first
RUN pacman -Sy --noconfirm

# Install PHP + extensions (Arch way)
RUN pacman -S --noconfirm php php-apache php-pgsql php-gd php-intl \
  && echo "✅ PHP and extensions installed"

# Install Composer (official)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer global require laravel/installer \
  && echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> /etc/zsh/zshrc \
  && echo "✅ Composer + Laravel installer installed"

# MySQL & PostgreSQL clients
RUN pacman -S --noconfirm mariadb postgresql \
  && echo "✅ MySQL & PostgreSQL clients installed"

# Install NVM, Node.js LTS, Angular CLI, Next.js CLI
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
  && export NVM_DIR="$HOME/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && nvm install --lts \
  && npm install -g @angular/cli next \
  && echo 'export NVM_DIR="$HOME/.nvm"' >> /etc/zsh/zshrc \
  && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/zsh/zshrc \
  && echo "✅ NVM, Node.js LTS, Angular CLI, Next.js CLI installed"

# Optional: create workspace directories
RUN mkdir -p /home/devuser/projects /home/devuser/webapps \
  && chown -R devuser:devuser /home/devuser/projects /home/devuser/webapps \
  && echo "✅ Workspace directories created"


# -------------------------------------------------------------
# 9️⃣ Switch back to non-root user
# -------------------------------------------------------------
USER devuser
WORKDIR /home/devuser/fullstack


# -------------------------------------------------------------
# ✅ Entrypoint & Shell
# -------------------------------------------------------------
SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["entrypoint.sh"]
CMD ["zsh"]
