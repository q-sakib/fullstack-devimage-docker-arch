Perfect! I’ll create a **complete, ready-to-use Docker cheat sheet** that incorporates:

* **Shared-compatible build context (`docker`)**
* **All individual stages + root stage**
* **Run commands with proper ports**
* **Shared scripts usage**
* **Dev commands for Bash/PowerShell**
* **Cleanup commands**

Here’s the fully updated version:

---

# **🚀 Full Docker Cheat Sheet (Shared-Compatible)**

## **1️⃣ Build Images**

| Component       | Bash / PowerShell                                                                 |
| --------------- | --------------------------------------------------------------------------------- |
| AppDev          | `docker build -f docker/appdev/Dockerfile -t my-appdev:latest docker`             |
| Fullstack       | `docker build -f docker/fullstack/Dockerfile -t my-fullstack:latest docker`       |
| ML / AI         | `docker build -f docker/ml/Dockerfile -t my-ml:latest docker`                     |
| Experimental    | `docker build -f docker/experimental/Dockerfile -t my-experimental:latest docker` |
| Superset        | `docker build -f docker/superset/Dockerfile -t my-superset:latest docker`         |
| Root All-in-One | `docker build -f docker/Dockerfile -t super-admin-all docker`                     |

> ✅ **Note:** The build context is always `docker` to ensure `COPY ../docker-shared` works in sub-Dockerfiles.

---

## **2️⃣ Run Containers**

| Component       | Bash / PowerShell                                                                                   |
| --------------- | --------------------------------------------------------------------------------------------------- |
| AppDev          | `docker run -it --rm -p 4000:4000 --name appdev-container my-appdev`                                |
| Fullstack       | `docker run -it --rm -p 3000:3000 --name fullstack-container my-fullstack`                          |
| ML / AI         | `docker run -it --rm -p 5000:5000 --name ml-container my-ml`                                        |
| Experimental    | `docker run -it --rm -p 3001:3001 --name experimental-container my-experimental`                    |
| Superset        | `docker run -it --rm -p 8088:8088 --name superset-container my-superset`                            |
| Root All-in-One | `docker run -it --rm -p 8088:8088 -p 3000:3000 -p 5000:5000 --name super-admin-all super-admin-all` |

---

## **3️⃣ Entering the Container (Interactive)**

```bash
docker run -it --rm my-fullstack /bin/bash       # Bash
docker run -it --rm my-ml /bin/bash
docker run -it --rm my-appdev /bin/bash
docker run -it --rm my-experimental /bin/bash
docker run -it --rm my-superset /bin/bash
docker run -it --rm super-admin-all /bin/bash
```

> PowerShell: same command.

---

## **4️⃣ Shared Scripts**

All shared scripts are under `/opt/docker-shared` inside the container:

```bash
# List all shared scripts
ls /opt/docker-shared

# Run update scripts
bash /opt/docker-shared/update_shared.sh fullstack
bash /opt/docker-shared/update_shared.sh ml
bash /opt/docker-shared/update_shared.sh appdev
bash /opt/docker-shared/update_shared.sh experimental
bash /opt/docker-shared/update_shared.sh superset
```

PowerShell:

```powershell
# List shared scripts
Get-ChildItem -Path /opt/docker-shared

# Run update scripts via Bash
bash /opt/docker-shared/update_shared.sh fullstack
bash /opt/docker-shared/update_shared.sh ml
bash /opt/docker-shared/update_shared.sh appdev
bash /opt/docker-shared/update_shared.sh experimental
bash /opt/docker-shared/update_shared.sh superset
```

---

## **5️⃣ Fullstack (Node.js / Yarn)**

```bash
cd /opt/fullstack

# Install dependencies
yarn install

# Run scripts
node index.js         # Example
npm run dev            # If package.json defines it
```

PowerShell:

```powershell
cd /opt/fullstack
yarn install
node index.js
npm run dev
```

---

## **6️⃣ ML / AI (Python)**

```bash
cd /opt/ml

# Activate Python venv
source /opt/ml-venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run Python scripts
python train.py
jupyter notebook
```

PowerShell:

```powershell
cd /opt/ml
bash -c "source /opt/ml-venv/bin/activate"
python train.py
```

---

## **7️⃣ AppDev (Flutter / Web)**

```bash
cd /opt/appdev

# Add Flutter to PATH
export PATH="$PATH:/opt/flutter/bin"

# Check Flutter
flutter doctor -v

# Run Flutter web app
flutter run -d chrome

# Node / npm commands
npm install
npm start
```

PowerShell:

```powershell
cd /opt/appdev
bash -c "export PATH=\$PATH:/opt/flutter/bin && flutter doctor -v && flutter run -d chrome"
npm install
npm start
```

---

## **8️⃣ Experimental**

```bash
cd /opt/experimental
npm install
node test.js
```

PowerShell:

```powershell
cd /opt/experimental
npm install
node test.js
```

---

## **9️⃣ Superset**

```bash
cd /opt/superset

# Activate venv
source /home/devuser/.superset-venv/bin/activate

# Superset commands
superset db upgrade
superset init
superset run -p 8088 --with-threads --reload --debugger
```

PowerShell:

```powershell
cd /opt/superset
bash -c "source /home/devuser/.superset-venv/bin/activate && superset db upgrade && superset init && superset run -p 8088 --with-threads --reload --debugger"
```

---

## **🔟 Useful Docker Commands**

```bash
# Stop and remove containers
docker rm -f appdev-container fullstack-container ml-container experimental-container superset-container super-admin-all

# Remove images
docker rmi my-appdev:latest my-fullstack:latest my-ml:latest my-experimental:latest my-superset:latest super-admin-all

# List running containers
docker ps

# Tail logs
tail -f /path/to/log.log
```

PowerShell:

```powershell
docker rm -f appdev-container fullstack-container ml-container experimental-container superset-container super-admin-all
docker rmi my-appdev:latest my-fullstack:latest my-ml:latest my-experimental:latest my-superset:latest super-admin-all
Get-Content /path/to/log.log -Wait
```

---

## ✅ **Summary**

1. **Build:** Use the root folder `docker` as context to ensure shared folders work.
2. **Run:** Map ports according to service.
3. **Dev / Scripts:** Use `/opt/docker-shared` scripts and virtual environments.
4. **Cleanup:** Remove containers/images after testing.

---

I can also make a **single ready-to-run script** for **Bash + PowerShell** that:

* Builds all images from the shared-compatible Docker context
* Runs all containers with proper port mappings
* Ensures everything is ready for dev/testing

Do you want me to make that script next?


















Perfect! Let’s create a **single, unified build & run script** that works for **Bash** and can be adapted for **PowerShell**, using the shared-compatible Docker context from your updated cheat sheet.

This script will:

1. **Build all images** (`AppDev`, `Fullstack`, `ML`, `Experimental`, `Superset`, `All-in-One`)
2. **Run containers** with proper port mappings
3. **Keep containers ready for dev/testing**
4. **Allow optional cleanup**

---

# **1️⃣ Bash Script: `docker-all.sh`**

```bash
#!/bin/bash
set -e

# ================================
# Configuration
# ================================
declare -A IMAGES=(
    ["appdev"]="docker/appdev/Dockerfile"
    ["fullstack"]="docker/fullstack/Dockerfile"
    ["ml"]="docker/ml/Dockerfile"
    ["experimental"]="docker/experimental/Dockerfile"
    ["superset"]="docker/superset/Dockerfile"
    ["super-admin-all"]="docker/Dockerfile"
)

declare -A PORTS=(
    ["appdev"]="4000:4000"
    ["fullstack"]="3000:3000"
    ["ml"]="5000:5000"
    ["experimental"]="3001:3001"
    ["superset"]="8088:8088"
    ["super-admin-all"]="8088:8088 3000:3000 5000:5000"
)

# ================================
# Step 1: Build all images
# ================================
echo "==== Building Docker Images ===="
for name in "${!IMAGES[@]}"; do
    echo "Building $name ..."
    docker build -f "${IMAGES[$name]}" -t "my-$name:latest" docker
done

# ================================
# Step 2: Stop and remove old containers
# ================================
echo "==== Cleaning up old containers ===="
for name in "${!IMAGES[@]}"; do
    docker rm -f "$name-container" 2>/dev/null || true
done

# ================================
# Step 3: Run all containers
# ================================
echo "==== Running containers ===="
for name in "${!IMAGES[@]}"; do
    ports=""
    for p in ${PORTS[$name]}; do
        ports+="-p $p "
    done
    echo "Starting $name-container ..."
    docker run -dit $ports --name "$name-container" "my-$name:latest"
done

# ================================
# Step 4: Status
# ================================
echo "==== Containers Status ===="
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}"
```

---

# **2️⃣ Notes for PowerShell Adaptation**

PowerShell commands are mostly similar, but:

* Replace `#!/bin/bash` with PowerShell header
* Use `docker rm -Force` instead of `docker rm -f`
* `docker run -dit` can remain the same
* Loop syntax changes:

```powershell
$IMAGES = @{
    "appdev" = "docker/appdev/Dockerfile"
    "fullstack" = "docker/fullstack/Dockerfile"
    "ml" = "docker/ml/Dockerfile"
    "experimental" = "docker/experimental/Dockerfile"
    "superset" = "docker/superset/Dockerfile"
    "super-admin-all" = "docker/Dockerfile"
}

$PORTS = @{
    "appdev" = "4000:4000"
    "fullstack" = "3000:3000"
    "ml" = "5000:5000"
    "experimental" = "3001:3001"
    "superset" = "8088:8088"
    "super-admin-all" = "8088:8088,3000:3000,5000:5000"
}

foreach ($name in $IMAGES.Keys) {
    Write-Host "Building $name ..."
    docker build -f $IMAGES[$name] -t "my-$name:latest" docker
}

foreach ($name in $IMAGES.Keys) {
    Write-Host "Removing old $name-container ..."
    docker rm -Force "$name-container" -ErrorAction SilentlyContinue
}

foreach ($name in $IMAGES.Keys) {
    $portMappings = $PORTS[$name] -split ","
    $portArgs = $portMappings | ForEach-Object { "-p $_" } | Out-String
    Write-Host "Running $name-container ..."
    docker run -dit $portArgs --name "$name-container" "my-$name:latest"
}

docker ps
```

---

✅ **Features of this Script**

* Fully automated build + run workflow
* Ports correctly mapped for all services
* Old containers automatically cleaned up
* Ready for dev/testing without manual commands

---

I can also extend this into a **“Dev Mode” script** that mounts **local folders** into the container for live updates, just like `docker-compose` style, but **without requiring docker-compose**. This is perfect for AppDev, Fullstack, or ML workflows.

Do you want me to make that dev/live-update version next?




Perfect! Now let’s create a **“Dev Mode” version** of the cheat sheet and script. This version allows **live updates from your host machine** to the containers, so you can code in your local editor and see changes instantly, without rebuilding the image every time.

We'll handle **volume mounts for `/opt/...` directories**, shared scripts, and also map ports for live access.

---

# **1️⃣ Bash: Dev Mode Script (`docker-dev.sh`)**

```bash
#!/bin/bash
set -e

# ================================
# Configuration
# ================================
declare -A IMAGES=(
    ["appdev"]="docker/appdev/Dockerfile"
    ["fullstack"]="docker/fullstack/Dockerfile"
    ["ml"]="docker/ml/Dockerfile"
    ["experimental"]="docker/experimental/Dockerfile"
    ["superset"]="docker/superset/Dockerfile"
)

declare -A PORTS=(
    ["appdev"]="4000:4000"
    ["fullstack"]="3000:3000"
    ["ml"]="5000:5000"
    ["experimental"]="3001:3001"
    ["superset"]="8088:8088"
)

# ================================
# Step 1: Build images (if not built)
# ================================
echo "==== Building Docker Images (Dev Mode) ===="
for name in "${!IMAGES[@]}"; do
    docker build -f "${IMAGES[$name]}" -t "my-$name:dev" docker
done

# ================================
# Step 2: Remove old containers
# ================================
echo "==== Cleaning up old containers ===="
for name in "${!IMAGES[@]}"; do
    docker rm -f "$name-dev-container" 2>/dev/null || true
done

# ================================
# Step 3: Run containers in dev mode
# ================================
echo "==== Running containers in Dev Mode ===="
for name in "${!IMAGES[@]}"; do
    volume_mount="-v $(pwd)/$name:/opt/$name"
    shared_mount="-v $(pwd)/docker/shared:/opt/docker-shared"
    
    # Build port flags
    ports=""
    for p in ${PORTS[$name]}; do
        ports+="-p $p "
    done

    echo "Starting $name-dev-container ..."
    docker run -dit $ports $volume_mount $shared_mount --name "$name-dev-container" "my-$name:dev"
done

# ================================
# Step 4: Status
# ================================
echo "==== Containers Status ===="
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}"
```

---

# **2️⃣ Notes**

1. **Volume Mounts**

   * Mount `$(pwd)/appdev` → `/opt/appdev`
   * Mount `$(pwd)/fullstack` → `/opt/fullstack`
   * Shared scripts mounted to `/opt/docker-shared`

   This allows you to **edit files locally** and have the container see updates immediately.

2. **Port Mappings**

   * AppDev → `4000:4000`
   * Fullstack → `3000:3000`
   * ML → `5000:5000`
   * Experimental → `3001:3001`
   * Superset → `8088:8088`

3. **Shared Scripts**

   * Any updates in `docker/shared` folder will propagate instantly to all containers.

4. **Container Names**

   * `appdev-dev-container`, `fullstack-dev-container`, etc.
   * Avoid conflicts with standard containers.

---

# **3️⃣ PowerShell Dev Mode**

```powershell
$IMAGES = @{
    "appdev" = "docker/appdev/Dockerfile"
    "fullstack" = "docker/fullstack/Dockerfile"
    "ml" = "docker/ml/Dockerfile"
    "experimental" = "docker/experimental/Dockerfile"
    "superset" = "docker/superset/Dockerfile"
}

$PORTS = @{
    "appdev" = "4000:4000"
    "fullstack" = "3000:3000"
    "ml" = "5000:5000"
    "experimental" = "3001:3001"
    "superset" = "8088:8088"
}

foreach ($name in $IMAGES.Keys) {
    Write-Host "Building $name ..."
    docker build -f $IMAGES[$name] -t "my-$name:dev" docker
}

foreach ($name in $IMAGES.Keys) {
    Write-Host "Removing old $name-dev-container ..."
    docker rm -Force "$name-dev-container" -ErrorAction SilentlyContinue
}

foreach ($name in $IMAGES.Keys) {
    $volumeMount = "-v $PWD\$name:/opt/$name"
    $sharedMount = "-v $PWD\docker\shared:/opt/docker-shared"
    $portMappings = $PORTS[$name] -split ","
    $portArgs = $portMappings | ForEach-Object { "-p $_" } | Out-String
    Write-Host "Running $name-dev-container ..."
    docker run -dit $portArgs $volumeMount $sharedMount --name "$name-dev-container" "my-$name:dev"
}

docker ps
```

---

# **4️⃣ Key Advantages**

* Works for **all components**: AppDev, Fullstack, ML, Experimental, Superset
* Automatically **mounts local folders** for live updates
* Shared scripts folder is synced for all containers
* Dev mode containers can be stopped, restarted, or removed without rebuilding images

---

I can also create a **full unified cheatsheet** combining:

* Build commands
* Dev mode commands
* Run commands
* Shared scripts usage
* Cleanup

All in **one table**, ready for copy-paste in Bash and PowerShell.

Do you want me to create that ultimate cheat sheet next?













Perfect! Now let’s create the **ultimate unified cheat sheet** for your multi-component Docker environment. This version will cover:

* **Build commands** (with shared-compatible context)
* **Run / Dev mode commands** (with volume mounts and ports)
* **Shared scripts usage**
* **Cleanup commands**

Everything will be ready for **Bash and PowerShell** side-by-side.

---

# **🌟 Multi-Component Docker Cheat Sheet**

| Component        | Build (Bash / PowerShell)                                                         | Run / Dev Mode (Bash / PowerShell)                                                                                                                                     | Shared Scripts (Bash / PowerShell)                                                            | Cleanup (Bash / PowerShell)                                                  |
| ---------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **AppDev**       | `docker build -f docker/appdev/Dockerfile -t my-appdev:latest docker`             | `docker run -it -p 4000:4000 -v $(pwd)/appdev:/opt/appdev -v $(pwd)/docker/shared:/opt/docker-shared --name appdev-container my-appdev:latest`                         | `bash /opt/docker-shared/update_shared.sh appdev`<br>`Get-ChildItem /opt/docker-shared`       | `docker rm -f appdev-container`<br>`docker rmi my-appdev:latest`             |
| **Fullstack**    | `docker build -f docker/fullstack/Dockerfile -t my-fullstack:latest docker`       | `docker run -it -p 3000:3000 -v $(pwd)/fullstack:/opt/fullstack -v $(pwd)/docker/shared:/opt/docker-shared --name fullstack-container my-fullstack:latest`             | `bash /opt/docker-shared/update_shared.sh fullstack`<br>`Get-ChildItem /opt/docker-shared`    | `docker rm -f fullstack-container`<br>`docker rmi my-fullstack:latest`       |
| **ML / AI**      | `docker build -f docker/ml/Dockerfile -t my-ml:latest docker`                     | `docker run -it -p 5000:5000 -v $(pwd)/ml:/opt/ml -v $(pwd)/docker/shared:/opt/docker-shared --name ml-container my-ml:latest`                                         | `bash /opt/docker-shared/update_shared.sh ml`<br>`Get-ChildItem /opt/docker-shared`           | `docker rm -f ml-container`<br>`docker rmi my-ml:latest`                     |
| **Experimental** | `docker build -f docker/experimental/Dockerfile -t my-experimental:latest docker` | `docker run -it -p 3001:3001 -v $(pwd)/experimental:/opt/experimental -v $(pwd)/docker/shared:/opt/docker-shared --name experimental-container my-experimental:latest` | `bash /opt/docker-shared/update_shared.sh experimental`<br>`Get-ChildItem /opt/docker-shared` | `docker rm -f experimental-container`<br>`docker rmi my-experimental:latest` |
| **Superset**     | `docker build -f docker/superset/Dockerfile -t my-superset:latest docker`         | `docker run -it -p 8088:8088 -v $(pwd)/superset:/opt/superset -v $(pwd)/docker/shared:/opt/docker-shared --name superset-container my-superset:latest`                 | `bash /opt/docker-shared/update_shared.sh superset`<br>`Get-ChildItem /opt/docker-shared`     | `docker rm -f superset-container`<br>`docker rmi my-superset:latest`         |

---

# **⚡ Notes / Usage Tips**

1. **Volume mounts**:

   * Mount your **local code folder** to `/opt/<component>`
   * Mount **shared scripts folder**: `docker/shared` → `/opt/docker-shared`

2. **Dev Mode**:

   * You can start all containers in detached mode with `-dit` and volumes for live updates.
   * For example, Bash:

     ```bash
     docker run -dit -p 3000:3000 -v $(pwd)/fullstack:/opt/fullstack -v $(pwd)/docker/shared:/opt/docker-shared --name fullstack-dev my-fullstack:latest
     ```

3. **Shared Scripts**:

   * Always run `update_shared.sh <component>` after making updates in the shared folder.

4. **Cleanup**:

   * Remove containers and images to save space:

     ```bash
     docker rm -f fullstack-container
     docker rmi my-fullstack:latest
     ```

5. **PowerShell Notes**:

   * Replace `$(pwd)` with `$PWD` in volume mounts.
   * Shared scripts can still be run with Bash:

     ```powershell
     bash -c "/opt/docker-shared/update_shared.sh fullstack"
     ```

---

This cheat sheet is **ready-to-copy** for **all components**, and fully compatible with your **shared folder setup**.

If you want, I can make a **single master Bash/PowerShell script** that will **build all images, run all dev containers, and set up shared scripts automatically** in **one command**, so you never have to type separate docker commands again.

Do you want me to create that next?
