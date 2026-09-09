i found the deployment(replica) issue with 
 kubectl logs frontend-5cfb569fc9-x2lch


 abhinand@abhinand:~/mohalla$ kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8082:80
Forwarding from 127.0.0.1:8082 -> 80
Forwarding from [::1]:8082 -> 80
Handling connection for 8082
Handling connection for 8082