# docker-kei

Docker image for aws kubectl runtime.

쿠버네티스 쓰려니까 무슨 kubectl도 깔아야하고 aws eks 설정도 해야하고 helm도 깔아야하고 나의 brew는 지저분해지고 지구가 폭발하고

암튼 그래서 `k get ns` 같은거 할 일 많을때 딱 그렇게만 런타임을 제공하는 친구.

영어로 쓸걸 그랬나? 도커 이미지에 `TZ=Asia/Seoul` 이미 박혀있는데..

```bash
$ docker pull theeluwin/kei
```

## Build

```bash
$ docker build -t theeluwin/kei -f Dockerfile .
```

## Run

`.env` 파일에 이것저것 설정 해놔야함. 그럼 그걸 읽어서 `aws configure`가 되고 `aws eks`도 해줌. 해준다기보단 해줘야하지만.

`.env` 파일 예시:

```
AWS_ACCESS_KEY_ID=키
AWS_SECRET_ACCESS_KEY=비밀키
AWS_DEFAULT_REGION=지역
AWS_DEFAULT_OUTPUT=json
K8S_CLUSTER_NAME=클러스터이름
```

저렇게는 필수라고 봐도 될듯.

도커 이미지 안에 `eks-configure` bin 파일이 있는데 (`scrips/eks-configure.sh`) 다음과 같은 내용임:

```bash
#!/bin/bash
aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $K8S_CLUSTER_NAME
```

그래서 이걸 실행해주면서 `bash`를 키면 이제 `k get ns` 같은게 되는것.

```bash
docker run -it --init --env-file .env theeluwin/kei bash -c 'eks-configure && bash'
```
