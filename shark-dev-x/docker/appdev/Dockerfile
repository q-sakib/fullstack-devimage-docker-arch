# ===============================================================
# 🐧 AppDev Image (Ubuntu) with success messages
# Flutter + Android SDK + Node (NVM)
# ===============================================================

FROM docker/base/ubuntu-base:latest AS appdev

LABEL maintainer="DevOps Toolkit <devops@yourdomain.com>"
LABEL description="Unified AppDev image with Flutter, Android SDK, and Node.js LTS"

USER root
WORKDIR /opt

ENV ANDROID_HOME=/opt/android-sdk \
    FLUTTER_HOME=/opt/flutter \
    NVM_DIR=/home/devuser/.nvm \
    PATH=$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/flutter/bin:/home/devuser/.nvm/versions/node/v*/bin

# -------------------------------------------------------------
# 🧰 Install Required System Packages
# -------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk wget unzip xz-utils curl git zip libglu1-mesa \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && echo "✅ System packages installed"

# -------------------------------------------------------------
# 🧩 Copy setup scripts (modular)
# -------------------------------------------------------------
COPY flutter_setup.sh /opt/setup/flutter_setup.sh
COPY node_setup.sh /opt/setup/node_setup.sh
COPY android_setup.sh /opt/setup/android_setup.sh
COPY sdkmanager_config.sh /opt/setup/sdkmanager_config.sh

RUN chmod +x /opt/setup/*.sh \
    && /opt/setup/sdkmanager_config.sh \
    && echo "✅ Setup scripts copied and sdkmanager configured"

# -------------------------------------------------------------
# 🧱 Layered Setup (cached by stage)
# -------------------------------------------------------------
# USER devuser
# WORKDIR /home/devuser

# -------------------------------------------------------------
# 🧱 Layered Setup (cached by stage)
# -------------------------------------------------------------
USER root
WORKDIR /opt

# Run Flutter setup as root
RUN /opt/setup/flutter_setup.sh \
    && echo "✅ Flutter setup completed"

# Install Node.js globally (remove NVM usage)
RUN apt-get update && apt-get install -y curl gnupg2 \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && echo "✅ Node.js installed globally"

# Run Android SDK setup as root
RUN /opt/setup/android_setup.sh \
    && echo "✅ Android SDK setup completed"

# -------------------------------------------------------------
# 🧩 Validate Flutter & SDKs as devuser
# -------------------------------------------------------------
USER devuser
WORKDIR /home/devuser

# Set Flutter & Android SDK PATH
ENV PATH=/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:$PATH

# Validate installations
RUN git config --global --add safe.directory /opt/flutter \
    && flutter doctor -v || true \
    && node -v \
    && java -version \
    && echo "✅ Flutter, Node.js, Java validated"


# -------------------------------------------------------------
# ✅ Entrypoint & CMD
# -------------------------------------------------------------
ENTRYPOINT ["/opt/docker-shared/entrypoint.sh"]
CMD ["zsh"]
