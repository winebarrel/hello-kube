{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    namespace: "staging",
    name: "hello-db",
    labels: {
      app: "hello-db",
    },
  },
  spec: {
    type: "ClusterIP",
    ports: [
      {
        port: 3306,
      },
    ],
    selector: {
      app: "db",
    },
  },
}
