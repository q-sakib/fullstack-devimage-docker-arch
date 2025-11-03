# ===================================================================
# 🧪 Experimental / Tools Container
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
# 1️⃣ Shared scripts (copied from ../shared/)
# -------------------------------------------------------------
USER root

COPY ../shared/user_setup.sh /tmp/user_setup.sh
COPY ../shared/common_env.sh /tmp/common_env.sh
COPY ../shared/zsh_aliases /tmp/zsh_aliases
COPY ../shared/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /tmp/user_setup.sh /usr/local/bin/entrypoint.sh \
  && /tmp/user_setup.sh \
  && echo "✅ Shared scripts setup completed" \
  && echo "source /tmp/common_env.sh" >> /etc/zsh/zshrc \
  && echo "source /tmp/zsh_aliases" >> /etc/zsh/zshrc

# -------------------------------------------------------------
# 2️⃣ System dependencies
# -------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl wget unzip git sudo zsh apt-transport-https ca-certificates gnupg lsb-release jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && echo "✅ System dependencies installed"

# -------------------------------------------------------------
# 3️⃣ Copy configuration + setup scripts
# -------------------------------------------------------------
USER root
WORKDIR /home/devuser/experimental

COPY experimental/config/ ./config/
COPY experimental/extra_tools.sh ./extra_tools.sh
COPY experimental/plugins/ ./plugins/

RUN mkdir -p /root/.local/bin \
  && chmod +x ./extra_tools.sh ./plugins/*.sh \
  && ./extra_tools.sh \
  && echo "✅ Base tools setup completed"

# -------------------------------------------------------------
# 4️⃣ Optional Plugin Installs
# -------------------------------------------------------------
# Keep root for system-wide installs
RUN if [ "${INCLUDE_TERRAFORM:-false}" = "true" ]; then \
  bash ./plugins/terraform_setup.sh && echo "✅ Terraform installed"; \
  fi

RUN if [ "${INCLUDE_GCLOUD:-false}" = "true" ]; then \
  bash ./plugins/gcloud_setup.sh && echo "✅ GCloud SDK installed"; \
  fi

RUN if [ "${INCLUDE_AZURE:-false}" = "true" ]; then \
  bash ./plugins/azure_setup.sh && echo "✅ Azure CLI installed"; \
  fi

RUN if [ "${INCLUDE_GITHUB_CLI:-false}" = "true" ]; then \
  bash ./plugins/github_cli_setup.sh && echo "✅ GitHub CLI installed"; \
  fi

# Switch to devuser at the end
USER devuser

# -------------------------------------------------------------
# ✅ Entrypoint
# -------------------------------------------------------------
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["zsh"]
