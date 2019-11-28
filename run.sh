docker build -t theeluwin/kei -f Dockerfile .
docker run -it --init --env-file .env theeluwin/kei bash -c 'eks-configure && bash'
