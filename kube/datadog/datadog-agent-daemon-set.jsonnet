{
  apiVersion: 'extensions/v1beta1',
  kind: 'DaemonSet',
  metadata: {
    name: 'datadog-agent',
  },
  spec: {
    template: {
      metadata: {
        labels: {
          app: 'datadog-agent',
        },
        name: 'datadog-agent',
      },
      spec: {
        containers: [{
          env: [
            {
              name: 'DD_API_KEY',
              value: '2f663557ba16c66cae349a122280d9de',
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
              name: 'KUBERNETES',
              value: 'true',
            },
            {
              name: 'DD_KUBERNETES_KUBELET_HOST',
              valueFrom: {
                fieldRef: {
                  fieldPath: 'status.hostIP',
                },
              },
            },
            {
              name: 'DD_CLUSTER_AGENT_ENABLED',
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
          image: 'datadog/agent:latest',
          imagePullPolicy: 'Always',
          livenessProbe: {
            exec: {
              command: [
                './probe.sh',
              ],
            },
            initialDelaySeconds: 15,
            periodSeconds: 5,
          },
          name: 'datadog-agent',
          ports: [
            {
              containerPort: 8125,
              name: 'dogstatsdport',
              protocol: 'UDP',
            },
            {
              containerPort: 8126,
              name: 'traceport',
              protocol: 'TCP',
            },
          ],
          resources: {
            limits: {
              cpu: '200m',
              memory: '256Mi',
            },
            requests: {
              cpu: '200m',
              memory: '256Mi',
            },
          },
          volumeMounts: [
            {
              mountPath: '/var/run/docker.sock',
              name: 'dockersocket',
            },
            {
              mountPath: '/host/proc',
              name: 'procdir',
              readOnly: true,
            },
            {
              mountPath: '/host/sys/fs/cgroup',
              name: 'cgroups',
              readOnly: true,
            },
          ],
        }],
        serviceAccountName: 'datadog-agent',
        volumes: [
          {
            hostPath: {
              path: '/var/run/docker.sock',
            },
            name: 'dockersocket',
          },
          {
            hostPath: {
              path: '/proc',
            },
            name: 'procdir',
          },
          {
            hostPath: {
              path: '/sys/fs/cgroup',
            },
            name: 'cgroups',
          },
        ],
      },
    },
  },
}
