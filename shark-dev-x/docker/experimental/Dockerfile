# ===================================================================
# 🧪 Experimental / Tools Container (with success messages)
# Ubuntu Base + DevOps CLIs + SDKs
# ===================================================================

FROM docker/base/ubuntu-base AS experimental

LABEL maintainer="DevOps Toolkit <devops@local>"
LABEL description="Experimental tools container for CLIs, SDKs, and utilities"

ARG INCLUDE_TERRAFORM=true
ARG INCLUDE_GCLOUD=true
ARG INCLUDE_AZURE=true
ARG INCLUDE_GITHUB_CLI=true

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
  && echo "source /tmp/zsh_aliases" >> ~/.zshrc \
  && echo "✅ Shared scripts setup completed"

# -------------------------------------------------------------
# 2️⃣ System dependencies
# -------------------------------------------------------------
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl wget unzip git sudo zsh apt-transport-https ca-certificates gnupg lsb-release jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && echo "✅ System dependencies installed"

USER devuser
WORKDIR /home/devuser/experimental

# -------------------------------------------------------------
# 3️⃣ Copy configuration + setup scripts
# -------------------------------------------------------------
COPY config/ config/
COPY extra_tools.sh /tmp/extra_tools.sh
COPY plugins/ plugins/

RUN chmod +x /tmp/extra_tools.sh plugins/*.sh \
  && /tmp/extra_tools.sh \
  && echo "✅ Base tools setup completed"

# -------------------------------------------------------------
# 4️⃣ Optional Plugin Installs
# -------------------------------------------------------------
RUN if [ "$INCLUDE_TERRAFORM" = "true" ]; then bash plugins/terraform_setup.sh && echo "✅ Terraform installed"; fi
RUN if [ "$INCLUDE_GCLOUD" = "true" ]; then bash plugins/gcloud_setup.sh && echo "✅ GCloud SDK installed"; fi
RUN if [ "$INCLUDE_AZURE" = "true" ]; then bash plugins/azure_setup.sh && echo "✅ Azure CLI installed"; fi
RUN if [ "$INCLUDE_GITHUB_CLI" = "true" ]; then bash plugins/github_cli_setup.sh && echo "✅ GitHub CLI installed"; fi

# -------------------------------------------------------------
# ✅ Entrypoint
# -------------------------------------------------------------
ENTRYPOINT ["entrypoint.sh"]
CMD ["zsh"]
