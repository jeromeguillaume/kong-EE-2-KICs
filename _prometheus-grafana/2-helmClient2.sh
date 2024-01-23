helm upgrade kong-client2 kong/ingress -n kong-client2 --set gateway.serviceMonitor.enabled=true --set gateway.serviceMonitor.labels.release=promstack
