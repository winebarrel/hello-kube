{
  apiVersion: 'apps/v1',
  kind: 'DaemonSet',
  metadata: {
    name: 'kube2iam',
    namespace: 'kube-system',
    labels: {
      app: 'kube2iam',
    },
  },
  spec: {
    selector: {
      matchLabels: {
        name: 'kube2iam',
      },
    },
    template: {
      metadata: {
        labels: {
          name: 'kube2iam',
        },
      },
      spec: {
        serviceAccountName: 'kube2iam',
        hostNetwork: true,
        containers: [
          {
            image: 'jtblin/kube2iam:latest',
            name: 'kube2iam',
            args: [
              '--auto-discover-base-arn',
              '--iptables=true',
              '--host-ip=$(HOST_IP)',
              '--node=$(NODE_NAME)',
              '--host-interface=eni+',
            ],
            env: [
              {
                name: 'HOST_IP',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'status.podIP',
                  },
                },
              },
              {
                name: 'NODE_NAME',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'spec.nodeName',
                  },
                },
              },
            ],
            ports: [
              {
                containerPort: 8181,
                hostPort: 8181,
                name: 'http',
              },
            ],
            securityContext: {
              privileged: true,
            },
          },
        ],
      },
    },
  },
}
