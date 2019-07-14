{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      'k8s-app': 'metrics-server',
    },
    name: 'metrics-server',
    namespace: 'kube-system',
  },
  spec: {
    selector: {
      matchLabels: {
        'k8s-app': 'metrics-server',
      },
    },
    template: {
      metadata: {
        labels: {
          'k8s-app': 'metrics-server',
        },
        name: 'metrics-server',
      },
      spec: {
        containers: [
          {
            args: [
              '--cert-dir=/tmp',
              '--secure-port=4443',
              '--kubelet-insecure-tls',
            ],
            image: 'k8s.gcr.io/metrics-server-amd64:v0.3.6',
            imagePullPolicy: 'Always',
            name: 'metrics-server',
            ports: [
              {
                containerPort: 4443,
                name: 'main-port',
                protocol: 'TCP',
              },
            ],
            securityContext: {
              readOnlyRootFilesystem: true,
              runAsNonRoot: false,
            },
            volumeMounts: [
              {
                mountPath: '/tmp',
                name: 'tmp-dir',
              },
            ],
          },
        ],
        serviceAccountName: 'metrics-server',
        volumes: [
          {
            emptyDir: {},
            name: 'tmp-dir',
          },
        ],
      },
    },
  },
}
