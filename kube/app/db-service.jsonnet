{
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'hello-db',
    labels: {
      app: 'hello-db',
    },
  },
  spec: {
    type: 'ClusterIP',
    ports: [
      {
        port: 3306,
      },
    ],
    selector: {
      app: 'db',
    },
  },
}
