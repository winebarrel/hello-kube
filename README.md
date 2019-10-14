# hello-kube

## Getting Started

```sh
cd hello-app
docker-compose build
docker-compose run app env DATABASE_HOST=db bundle exec rails db:create
docker-compose run app bundle exec rails db:migrate
docker-compose up
open http://localhost:3000/items
```

## Create cluster

```sh
eksctl create cluster \
  --name winebarrel \
  --version 1.14 \
  --region ap-northeast-1 \
  --vpc-public-subnets=subnet-aaa,subnet-bbb \
  --vpc-private-subnets=subnet-ccc,subnet-ddd \
  --without-nodegroup
```



  --node-type t3.small \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 1 \
  --node-ami auto \
  --vpc-public-subnets=subnet-0fce258d88c79de2d,subnet-08432b0de92329415 \
  --vpc-private-subnets=subnet-08edcfbbf03fbdd10,subnet-03b00d77c2be379b5 \
  --ssh-access \
  --ssh-public-key ec2-keypair-name \
  --node-private-networking
```

eksctl create cluster \
  --name cluster-name \
  --version 1.14 \
  --region ap-northeast-1 \
  --node-type t3.small \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 1 \
  --node-ami auto \
  --vpc-public-subnets=subnet-0fce258d88c79de2d,subnet-08432b0de92329415 \
  --vpc-private-subnets=subnet-08edcfbbf03fbdd10,subnet-03b00d77c2be379b5 \
  --ssh-access \
  --ssh-public-key ec2-keypair-name \
  --node-private-networking

## Related links

* https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/
* https://dev.classmethod.jp/cloud/aws/eks-aws-alb-ingress-controller/
* https://github.com/bitnami/kubecfg
* https://github.com/jtblin/kube2iam
