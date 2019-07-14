{
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'hello-service',
  },
  secretDescriptor: {
    backendType: 'systemManager',
    data: [
      {
        key: '/hello/password',
        name: 'PASSWORD',
      },
    ],
  },
}
