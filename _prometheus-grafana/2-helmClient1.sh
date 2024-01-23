helm upgrade kong-client1 kong/ingress -n kong-client1 --set gateway.serviceMonitor.enabled=true --set gateway.serviceMonitor.labels.release=promstack
