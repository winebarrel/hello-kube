{
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      app: 'datadog-cluster-agent',
    },
    name: 'datadog-cluster-agent',
  },
  spec: {
    ports: [
      {
        port: 5005,
        protocol: 'TCP',
      },
    ],
    selector: {
      app: 'datadog-cluster-agent',
    },
  },
}
