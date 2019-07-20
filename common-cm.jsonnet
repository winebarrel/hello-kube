{
  kind: 'ConfigMap',
  apiVersion: 'v1',
  metadata: {
    name: 'common-cm',
  },
  data: {
    MYSQL_DATABASE: 'hello-app',
    MYSQL_USER: 'scott',
  },
}
