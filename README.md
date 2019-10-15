# hello-kube

## Preparation

```sh
brew install kubernetes-cli
brew install kubecfg
brew install eksctl
aws eks update-kubeconfig --name winebarrel
```

## App Getting Started

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
  --vpc-public-subnets=subnets=subnet-0fce258d88c79de2d,subnet-08432b0de92329415 \
  --vpc-private-subnets=subnet-08edcfbbf03fbdd10,subnet-03b00d77c2be379b5 \
  --without-nodegroup
```

## Create nodegroup

```sh
eksctl create ng -f nodegroup.yaml
```

## tail -f logs

```sh
kubectl logs -l app=hello-app -f
kubectl logs -n kube-system -l app=external-dns -f
kubectl logs -n kube-system -l app.kubernetes.io/name=alb-ingress-controller -f
kubectl logs -n kubernetes-external-secrets -l name=kubernetes-external-secrets -f
```

## Related links

* https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/
* https://dev.classmethod.jp/cloud/aws/eks-aws-alb-ingress-controller/
* https://github.com/bitnami/kubecfg
* https://github.com/jtblin/kube2iam
