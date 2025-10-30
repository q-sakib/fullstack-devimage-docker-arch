# ===================================================================
# 🧪 ML/AI Development Image (Python + Jupyter + ML libraries)
# ===================================================================

FROM docker/base/debian-base AS ml

LABEL maintainer="DevOps Toolkit <devops@local>"
LABEL description="Python ML container with Jupyter, TensorFlow, PyTorch, Pandas, NumPy, etc."

# -------------------------------------------------------------
# 1️⃣ Shared scripts and environment
# -------------------------------------------------------------
COPY ../shared/user_setup.sh /tmp/user_setup.sh
COPY ../shared/common_env.sh /tmp/common_env.sh
COPY ../shared/zsh_aliases /tmp/zsh_aliases
COPY ../shared/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /tmp/user_setup.sh /usr/local/bin/entrypoint.sh \
  && /tmp/user_setup.sh \
  && echo "✅ Shared scripts executed" \
  && echo "source /tmp/common_env.sh" >> ~/.zshrc \
  && echo "source /tmp/zsh_aliases" >> ~/.zshrc

USER root

# -------------------------------------------------------------
# 2️⃣ System dependencies
# -------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential python3-dev python3-venv python3-pip \
  curl wget git unzip libgl1-mesa-glx libjpeg-dev zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && echo "✅ System dependencies installed"

USER devuser
WORKDIR /home/devuser/ml

# -------------------------------------------------------------
# 3️⃣ Python virtual environment
# -------------------------------------------------------------
RUN python3 -m venv ml-env \
  && ./ml-env/bin/pip install --upgrade "pip<23" "setuptools<65" wheel \
  && echo "✅ Python virtualenv created and pip/setuptools/wheel upgraded"

# -------------------------------------------------------------
# 4️⃣ ML Requirements
# -------------------------------------------------------------
COPY requirements.txt .
RUN ./ml-env/bin/pip install --no-cache-dir -r requirements.txt \
  && echo "✅ ML Python packages installed"

# -------------------------------------------------------------
# 5️⃣ Jupyter Setup
# -------------------------------------------------------------
COPY jupyter_setup.sh /tmp/jupyter_setup.sh
RUN chmod +x /tmp/jupyter_setup.sh \
  && /tmp/jupyter_setup.sh \
  && echo "✅ Jupyter setup complete"

# -------------------------------------------------------------
# 6️⃣ Copy config files
# -------------------------------------------------------------
COPY config/ config/
RUN echo "✅ Config files copied"

# -------------------------------------------------------------
# ✅ Ports & Entrypoint
# -------------------------------------------------------------
EXPOSE 8888
ENTRYPOINT ["entrypoint.sh"]
CMD ["zsh"]
