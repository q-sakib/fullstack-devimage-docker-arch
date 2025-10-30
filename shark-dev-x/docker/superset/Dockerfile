# docker/superset/Dockerfile
ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000
ARG MODE=dev        # dev or prod

# ---------- Builder ----------
FROM docker/base/ubuntu-base AS builder
WORKDIR /opt/superset

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential libssl-dev libffi-dev python3-dev default-libmysqlclient-dev \
  libpq-dev libsasl2-dev libldap2-dev netcat-openbsd procps \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt constraints.txt ./
COPY superset_config.py entrypoint.sh zsh_aliases ./

RUN python3 -m venv /opt/superset-venv \
  && /opt/superset-venv/bin/pip install --upgrade pip setuptools wheel \
  && if [ -f constraints.txt ]; then \
  /opt/superset-venv/bin/pip install --no-cache-dir -r requirements.txt --constraint constraints.txt ; \
  else \
  /opt/superset-venv/bin/pip install --no-cache-dir -r requirements.txt ; \
  fi

RUN chmod +x entrypoint.sh

# ---------- Runtime ----------
FROM docker/base/ubuntu-base AS runtime
WORKDIR /home/${DEV_USER}/superset

# Copy venv and scripts from builder
COPY --from=builder /opt/superset-venv /opt/superset-venv
COPY --from=builder /opt/entrypoint.sh /opt/entrypoint.sh
COPY --from=builder /opt/zsh_aliases /opt/zsh_aliases
COPY superset_config.py /home/${DEV_USER}/superset_config.py

# Copy shared scripts
COPY ../shared /opt/docker-shared
RUN chmod -R a+rx /opt/docker-shared /opt/entrypoint.sh /opt/zsh_aliases

# Expose Superset
EXPOSE 8088

# Set environment
ENV PATH="/opt/superset-venv/bin:${PATH}" \
  SUPERSET_HOME=/home/${DEV_USER}/superset \
  MODE=${MODE} \
  HOME=/home/${DEV_USER}

# Setup profile.d for all shells
RUN printf "%s\n" "source /opt/docker-shared/common_env.sh 2>/dev/null || true" > /etc/profile.d/00-docker-shared.sh \
  && printf "%s\n" "source /opt/zsh_aliases 2>/dev/null || true" > /etc/profile.d/01-superset-aliases.sh \
  && chmod a+r /etc/profile.d/00-docker-shared.sh /etc/profile.d/01-superset-aliases.sh

# Ensure runtime user
RUN /opt/docker-shared/user_setup.sh || true

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["shell"]
