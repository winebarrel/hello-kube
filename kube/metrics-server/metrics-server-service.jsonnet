{
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      'kubernetes.io/cluster-service': 'true',
      'kubernetes.io/name': 'Metrics-server',
    },
    name: 'metrics-server',
    namespace: 'kube-system',
  },
  spec: {
    ports: [
      {
        port: 443,
        protocol: 'TCP',
        targetPort: 'main-port',
      },
    ],
    selector: {
      'k8s-app': 'metrics-server',
    },
  },
}
