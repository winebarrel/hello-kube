{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: 'cluster-autoscaler',
    },
    name: 'cluster-autoscaler',
    namespace: 'kube-system',
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'cluster-autoscaler',
      },
    },
    template: {
      metadata: {
        annotations: {
          'iam.amazonaws.com/role': 'arn:aws:iam::822997939312:role/cluster-autoscaler',
          'prometheus.io/port': '8085',
          'prometheus.io/scrape': 'true',
        },
        labels: { app: 'cluster-autoscaler' },
      },
      spec: {
        containers: [
          {
            command: [
              './cluster-autoscaler',
              '--v=4',
              '--stderrthreshold=info',
              '--cloud-provider=aws',
              '--skip-nodes-with-local-storage=false',
              '--expander=least-waste',
              '--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/winebarrel',
            ],
            image: 'gcr.io/google-containers/cluster-autoscaler:v1.16.1',
            imagePullPolicy: 'Always',
            name: 'cluster-autoscaler',
            resources: {
              limits: {
                cpu: '100m',
                memory: '300Mi',
              },
              requests: {
                cpu: '100m',
                memory: '300Mi',
              },
            },
            volumeMounts: [
              {
                mountPath: '/etc/ssl/certs/ca-certificates.crt',
                name: 'ssl-certs',
                readOnly: true,
              },
            ],
          },
        ],
        serviceAccountName: 'cluster-autoscaler',
        volumes: [
          {
            hostPath: {
              path: '/etc/ssl/certs/ca-bundle.crt',
            },
            name: 'ssl-certs',
          },
        ],
      },
    },
  },
}
