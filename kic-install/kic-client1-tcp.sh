# Expose TCP Stream port
kubectl patch deploy -n kong-client1 kong-client1-gateway --patch '{
   "spec": {
     "template": {
       "spec": {
         "containers": [
           {
             "name": "proxy",
             "env": [
               {
                 "name": "KONG_STREAM_LISTEN",
                 "value": "0.0.0.0:9000, 0.0.0.0:9443 ssl"
               }
             ],
             "ports": [
               {
                 "containerPort": 9000,
                 "name": "stream9000",
                 "protocol": "TCP"
               },
               {
                 "containerPort": 9443,
                 "name": "stream9443",
                 "protocol": "TCP"
               }
             ]
           }
         ]
       }
     }
   }
 }'


 kubectl patch service -n kong-client1 kong-client1-gateway-proxy --patch '{
 "spec": {
   "ports": [
     {
       "name": "stream9000",
       "port": 9000,
       "protocol": "TCP",
       "targetPort": 9000
     },
     {
       "name": "stream9443",
       "port": 9443,
       "protocol": "TCP",
       "targetPort": 9443
     }
   ]
 }
}'
