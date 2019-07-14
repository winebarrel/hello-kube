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
        //annotations: {
        //  'iam.amazonaws.com/role': 'arn:aws:iam::822997939312:role/aws-alb-ingress-controller',
        //},
      },
      spec: {
        containers: [
          {
            name: 'alb-ingress-controller',
            args: [
              '--ingress-class=alb',
              '--cluster-name=winebarrel',
            ],
            image: 'docker.io/amazon/aws-alb-ingress-controller:v1.1.3',
          },
        ],
        serviceAccountName: 'alb-ingress',
      },
    },
  },
}
