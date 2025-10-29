# docker/superset/Dockerfile
# Multi-stage: builder installs Python deps into a venv; runtime copies venv for smaller, cleaner runtime.
ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000
ARG MODE=dev        # set to 'prod' for production behavior at build or runtime via --build-arg / ENV

# ---------- Builder ----------
FROM docker/base/ubuntu-base AS builder
WORKDIR /opt/superset

# Ensure apt packages for building wheels are present (installed in base? ensure here)
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential libssl-dev libffi-dev python3-dev default-libmysqlclient-dev \
  libpq-dev libsasl2-dev libldap2-dev netcat-openbsd procps \
  && rm -rf /var/lib/apt/lists/*

# Copy requirements and constraints
COPY requirements.txt .
COPY constraints.txt .

# Create a venv and install Python packages (use constraints if provided)
RUN python3 -m venv /opt/superset-venv \
  && /opt/superset-venv/bin/pip install --upgrade pip setuptools wheel \
  && if [ -f constraints.txt ]; then \
  /opt/superset-venv/bin/pip install --no-cache-dir -r requirements.txt --constraint constraints.txt ; \
  else \
  /opt/superset-venv/bin/pip install --no-cache-dir -r requirements.txt ; \
  fi

# Copy application config and helper scripts into builder
COPY superset_config.py .
COPY entrypoint.sh /opt/entrypoint.sh
COPY zsh_aliases /opt/zsh_aliases
RUN chmod +x /opt/entrypoint.sh

# ---------- Runtime ----------
FROM docker/base/ubuntu-base AS runtime
WORKDIR /home/${DEV_USER}/superset

# Copy venv from builder
COPY --from=builder /opt/superset-venv /opt/superset-venv
COPY --from=builder /opt/entrypoint.sh /opt/entrypoint.sh
COPY --from=builder /opt/zsh_aliases /opt/zsh_aliases
COPY superset_config.py /home/${DEV_USER}/superset_config.py

# Copy shared scripts into deterministic location (docker/base had copied docker/shared to /opt/docker-shared, but ensure here)
COPY ../shared /opt/docker-shared
RUN chmod -R a+rx /opt/docker-shared || true

# Ensure entrypoint is executable
RUN chmod +x /opt/entrypoint.sh

# Expose Superset port
EXPOSE 8088

# Environment: ensure venv is used
ENV PATH="/opt/superset-venv/bin:${PATH}" \
  SUPERSET_HOME=/home/${DEV_USER}/superset \
  MODE=${MODE} \
  HOME=/home/${DEV_USER}

# Create runtime user if not already present (user_setup ensures it; do it again safely)
RUN /opt/docker-shared/user_setup.sh || true

# Create profile.d to source shared env and aliases in interactive shells
RUN printf "%s\n" "source /opt/docker-shared/common_env.sh 2>/dev/null || true" > /etc/profile.d/00-docker-shared.sh \
  && printf "%s\n" "source /opt/zsh_aliases 2>/dev/null || true" > /etc/profile.d/01-superset-aliases.sh \
  && chmod a+r /etc/profile.d/00-docker-shared.sh /etc/profile.d/01-superset-aliases.sh

# Use non-root developer user
USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

# Default entrypoint and command
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["shell"]
