{
  apiVersion: 'v1',
  data: {
    mapRoles: importstr 'aws-auth-map-roles.yaml',
    mapUsers: importstr 'aws-auth-map-users.yaml',
  },
  kind: 'ConfigMap',
  metadata: {
    name: 'aws-auth',
    namespace: 'kube-system',
  },
}
