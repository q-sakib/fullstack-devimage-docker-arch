# ===============================================================
# 🐧 AppDev Image (Ubuntu)
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
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------------
# 🧩 Copy setup scripts (modular)
# -------------------------------------------------------------
COPY flutter_setup.sh /opt/setup/flutter_setup.sh
COPY node_setup.sh /opt/setup/node_setup.sh
COPY android_setup.sh /opt/setup/android_setup.sh
COPY sdkmanager_config.sh /opt/setup/sdkmanager_config.sh
RUN chmod +x /opt/setup/sdkmanager_config.sh && /opt/setup/sdkmanager_config.sh

RUN chmod +x /opt/setup/*.sh

# -------------------------------------------------------------
# 🧱 Layered Setup (cached by stage)
# -------------------------------------------------------------
USER devuser
WORKDIR /home/devuser

RUN /opt/setup/flutter_setup.sh && \
    /opt/setup/node_setup.sh

USER root
RUN /opt/setup/android_setup.sh

USER devuser

# -------------------------------------------------------------
# 🧩 Validate Flutter & SDKs
# -------------------------------------------------------------
RUN flutter doctor -v || true && node -v && java -version

ENTRYPOINT ["/opt/docker-shared/entrypoint.sh"]
CMD ["zsh"]
