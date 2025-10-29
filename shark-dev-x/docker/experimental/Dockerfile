# ===================================================================
# 🧪 Experimental / Tools Container
# Ubuntu Base
# Includes Docker CLI, Docker Compose, AWS CLI, kubectl, etc.
# ===================================================================

FROM docker/base/ubuntu-base AS experimental

LABEL maintainer="DevOps Toolkit <devops@local>"
LABEL description="Experimental tools container for CLIs, SDKs, and utilities"

# -------------------------------------------------------------
# 1️⃣ Shared scripts
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
# 2️⃣ System dependencies
# -------------------------------------------------------------
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl wget unzip git sudo zsh apt-transport-https ca-certificates gnupg lsb-release \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

USER devuser
WORKDIR /home/devuser/experimental

# -------------------------------------------------------------
# 3️⃣ Copy experimental tools setup script
# -------------------------------------------------------------
COPY extra_tools.sh /tmp/extra_tools.sh
RUN chmod +x /tmp/extra_tools.sh && /tmp/extra_tools.sh

# -------------------------------------------------------------
# 4️⃣ Entrypoint
# -------------------------------------------------------------
ENTRYPOINT ["entrypoint.sh"]
CMD ["zsh"]
