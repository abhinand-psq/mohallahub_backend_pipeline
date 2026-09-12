## 1. Frontend and Backend Containerization Comparison

  | Area | Frontend | Backend |
|--------|----------|---------|
| Application | React / Vite | Node.js |
| Build Stages | 2 | 2 |
| Builder Base | `node:20-alpine` | `node:20-alpine` |
| Main Build Operation | `npm run build` | `npm ci --omit=dev` |
| Runtime Base | `nginxinc/nginx-unprivileged:alpine` | `node:20-alpine` |
| Runtime Process | Nginx | `npm start` |
| Port | 8080 | 8000 |
| Runtime User | Unprivileged Nginx User | `node` |
| Special Configuration | `nginx.conf` | `/app/logs` |
| Environment Handling | Build-time `VITE_*` arguments | Runtime configuration via Kubernetes ConfigMaps |
|Detailed Documentation | [Frontend Dockerization README](./Frontend/README.md) | [Backend Dockerization README](./Backend/README.md) |

## 2. Overall Mohalla Container Architecture

The two images have different responsibilities:

``` text
                    MOHALLA APPLICATION
                           |
             +-------------+-------------+
             |                           |
             v                           v
      FRONTEND IMAGE                BACKEND IMAGE
             |                           |
       React/Vite                  Node.js API
             |                           |
       npm run build                 npm start
             |                           |
          Nginx :8080                :8000
             |                           |
             +-------------+-------------+
                           |
                     Kubernetes
                           |
              +------------+------------+
              |                         |
          Frontend Service          Backend Service
              |                         |
          Frontend access          Internal API access
```

The frontend is compiled into static assets and served by Nginx, while
the backend remains a running Node.js application.
