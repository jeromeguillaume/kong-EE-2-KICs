# kong-EE-2-KICs

## Create the `client1` and `client2` namespaces
```sh
kubectl create ns client1
kubectl create ns client2
```

## Create the deployment in `client1` and `client2` namespace
1) `Httpbin` deployment
This deployment creates an `httpbin` service listening on 8080 port
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
2) `Echo` deployment

This deployment creates an `echo` service listening on 1025, 1026, 1027 port
- `client1` namespace
```sh
./ns-client/client1/_echo/1-echo.sh
```
- `client2` namespace
```sh
./ns-client/client2/_echo/1-echo.sh
```
3) `Websocket` deployment

This deployment creates an `websocket-kube-connector` service listening on 8080 port
- `client1` namespace
```sh
cd ./ns-client/client1/_webSocket
kubectl apply -f manifest.yaml
```

4) `TCP` deployment

This deployment creates an `tcp-backends` service listening on 23 port
- `client1` namespace
```sh
cd ns-client/client1/_tcp_StarWars
kubectl apply -f 1-starwars.yaml
```
