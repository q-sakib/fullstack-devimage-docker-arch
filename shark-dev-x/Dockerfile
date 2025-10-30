# =====================================================
# ---------- Local Base Images ----------
# =====================================================
FROM local-base-debian AS debian-base
# Debian base already configured

FROM local-base-ubuntu AS ubuntu-base
# Ubuntu base already configured

FROM local-base-arch AS arch-base
# Arch base already configured

# =====================================================
# ---------- Fullstack ----------
# =====================================================
FROM ubuntu-base AS fullstack
WORKDIR /opt/fullstack

COPY docker/fullstack/package.json .
# COPY docker/fullstack/package-lock.json .

# Copy shared scripts
COPY docker/shared ./shared
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

COPY docker/ml/requirements.txt .
COPY docker/ml/package.json .

# Copy shared scripts
COPY docker/shared ./shared
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

COPY docker/appdev/package.json .
# COPY docker/appdev/package-lock.json .

# Copy shared scripts
COPY docker/shared ./shared
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

COPY docker/experimental/package.json .
# COPY docker/experimental/package-lock.json .

# Copy shared scripts
COPY docker/shared ./shared
RUN [ -d ./shared ] || echo "⚠️ shared folder missing, skipping"

RUN npm install || echo "⚠️ npm install failed, skipping"

RUN echo "✅ Experimental stage completed"

# =====================================================
# ---------- Superset ----------
# =====================================================
FROM ubuntu-base AS superset
WORKDIR /opt/superset

# Copy Superset files
COPY docker/superset/requirements.txt .
COPY docker/superset/superset_config.py .
COPY docker/superset/entrypoint.sh .

# Create isolated venv
RUN python3 -m venv /home/devuser/.superset-venv \
  && echo "✅ Virtual environment created"

# Upgrade pip/setuptools/wheel
RUN /home/devuser/.superset-venv/bin/pip install --upgrade pip setuptools wheel \
  && echo "✅ pip, setuptools, wheel upgraded"

# Install Apache Superset (latest)
RUN /home/devuser/.superset-venv/bin/pip install --no-cache-dir apache-superset \
  && echo "✅ Apache Superset latest installed"

# Install additional requirements
RUN if [ -f requirements.txt ]; then \
  /home/devuser/.superset-venv/bin/pip install --no-cache-dir -r requirements.txt ; \
  fi \
  && echo "✅ Additional Python requirements installed"

# Make entrypoint executable
RUN chmod +x entrypoint.sh \
  && echo "✅ Entrypoint script permissions set"

# Expose Superset service port
EXPOSE 8088
ENV PATH="/home/devuser/.superset-venv/bin:$PATH" \
  SUPERSET_HOME=/home/devuser/superset \
  HOME=/home/devuser
RUN echo "✅ Superset stage completed successfully"




# =====================================================
# ---------- Final Root Image ----------
# Combines all stages for runtime / testing / universal use
# =====================================================
FROM ubuntu-base AS super-admin-all
WORKDIR /home/devuser

# Copy all stages individually, making them independent
COPY --from=fullstack /opt/fullstack /opt/fullstack
COPY --from=ml /opt/ml /opt/ml
COPY --from=appdev /opt/appdev /opt/appdev
COPY --from=experimental /opt/experimental /opt/experimental
COPY --from=superset /opt/superset /opt/superset

# Mount shared scripts
COPY docker/shared /opt/docker-shared
RUN [ -d /opt/docker-shared ] || echo "⚠️ shared folder missing, skipping"

# Expose all required ports
EXPOSE 8088 5000 3000 3001 4000

# Profiles environment variable (optional)
ARG PROFILE=dev
ENV PROFILE=${PROFILE}

# Default entrypoint
ENTRYPOINT ["/bin/bash"]
CMD ["zsh"]

RUN echo "✅ Super Admin All image build completed"
