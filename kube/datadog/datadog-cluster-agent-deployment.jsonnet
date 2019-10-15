{
  apiVersion: 'extensions/v1beta1',
  kind: 'Deployment',
  metadata: {
    name: 'datadog-cluster-agent',
    namespace: 'default',
  },
  spec: {
    template: {
      metadata: {
        labels: {
          app: 'datadog-cluster-agent',
        },
        name: 'datadog-agent',
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'DD_API_KEY',
                value: '2f663557ba16c66cae349a122280d9de',
              },
              {
                name: 'DD_APP_KEY',
                value: 'e2aaa149602950142ba5e45e41ea8aab24ee2341',
              },
              {
                name: 'DD_COLLECT_KUBERNETES_EVENTS',
                value: 'true',
              },
              {
                name: 'DD_LEADER_ELECTION',
                value: 'true',
              },
              {
                name: 'DD_EXTERNAL_METRICS_PROVIDER_ENABLED',
                value: 'true',
              },
              {
                name: 'DD_CLUSTER_AGENT_AUTH_TOKEN',
                valueFrom: {
                  secretKeyRef: {
                    key: 'token',
                    name: 'datadog-auth-token',
                  },
                },
              },
            ],
            image: 'datadog/cluster-agent:latest',
            imagePullPolicy: 'Always',
            name: 'datadog-cluster-agent',
          },
        ],
        serviceAccountName: 'datadog-cluster-agent',
      },
    },
  },
}
