# ===================================================================
# 🧪 ML/AI Development Image (Python + Jupyter + ML libraries)
# ===================================================================

FROM docker/base/debian-base AS ml

LABEL maintainer="DevOps Toolkit <devops@local>"
LABEL description="Python ML container with Jupyter, TensorFlow, PyTorch, Pandas, NumPy, etc."

# -------------------------------------------------------------
# 1️⃣ Shared scripts and environment
# -------------------------------------------------------------
USER root

# Copy shared setup scripts from project root
COPY ../shared/user_setup.sh /tmp/user_setup.sh
COPY ../shared/common_env.sh /tmp/common_env.sh
COPY ../shared/zsh_aliases /tmp/zsh_aliases
COPY ../shared/entrypoint.sh /usr/local/bin/entrypoint.sh

# Run shared setup
RUN chmod +x /tmp/user_setup.sh /usr/local/bin/entrypoint.sh \
  && /tmp/user_setup.sh \
  && echo "✅ Shared scripts executed" \
  && echo "source /tmp/common_env.sh" >> /etc/zsh/zshrc \
  && echo "source /tmp/zsh_aliases" >> /etc/zsh/zshrc

# -------------------------------------------------------------
# 2️⃣ System dependencies
# -------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential python3-dev python3-venv python3-pip \
  curl wget git unzip libgl1-mesa-glx libjpeg-dev zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && echo "✅ System dependencies installed"

# -------------------------------------------------------------
# 3️⃣ Switch to non-root user
# -------------------------------------------------------------
USER devuser
WORKDIR /home/devuser/ml

# -------------------------------------------------------------
# 4️⃣ Python virtual environment
# -------------------------------------------------------------
RUN python3 -m venv ml-env \
  && ./ml-env/bin/pip install --upgrade "pip<23" "setuptools<65" wheel \
  && echo "✅ Python virtualenv created and pip/setuptools/wheel upgraded"

# -------------------------------------------------------------
# 5️⃣ ML Requirements
# -------------------------------------------------------------
COPY ml/requirements.txt ./requirements.txt
RUN ./ml-env/bin/pip install --no-cache-dir -r requirements.txt \
  && echo "✅ ML Python packages installed"

# -------------------------------------------------------------
# 6️⃣ Jupyter Setup
# -------------------------------------------------------------
USER root
COPY ml/jupyter_setup.sh /tmp/jupyter_setup.sh
RUN chmod +x /tmp/jupyter_setup.sh \
  && /tmp/jupyter_setup.sh \
  && echo "✅ Jupyter setup complete"

# Switch back to non-root user
USER devuser
WORKDIR /home/devuser/ml


# -------------------------------------------------------------
# 7️⃣ Copy config files
# -------------------------------------------------------------
COPY ml/config/ ./config/
RUN echo "✅ Config files copied"

# -------------------------------------------------------------
# ✅ Ports & Entrypoint
# -------------------------------------------------------------
EXPOSE 8888
ENTRYPOINT ["entrypoint.sh"]
CMD ["zsh"]
