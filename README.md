# kong-EE-2-KICs
Deploy a Kong Ingress Controller (i.e. KIC) in different namespaces and in the same Kubernetes Cluster.
- The KIC#1 deployed in` kong-client1` watches K8s events of `client1` namespace
- The KIC#2 deployed in `kong-client2` watches K8s events of `client2` namespace

## Create the `client1` and `client2` namespaces
```sh
kubectl create ns client1
kubectl create ns client2
```

## Create the `kong-client1` and `kong-client2` namespaces
```sh
kubectl create ns kong-client1
kubectl create ns kong-client2
```

## Deploy the KIC: Controller + Gateway
The KIC deployment creates 2 PODs: a Controller POD watching the Kubernetes evnts and pushing the configuration to the Gateway POD (in charge of proxifying the API traffic)
- `kong-client1` namespace
```sh
cd ./kic-install
kubectl apply -f kic-client1-values.yaml
```

- `kong-client2` namespace
```sh
cd ./kic-install
kubectl apply -f kic-client2-values.yaml
```

## Configure KIC: enable the TCP Stream
- `kong-client1` namespace
```sh
cd ./kic-install
kubectl apply -f kic-client1-tcp.sh
```

## Deploy Prometheus and Grafana in `monitoring` namespace
This deployment creates an instance of Prometheus and Grafana in a shared namespace called `monitoring`
```sh
cd ./_prometheus-grafana
./1-install.sh
./2-helmClient1.sh
./2-helmClient2.sh
./3-exposeLB.sh
```

## Create the Applications deployment in `client1` and `client2` namespace
1) `Httpbin` deployment. This deployment creates an `httpbin` service listening on 8080 port
- `client1` namespace
```sh
cd ./ns-client/client1
kubectl apply -k ./
```
- `client2` namespace
```sh
cd ./ns-client/client2
kubectl apply -k ./
```
2) `Echo` deployment. This deployment creates an `echo` service listening on 1025, 1026, 1027 port
- `client1` namespace
```sh
./ns-client/client1/_echo/1-echo.sh
```
- `client2` namespace
```sh
./ns-client/client2/_echo/1-echo.sh
```
3) `Websocket` deployment. This deployment creates a `websocket-kube-connector` service listening on HTTP 8080 port
- `client1` namespace
```sh
cd ./ns-client/client1/_webSocket
kubectl apply -f manifest.yaml
```

4) `TCP` deployment. This deployment creates a `tcp-backends` service listening on TCP 23 port
- `client1` namespace
```sh
cd ns-client/client1/_tcp_StarWars
kubectl apply -f 1-starwars.yaml
```

## Create the HTTP Ingress rules
- `client1` namespace
```sh
cd ./ns-client/client1
kubectl apply -f 0a-ingressEcho.yaml
kubectl apply -f 0b-ingressHttpbin.yaml
kubectl apply -f 0f-ingressWebSocket.yaml
```
- `client2` namespace
```sh
cd ./ns-client/client2
kubectl apply -f 0a-ingressEcho.yaml
kubectl apply -f 0b-ingressHttpbin.yaml
```

## Create the TCP Ingress rule
- `client1` namespace
```sh
cd ./ns-client/client1
kubectl apply -f 0g-ingressTCP.yaml
```

## Apply the Kong policies: KongPlugin, KongClusterPlugin, KongUpstreamPolicy
The policies are prefixed with a number: 
- rate-limiting: `1-kongPlugin-rateLimit.yaml`
- API Key: `2a-kongPlugin-ApiKey.yaml`, `2b-Alex-secret.yaml`, `2c-Alex-kongConsumer.yaml`
- cors: `3-cors.yaml`
- etc.

For example: deploy `rate-limiting` plugin for Echo Route
- `client1` namespace
```sh
cd ./ns-client/client1
kubectl apply -f 1-kongPlugin-rateLimit.yaml
vi 0a-ingressEcho.yaml
# Add the plugin in the Ingress annotation:
#   annotations: 
#     konghq.com/strip-plugins: 'client1-rate-limit'
```