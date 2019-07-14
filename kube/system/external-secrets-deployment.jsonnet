{
  apiVersion: 'extensions/v1beta1',
  kind: 'Deployment',
  metadata: {
    labels: {
      name: 'kubernetes-external-secrets',
    },
    name: 'kubernetes-external-secrets',
    namespace: 'kubernetes-external-secrets',
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        name: 'kubernetes-external-secrets',
      },
    },
    template: {
      metadata: {
        annotations: {
          'iam.amazonaws.com/role': 'arn:aws:iam::822997939312:role/kube-external-secrets',
        },
        labels: {
          name: 'kubernetes-external-secrets',
          service: 'kubernetes-external-secrets',
        },
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'AWS_REGION',
                value: 'ap-northeast-1',
              },
            ],
            image: 'godaddy/kubernetes-external-secrets:1.5.0',
            imagePullPolicy: 'Always',
            name: 'kubernetes-external-secrets',
          },
        ],
        serviceAccountName: 'kubernetes-external-secrets-service-account',
      },
    },
  },
}
