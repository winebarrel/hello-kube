{
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'hello-app',
  },
  spec: {
    type: 'ClusterIP',
    ports: [
      {
        port: 3000,
      },
    ],
    selector: {
      app: 'hello-app',
    },
  },
}
