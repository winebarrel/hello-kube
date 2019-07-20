{
  apiVersion: 'extensions/v1beta1',
  kind: 'Ingress',
  metadata: {
    name: 'ingress',
    annotations: {
      'kubernetes.io/ingress.class': 'alb',
      'alb.ingress.kubernetes.io/inbound-cidrs': std.join(',', ['0.0.0.0/0']),
      'alb.ingress.kubernetes.io/scheme': 'internet-facing',
    },
    labels: {
      app: 'hello-app',
    },
  },
  spec: {
    rules: [
      {
        http: {
          paths: [
            {
              path: '/*',
              backend: {
                serviceName: 'hello-app',
                servicePort: 80,
              },
            },
          ],
        },
      },
    ],
  },
}
