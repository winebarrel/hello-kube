{
  apiVersion: 'autoscaling/v2beta1',
  kind: 'HorizontalPodAutoscaler',
  metadata: {
    name: 'hello-app-hpa',
  },
  spec: {
    maxReplicas: 30,
    metrics: [
      {
        resource: {
          name: 'cpu',
          targetAverageUtilization: 50,
        },
        type: 'Resource',
      },
    ],
    minReplicas: 1,
    scaleTargetRef: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      name: 'hello-app',
    },
  },
}
