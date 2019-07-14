{
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'hello-app-nginx',
  },
  spec: {
    ports: [
      {
        port: 80,
        targetPort: 'hello-app-nginx',
      },
    ],
    type: 'NodePort',
    selector: {
      app: 'hello-app-nginx',
    },
  },
}
