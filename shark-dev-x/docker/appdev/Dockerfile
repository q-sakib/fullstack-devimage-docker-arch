# ===================================================================
# 🐧 AppDev Base (Ubuntu)
# Flutter + Android SDK + Node (NVM)
# ===================================================================

FROM docker/base/ubuntu-base AS appdev

LABEL maintainer="DevOps Toolkit <devops@local>"
LABEL description="Unified AppDev image with Flutter, Android SDK, and Node.js LTS"

# Set environment
ENV DEBIAN_FRONTEND=noninteractive \
  ANDROID_HOME=/opt/android-sdk \
  PATH=$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/flutter/bin:/home/devuser/.nvm/versions/node/v*/bin

WORKDIR /home/devuser

# -------------------------------------------------------------
# 1️⃣ Shared Scripts and Base Environment
# -------------------------------------------------------------
COPY ../shared/user_setup.sh /tmp/user_setup.sh
COPY ../shared/common_env.sh /tmp/common_env.sh
COPY ../shared/zsh_aliases /tmp/zsh_aliases
COPY ../shared/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /tmp/user_setup.sh /usr/local/bin/entrypoint.sh \
  && /tmp/user_setup.sh \
  && echo "source /tmp/common_env.sh" >> ~/.zshrc \
  && echo "source /tmp/zsh_aliases" >> ~/.zshrc

# -------------------------------------------------------------
# 2️⃣ Install System Dependencies
# -------------------------------------------------------------
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  openjdk-17-jdk wget unzip xz-utils curl git sudo zsh zip libglu1-mesa \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

USER devuser
WORKDIR /home/devuser

# -------------------------------------------------------------
# 3️⃣ Flutter SDK Installation
# -------------------------------------------------------------
COPY flutter_setup.sh /tmp/flutter_setup.sh
RUN chmod +x /tmp/flutter_setup.sh && /tmp/flutter_setup.sh

# -------------------------------------------------------------
# 4️⃣ Node + NVM Installation
# -------------------------------------------------------------
COPY node_setup.sh /tmp/node_setup.sh
RUN chmod +x /tmp/node_setup.sh && /tmp/node_setup.sh

# -------------------------------------------------------------
# 5️⃣ Android SDK Installation
# -------------------------------------------------------------
RUN sudo mkdir -p $ANDROID_HOME/cmdline-tools && \
  wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
  sudo unzip -q /tmp/cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools && \
  sudo mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
  sudo chown -R devuser:devuser $ANDROID_HOME && \
  rm /tmp/cmdline-tools.zip

# -------------------------------------------------------------
# 6️⃣ Android SDK Manager Setup
# -------------------------------------------------------------
RUN yes | sdkmanager --licenses || true && \
  sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "cmdline-tools;latest"

# -------------------------------------------------------------
# ✅ Final Setup
# -------------------------------------------------------------
RUN flutter doctor -v || true

ENTRYPOINT ["entrypoint.sh"]
CMD ["zsh"]
