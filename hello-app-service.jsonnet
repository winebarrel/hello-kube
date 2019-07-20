{
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'hello-app',
  },
  spec: {
    ports: [
      {
        port: 80,
        targetPort: 'hello-app',
      },
    ],
    type: 'NodePort',
    selector: {
      app: 'hello-app',
    },
  },
}
