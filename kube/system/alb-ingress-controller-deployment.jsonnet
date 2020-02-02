{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      'app.kubernetes.io/name': 'alb-ingress-controller',
    },
    name: 'alb-ingress-controller',
    namespace: 'kube-system',
  },
  spec: {
    selector: {
      matchLabels: {
        'app.kubernetes.io/name': 'alb-ingress-controller',
      },
    },
    template: {
      metadata: {
        labels: {
          'app.kubernetes.io/name': 'alb-ingress-controller',
        },
      },
      spec: {
        containers: [
          {
            name: 'alb-ingress-controller',
            args: [
              '--ingress-class=alb',
              '--cluster-name=winebarrel',
            ],
            image: 'docker.io/amazon/aws-alb-ingress-controller:v1.1.5',
          },
        ],
        serviceAccountName: 'alb-ingress-controller',
      },
    },
  },
}
