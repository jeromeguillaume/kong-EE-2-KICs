kubectl -n monitoring expose service prometheus-operated --type=LoadBalancer --name=prometheus-operated-lb
kubectl -n monitoring expose service promstack-grafana --type=LoadBalancer --target-port=3000 --name=promstack-grafana-lb

# Get Grafana admin password
kubectl get secret --namespace monitoring promstack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
