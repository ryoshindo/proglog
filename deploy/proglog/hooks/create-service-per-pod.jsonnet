function(request) {
    local statefulset = request.object,
    local labelKey = statefulset.metadata.annotations["service-per-pod-label"],
    local ports = statefulset.metadata.annotations["service-per-pod-ports"],

    attachments: [
        {
            apiVersion: "v1",
            kind: "Service",
            metadata: {
                name: statefulset.metadata.name + "-" + index,
                labels: {app: "service-per-pod"},
            },
            spec: {
                type: "LoadBalancer",
                selector: {
                    [labelKey]: statefulset.metadata.name + "-" + index
                },
                ports: [
                    {
                        local ports = std.split(portnums, ":"),
                        port: std.parseInt(ports[0]),
                        targetPort: std.parseInt(ports[1]),
                    }
                    for portnums in std.split(ports, ",")
                ]
            }
        }
        for index in std.range(0, statefulset.spec.replicas - 1)
    ]
}