## 1. Frontend and Backend Containerization Comparison

  --------------------------------------------------------------------------------------
  Area                    Frontend                               Backend
  ----------------------- -------------------------------------- -----------------------
  Application             React/Vite                             Node.js

  Build stages            2                                      2

  Builder base            `node:20-alpine`                       `node:20-alpine`

  Main build operation    `npm run build`                        Production dependency
                                                                 installation `npm ci --omit=dev`

  Runtime base            `nginxinc/nginx-unprivileged:alpine`   `node:20-alpine`

  Runtime process         Nginx                                  `npm start`

  Port                    8080                                   8000

  Runtime user            Unprivileged Nginx user                `node`

  Special configuration   `nginx.conf`                           `/app/logs`

  detailed explanation  ![frontend](./Frontend/README.md)    ![backend](./Backend/README.md)


   environment    Build-time `VITE_*` arguments                 Application runtime
                                                                 configuration. uses configmaps to pass variables to backend pods
  --------------------------------------------------------------------------------------

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
