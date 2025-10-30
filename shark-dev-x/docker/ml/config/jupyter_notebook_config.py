# 📓 Jupyter Notebook Configuration
import os
from notebook.auth import passwd

c = get_config()

# Allow connections from anywhere
c.NotebookApp.ip = "0.0.0.0"
c.NotebookApp.port = int(os.getenv("JUPYTER_PORT", "8888"))
c.NotebookApp.open_browser = False

# Authentication
c.NotebookApp.password = passwd(os.getenv("JUPYTER_PASSWORD", "mlpass"))
c.NotebookApp.token = ""

# Notebook directory
c.NotebookApp.notebook_dir = "/home/devuser/ml"

# Performance + UI tweaks
c.NotebookApp.allow_root = True
c.NotebookApp.terminado_settings = {"shell_command": ["/bin/zsh"]}
