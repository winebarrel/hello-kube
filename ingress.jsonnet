{
  apiVersion: 'extensions/v1beta1',
  kind: 'Ingress',
  metadata: {
    name: 'ingress',
    annotations: {
      'kubernetes.io/ingress.class': 'alb',
      'alb.ingress.kubernetes.io/inbound-cidrs': std.join(',', ['0.0.0.0/0']),
      'alb.ingress.kubernetes.io/scheme': 'internet-facing',
      'alb.ingress.kubernetes.io/listen-ports': std.toString([{ HTTP: 80 }, { HTTPS: 443 }]),
      'alb.ingress.kubernetes.io/certificate-arn': 'arn:aws:acm:ap-northeast-1:822997939312:certificate/6d8ac2b0-a7ab-4d47-b392-2341d375d116',  // *.winebarrel.work
      'alb.ingress.kubernetes.io/actions.ssl-redirect': std.toString({ Type: 'redirect', RedirectConfig: { Protocol: 'HTTPS', Port: '443', StatusCode: 'HTTP_301' } }),
      'alb.ingress.kubernetes.io/healthcheck-path': '/rack_health',
      'alb.ingress.kubernetes.io/security-groups': std.join(
        ',',
        [
          'sg-00a2f88dd8e90d563',  // eks-winebarrel-alb-ingress
        ]
      ),
    },
    labels: {
      app: 'hello-app',
    },
  },
  spec: {
    rules: [
      {
        host: 'hello.winebarrel.work',
        http: {
          paths: [
            {
              path: '/*',
              backend: {
                serviceName: 'ssl-redirect',
                servicePort: 'use-annotation',
              },
            },
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
