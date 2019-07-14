{
  kind: "ConfigMap",
  apiVersion: "v1",
  metadata: {
    name: "common-cm",
    namespace: "staging",
    creationTimestamp: null,
  },
  data: {
    MYSQL_DATABASE: "hello-app",
    MYSQL_USER: "scott",
  },
}
