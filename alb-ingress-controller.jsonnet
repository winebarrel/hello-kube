{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: 'alb-ingress-controller',
    },
    name: 'alb-ingress-controller',
    namespace: 'kube-system',
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'alb-ingress-controller',
      },
    },
    strategy: {
      rollingUpdate: {
        maxSurge: 1,
        maxUnavailable: 1,
      },
      type: 'RollingUpdate',
    },
    template: {
      metadata: {
        creationTimestamp: null,
        labels: {
          app: 'alb-ingress-controller',
        },
        annotations: {
          'iam.amazonaws.com/role': 'arn:aws:iam::822997939312:role/aws-alb-ingress-controller',
        },
      },
      spec: {
        containers: [
          {
            args: [
              '--ingress-class=alb',
              '--cluster-name=winebarrel',
            ],
            env: null,
            image: '894847497797.dkr.ecr.us-west-2.amazonaws.com/aws-alb-ingress-controller:v1.0.0',
            imagePullPolicy: 'Always',
            name: 'server',
            resources: {
            },
            terminationMessagePath: '/dev/termination-log',
          },
        ],
        dnsPolicy: 'ClusterFirst',
        restartPolicy: 'Always',
        securityContext: {
        },
        terminationGracePeriodSeconds: 30,
        serviceAccountName: 'alb-ingress',
        serviceAccount: 'alb-ingress',
      },
    },
  },
}
