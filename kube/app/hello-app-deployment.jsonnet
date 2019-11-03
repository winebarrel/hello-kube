{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'hello-app',
    labels: {
      app: 'hello-app',
    },
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'hello-app',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'hello-app',
        },
      },
      spec: {
        containers: [
          {
            image: '822997939312.dkr.ecr.ap-northeast-1.amazonaws.com/hello-app:latest',
            imagePullPolicy: 'Always',
            name: 'hello-app',
            ports: [
              {
                name: 'hello-app',
                containerPort: 3000,
              },
            ],
            resources: {
              requests: {
                memory: '128Mi',
                cpu: '250m',
              },
              limits: {
                memory: '256Mi',
                cpu: '500m',
              },
            },
            env: [
              {
                name: 'RAILS_ENV',
                value: 'development',
              },
              {
                name: 'DATABASE_HOST',
                value: 'hello-db',
              },
              {
                name: 'DATABASE_NAME',
                valueFrom: {
                  configMapKeyRef: {
                    name: 'common-cm',
                    key: 'MYSQL_DATABASE',
                  },
                },
              },
              {
                name: 'DATABASE_USER',
                valueFrom: {
                  configMapKeyRef: {
                    name: 'common-cm',
                    key: 'MYSQL_USER',
                  },
                },
              },
              {
                name: 'DATABASE_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    name: 'common-secret',
                    key: 'MYSQL_PASSWORD',
                  },
                },
              },
              {
                name: 'ROLLBAR_ACCESS_TOKEN',
                valueFrom: {
                  secretKeyRef: {
                    name: 'common-secret',
                    key: 'ROLLBAR_ACCESS_TOKEN',
                  },
                },
              },
            ],
          },
        ],
      },
    },
  },
}
