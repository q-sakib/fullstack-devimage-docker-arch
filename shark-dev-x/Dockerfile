# =====================================================
# ---------- Local Base Images ----------
# =====================================================
FROM docker/base/debian-base AS debian-base
# Debian base already configured

FROM docker/base/ubuntu-base AS ubuntu-base
# Ubuntu base already configured

FROM docker/base/arch-base AS arch-base
# Arch base already configured

# =====================================================
# ---------- Fullstack ----------
# =====================================================
FROM ubuntu-base AS fullstack
WORKDIR /opt/fullstack

# Copy update script first, then update shared folder
COPY docker/scripts/update_shared.sh /tmp/update_shared.sh
RUN chmod +x /tmp/update_shared.sh \
  && /tmp/update_shared.sh fullstack || echo "⚠️ Shared folder update skipped"

# Copy updated shared folder
# Safe COPY that doesn’t fail if empty
COPY docker/shared/. ./shared/
RUN [ -d ./shared ] || echo "⚠️ Shared folder missing, skipping"


COPY docker/fullstack/package.json . 
# COPY docker/fullstack/package-lock.json .

# Verify shared folder exists
RUN [ -d ./shared ] || echo "⚠️ shared folder missing, skipping"

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get update && apt-get install -y nodejs npm \
  && npm install -g yarn \
  && yarn install || echo "⚠️ yarn install failed, skipping"

RUN echo "✅ Fullstack stage completed"

# =====================================================
# ---------- ML / AI ----------
# =====================================================
FROM ubuntu-base AS ml
WORKDIR /opt/ml

# Copy update script first, then update shared folder
COPY docker/scripts/update_shared.sh /tmp/update_shared.sh
RUN chmod +x /tmp/update_shared.sh \
  && /tmp/update_shared.sh ml || echo "⚠️ Shared folder update skipped"

# Copy updated shared folder
# Safe COPY that doesn’t fail if empty
COPY docker/shared/. ./shared/
RUN [ -d ./shared ] || echo "⚠️ Shared folder missing, skipping"


COPY docker/ml/requirements.txt .
COPY docker/ml/package.json .

# Verify shared folder exists
RUN [ -d ./shared ] || echo "⚠️ shared folder missing, skipping"

RUN python3 -m venv /opt/ml-venv \
  && /opt/ml-venv/bin/pip install --upgrade pip setuptools wheel \
  && /opt/ml-venv/bin/pip install -r requirements.txt \
  && npm install || echo "⚠️ npm install failed, skipping"

RUN echo "✅ ML stage completed"

# =====================================================
# ---------- AppDev (Flutter / Web) ----------
# =====================================================
FROM ubuntu-base AS appdev
WORKDIR /opt/appdev

# Copy update script first, then update shared folder
COPY docker/scripts/update_shared.sh /tmp/update_shared.sh
RUN chmod +x /tmp/update_shared.sh \
  && /tmp/update_shared.sh appdev || echo "⚠️ Shared folder update skipped"

# Copy updated shared folder
# Safe COPY that doesn’t fail if empty
COPY docker/shared/. ./shared/
RUN [ -d ./shared ] || echo "⚠️ Shared folder missing, skipping"


COPY docker/appdev/package.json . 
# COPY docker/appdev/package-lock.json .

# Verify shared folder exists
RUN [ -d ./shared ] || echo "⚠️ shared folder missing, skipping"

RUN apt-get update && apt-get install -y curl unzip xz-utils git \
  && curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.7-stable.tar.xz | tar xJ -C /opt \
  && export PATH="$PATH:/opt/flutter/bin" \
  && flutter doctor -v \
  && npm install || echo "⚠️ npm install failed, skipping"

RUN echo "✅ AppDev stage completed"

# =====================================================
# ---------- Experimental ----------
# =====================================================
FROM ubuntu-base AS experimental
WORKDIR /opt/experimental

# Copy update script first, then update shared folder
COPY docker/scripts/update_shared.sh /tmp/update_shared.sh
RUN chmod +x /tmp/update_shared.sh \
  && /tmp/update_shared.sh experimental || echo "⚠️ Shared folder update skipped"

# Copy updated shared folder
# Safe COPY that doesn’t fail if empty
COPY docker/shared/. ./shared/
RUN [ -d ./shared ] || echo "⚠️ Shared folder missing, skipping"


# Copy package definition
COPY docker/experimental/package.json . 
# COPY docker/experimental/package-lock.json .

# Verify shared folder exists
RUN [ -d ./shared ] || echo "⚠️ shared folder missing, skipping"

# Install NPM packages (optional)
RUN npm install || echo "⚠️ npm install failed, skipping"

RUN echo "✅ Experimental stage completed"



# =====================================================
# ---------- Superset Embedded Block ----------
# =====================================================
ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000
ARG MODE=prod

WORKDIR /opt/superset

# Copy shared scripts
COPY docker/shared ./shared
COPY docker/scripts/update_shared.sh /tmp/update_shared.sh
RUN chmod +x /tmp/update_shared.sh \
  && /tmp/update_shared.sh superset || echo "⚠️ Shared folder update skipped"

# Copy Superset files
COPY docker/superset/requirements.txt docker/superset/superset_config.py docker/superset/entrypoint.sh ./

# Switch to root to install system dependencies
USER root

# Install build deps and runtime libs
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential python3-dev pkg-config default-libmysqlclient-dev \
  libssl-dev libffi-dev libjpeg-dev zlib1g-dev curl git netcat-openbsd \
  && rm -rf /var/lib/apt/lists/* \
  && echo "✅ System dependencies installed"

# Create isolated Python venv
RUN python3 -m venv /home/${DEV_USER}/.superset-venv \
  && /home/${DEV_USER}/.superset-venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
  && echo "✅ Virtual environment created and upgraded"

# Install Apache Superset + drivers + Celery/Redis + optional requirements
RUN /home/${DEV_USER}/.superset-venv/bin/pip install --no-cache-dir \
  "apache-superset[all,celery]" \
  mysqlclient \
  psycopg2-binary \
  redis \
  celery \
  && if [ -f requirements.txt ]; then /home/${DEV_USER}/.superset-venv/bin/pip install --no-cache-dir -r requirements.txt; fi \
  && echo "✅ Superset + additional Python requirements installed"

# Make entrypoint executable
RUN chmod +x entrypoint.sh

# Set runtime environment variables
ENV PATH="/home/${DEV_USER}/.superset-venv/bin:$PATH" \
  SUPERSET_HOME=/home/${DEV_USER}/superset \
  HOME=/home/${DEV_USER}

# Switch to non-root runtime user
USER ${DEV_USER}

# Expose Superset port
EXPOSE 8088

# Default entrypoint
ENTRYPOINT ["/opt/superset/entrypoint.sh"]
CMD ["superset"]

# =====================================================
# ---------- Final Root Image ----------
# Combines all stages for runtime / testing / universal use
# =====================================================
FROM ubuntu-base AS super-admin-all
WORKDIR /home/devuser

# Copy all stages individually
COPY --from=fullstack /opt/fullstack /opt/fullstack
COPY --from=ml /opt/ml /opt/ml
COPY --from=appdev /opt/appdev /opt/appdev
COPY --from=experimental /opt/experimental /opt/experimental
COPY --from=local-superset /opt/superset /opt/superset

# Mount shared scripts
COPY docker/shared /opt/docker-shared
RUN [ -d /opt/docker-shared ] || echo "⚠️ shared folder missing, skipping"

# Expose all required ports
EXPOSE 8088 5000 3000 3001 4000

# Profiles environment variable (optional)
ARG PROFILE=dev
ENV PROFILE=${PROFILE}

# Set default shell
ENTRYPOINT ["/bin/bash"]
CMD ["zsh"]

RUN echo "✅ Super Admin All image build completed"
