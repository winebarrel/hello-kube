{
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    annotations: {
      'iam.amazonaws.com/permitted': 'arn:aws:iam::822997939312:role/.*',
     },
    name: 'kubernetes-external-secrets',
  },
}
