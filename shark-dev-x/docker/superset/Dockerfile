# ===============================
# Superset Optimized Dockerfile
# Multi-Stage + Isolated venv + Latest Superset + Enterprise Ready
# ===============================

ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000
ARG MODE=prod  # dev | prod
ARG PYTHON_VERSION=3.10

# ---------- Base OS Layer ----------
FROM docker/base/ubuntu-base AS base
WORKDIR /opt/superset
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
  libpq-dev libssl-dev libffi-dev libsasl2-dev \
  libldap2-dev libjpeg-dev zlib1g-dev \
  curl git netcat-openbsd procps \
  && rm -rf /var/lib/apt/lists/* \
  && echo "✅ Superset base runtime deps installed"

# ---------- Builder Layer ----------
FROM base AS builder
WORKDIR /opt/superset

# Build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential python3-dev pkg-config \
  default-libmysqlclient-dev \
  libbz2-dev liblzma-dev \
  && rm -rf /var/lib/apt/lists/* \
  && echo "✅ Build toolchain installed"

# Create Python venv
RUN python3 -m venv /home/${DEV_USER}/.superset-venv \
  && echo "✅ Python venv created"

# Upgrade pip + setuptools + wheel
RUN /home/${DEV_USER}/.superset-venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel

# Install latest Superset + extras for enterprise (async + Celery + Redis)
RUN /home/${DEV_USER}/.superset-venv/bin/pip install --no-cache-dir \
  "apache-superset[all,celery]" \
  mysqlclient \
  psycopg2-binary \
  redis \
  celery \
  && echo "✅ Superset + DB drivers + Celery/Redis installed"

# Copy config & entrypoint
COPY entrypoint.sh superset_config.py ./
RUN chmod +x entrypoint.sh

# ---------- Runtime Layer ----------
FROM base AS runtime
WORKDIR /home/${DEV_USER}/superset

ENV HOME=/home/${DEV_USER} \
  SUPERSET_HOME=/home/${DEV_USER}/superset \
  PATH="/home/${DEV_USER}/.superset-venv/bin:$PATH" \
  MODE=${MODE}

# Create runtime user
RUN /opt/docker-shared/user_setup.sh || true

# Copy venv + Superset assets from builder
COPY --from=builder /home/${DEV_USER}/.superset-venv /home/${DEV_USER}/.superset-venv
COPY --from=builder /opt/superset/entrypoint.sh /opt/entrypoint.sh
COPY --from=builder /opt/superset/superset_config.py /home/${DEV_USER}/superset_config.py

RUN echo "✅ Runtime files ready"

# Switch to runtime user
USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

# Expose Superset service port
EXPOSE 8088

# Default entrypoint and command
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["superset", "run", "-p", "8088", "--with-threads", "--reload"]
