# Activate Superset virtualenv and run Superset CLI commands easily
alias superset="source ~/superset-env/bin/activate && superset"

# Start Superset server with DB upgrade and init (quick dev start)
alias superset-start="superset db upgrade && superset init && superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger"

# Upgrade the Superset DB migrations
alias superset-db-upgrade="superset db upgrade"

# Initialize Superset (creates default roles, permissions, etc.)
alias superset-init="superset init"

# Start Superset web server only (no DB upgrade/init)
alias superset-run="superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger"

# Run the Superset worker (for async tasks)
alias superset-worker="celery --app=superset.tasks.celery_app:app worker --pool=solo -O fair --loglevel=INFO"

# Restart Superset services (db upgrade + init + run server + worker)
alias superset-restart="superset-db-upgrade && superset-init && superset-run & superset-worker &"

# Stop Superset worker (find and kill celery worker processes)
alias superset-worker-stop="pkill -f 'celery.*worker'"

# Show Superset logs (web server)
alias superset-logs="tail -f ~/superset.log"

# Show Celery worker logs
alias superset-worker-logs="tail -f ~/celery.log"

# Quick check for Superset version
alias superset-version="superset version"

# Activate virtualenv only (for running other Python commands)
alias superset-venv="source ~/superset-env/bin/activate"
# alias superset="source $HOME/superset-env/bin/activate && superset"

