{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'hello-app-nginx',
    labels: {
      app: 'hello-app-nginx',
    },
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'hello-app-nginx',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'hello-app-nginx',
        },
      },
      spec: {
        containers: [
          {
            image: 'nginx:1.17-alpine',
            name: 'hello-app-nginx',
            ports: [
              {
                name: 'hello-app-nginx',
                containerPort: 80,
              },
            ],
            volumeMounts: [
              {
                name: 'nginx-confd',
                mountPath: '/etc/nginx/conf.d/',
              },
            ],
          },
        ],
        volumes: [
          {
            name: 'nginx-confd',
            configMap: {
              name: 'common-cm',
              items: [
                {
                  key: 'nginx_default_conf',
                  path: 'default.conf',
                },
              ],
            },
          },
        ],
      },
    },
  },
}
