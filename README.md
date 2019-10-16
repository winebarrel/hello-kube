# hello-kube

## Preparation

```sh
brew install kubernetes-cli
brew install kubecfg
brew install eksctl
aws eks update-kubeconfig --name winebarrel
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
kubectl logs -l app=hello-app-nginx -f
kubectl logs -l app=hello-app -f
kubectl logs -n kube-system -l app=external-dns -f
kubectl logs -n kube-system -l app.kubernetes.io/name=alb-ingress-controller -f
kubectl logs -n kubernetes-external-secrets -l name=kubernetes-external-secrets -f
```

## Reload pods

```sh
kubectl set env deploy/hello-app-nginx RELOAD_DATE="$(date)"
kubectl set env deploy/hello-app RELOAD_DATE="$(date)"
```

## Login container

```sh
kubectl exec -it $(kubectl get po -l app=hello-app-nginx --no-headers -o custom-columns=NAME:.metadata.name | head -n 1) sh
kubectl exec -it $(kubectl get po -l app=hello-app --no-headers -o custom-columns=NAME:.metadata.name | head -n 1) bash
```

## App

### Getting Started

```sh
cd hello-app
docker-compose build
docker-compose run app env DATABASE_HOST=db bundle exec rails db:create
docker-compose run app bundle exec rails db:migrate
docker-compose up
open http://localhost:3000/items
```

### Docker build & push

```sh
docker build -t 822997939312.dkr.ecr.ap-northeast-1.amazonaws.com/hello-app:latest .
docker push 822997939312.dkr.ecr.ap-northeast-1.amazonaws.com/hello-app:latest
```

## Related links

* https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/
* https://dev.classmethod.jp/cloud/aws/eks-aws-alb-ingress-controller/
* https://github.com/bitnami/kubecfg
* https://github.com/jtblin/kube2iam
* https://www.datadoghq.com/blog/eks-monitoring-datadog/
