{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'db',
    labels: {
      app: 'db',
    },
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'db',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'db',
        },
      },
      spec: {
        containers: [
          {
            image: 'mysql:5.6',
            name: 'mysql',
            env: [
              {
                name: 'MYSQL_DATABASE',
                valueFrom: {
                  configMapKeyRef: {
                    name: 'common-cm',
                    key: 'MYSQL_DATABASE',
                  },
                },
              },
              {
                name: 'MYSQL_USER',
                valueFrom: {
                  configMapKeyRef: {
                    name: 'common-cm',
                    key: 'MYSQL_USER',
                  },
                },
              },
              {
                name: 'MYSQL_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    name: 'common-secret',
                    key: 'MYSQL_PASSWORD',
                  },
                },
              },
              {
                name: 'MYSQL_ROOT_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    name: 'common-secret',
                    key: 'MYSQL_ROOT_PASSWORD',
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
