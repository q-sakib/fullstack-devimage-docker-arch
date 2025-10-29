#!/bin/bash
set -e

echo "📓 Installing Jupyter and ML libraries..."

# Activate virtualenv
source ./ml-env/bin/activate

# Core ML libraries
pip install --upgrade pip
pip install jupyter notebook ipykernel matplotlib seaborn pandas numpy scikit-learn

# Optional: TensorFlow + PyTorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install tensorflow-cpu

echo "✅ Jupyter + ML libraries installed"
