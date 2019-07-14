{
  apiVersion: 'extensions/v1beta1',
  kind: 'Deployment',
  metadata: {
    name: 'external-dns',
    namespace: 'kube-system',
  },
  spec: {
    strategy: {
      type: 'Recreate',
    },
    template: {
      metadata: {
        labels: {
          app: 'external-dns',
        },
      },
      spec: {
        containers: [
          {
            args: [
              '--source=service',
              '--source=ingress',
              '--domain-filter=winebarrel.work',
              '--provider=aws',
              '--policy=sync',
              '--registry=txt',
              '--txt-owner-id=ZD3IZM0RVSMC2',
            ],
            image: 'registry.opensource.zalan.do/teapot/external-dns:v0.5.18',
            name: 'external-dns',
          },
        ],
        securityContext: {
          fsGroup: 65534,
        },
        serviceAccountName: 'external-dns',
      },
    },
  },
}
