# we always create our base image like arch debian or ubuntu first

succsessful terminal command

docker build -t local-experimental -f Dockerfile .

docker build -t local-appdev -f Dockerfile .

docker build -t my-fullstack --target fullstack .
docker build -t my-ml --target ml .

docker build -t my-appdev --target appdev .

docker build -t my-experimental --target experimental .

 docker build -t super-admin-all --target super-admin-all .

docker build -t local-superset:latest docker/superset
docker build -t local-superset:latest docker

[superset error](https://www.notion.so/superset-error-2a0fa50f35b780738a3fd3818b837571?pvs=21)

docker build -f docker/appdev/Dockerfile -t my-appdev docker/appdev
docker build -f docker/appdev/Dockerfile -t my-appdev docker/appdev

docker build -f docker/ml/Dockerfile -t my-machine-ai docker

docker build -f docker/fullstack/Dockerfile -t my-fullstack-shark docker

docker build -f docker/experimental/Dockerfile -t my-xp-lap docker
